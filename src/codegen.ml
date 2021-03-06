(* Code generation: translate takes a semantically checked AST and
produces LLVM IR

LLVM tutorial: Make sure to read the OCaml version of the tutorial

http://llvm.org/docs/tutorial/index.html

Detailed documentation on the OCaml LLVM library:

http://llvm.moe/
http://llvm.moe/ocaml/

*)

module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

(* translate : Sast.program -> Llvm.module *)
let translate (globals, functions) =
  let context    = L.global_context () in

  (* Create the LLVM compilation module into which
     we will generate code *)
  let the_module = L.create_module context "PolyWiz" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and i1_t       = L.i1_type     context
  and float_t    = L.double_type context
  and void_t     = L.void_type   context in

  (* String type *)
  let string_t = L.pointer_type i8_t in

  (* Poly type *)
  let poly_t = L.pointer_type float_t in

  (* array types *)
  let float_arr_t = L.pointer_type float_t in
  let int_arr_t = L.pointer_type i32_t in
  let string_arr_t = L.pointer_type string_t in
  let bool_arr_t = L.pointer_type i1_t in
  let poly_arr_t = L.pointer_type poly_t in

(* Return the LLVM type for a PolyWiz type *)
  let rec ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | A.Float -> float_t
    | A.Void  -> void_t
    | A.String -> string_t
    | A.Poly -> poly_t
    | A.Array(t) -> L.pointer_type (ltype_of_typ t)
  in

  (* Array creation, initialization, indexing
     Note: Beets (2017) was very helpful here since their arrays are similar to ours
     So we'd like to cite their code for this part*)
  let ci = L.const_int i32_t in
  let new_arr t len builder =
    let s_tot = L.build_add (L.build_mul (L.build_intcast
     (L.size_of (ltype_of_typ t)) i32_t "tmp" builder)
     len "tmp" builder) (ci 1) "tmp" builder in
    let arr = L.build_pointercast (L.build_array_malloc (ltype_of_typ t) s_tot "tmp" builder)
     (L.pointer_type (ltype_of_typ t)) "tmp" builder in
    arr in

  let instantiate_arr t elems builder =
    let arr = new_arr t
     (ci (List.length elems)) builder in
    let _ =
      let assign_value i =
        let ind = L.build_add (ci i)
         (ci 0) "tmp" builder in
        L.build_store (List.nth elems i)
         (L.build_gep arr [| ind |] "tmp" builder) builder in
      let n = ((List.length elems)-1) in
        let rec rec_count cnt =
          if cnt = n then ignore (assign_value cnt)
          else (ignore (assign_value cnt); rec_count (cnt+1)) in
        rec_count 0 in

    arr in

  let list_length e =
    (match e with
      (_, SArrayLit(l)) -> List.length l
      | _ -> 0
    ) in

  (* Create a map of global variables after creating each *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m (t, n) =
      let init = match t with
          A.Float -> L.const_float (ltype_of_typ t) 0.0
        | _ -> L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in

  let printf_t : L.lltype =
      L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
      L.declare_function "printf" printf_t the_module in

  (* Define each function (arguments and return type) so we can
     call it even before we've created its body *)
  let function_decls : (L.llvalue * sfunc_decl) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and formal_types =
	Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sformals)
      in let ftype = L.function_type (ltype_of_typ fdecl.styp) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in

  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder
    and float_format_str = L.build_global_stringptr "%g\n" "fmt" builder
    and str_format_str = L.build_global_stringptr "%s\n" "fmt" builder in

    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p =
        L.set_value_name n p;
	let local = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p local builder);
	StringMap.add n local m

      (* Allocate space for any locally declared variables and add the
       * resulting registers to our map *)
      and add_local m (t, n) =
	let local_var = L.build_alloca (ltype_of_typ t) n builder
	in StringMap.add n local_var m
      in

      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sformals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.slocals
    in

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup n = try StringMap.find n local_vars
                   with Not_found -> StringMap.find n global_vars
    in

    (* Construct code for an expression; return its value *)
    let rec expr builder ((ast_typ, e) : sexpr) = match e with
	SLiteral i  -> L.const_int i32_t i
      | SBoolLit b  -> L.const_int i1_t (if b then 1 else 0)
      | SSliteral l -> L.build_global_stringptr ( String.sub l 1 ((String.length l) - 2)) "str" builder
      | SFliteral l -> L.const_float_of_string float_t l
      | SArrayLit l ->
        let l' = (List.map (expr builder) l) in
        let arr_element_type = function
            A.Array(A.Int) -> A.Int
          | A.Array(A.Float) -> A.Float
          | A.Array(A.Bool) -> A.Bool
          | A.Array(A.String) -> A.String
          | A.Array(A.Poly) -> A.Poly
          | _ -> raise (Failure ("Invalid array type")) in
        let array_type = arr_element_type ast_typ in
        instantiate_arr array_type l' builder
      | SNoexpr     -> L.const_int i32_t 0
      | SId s       -> L.build_load (lookup s) s builder
      | SArrAssignInd (e1, ind, e) -> 
          let e' = expr builder e in
          let ind_llvm = expr builder ind in
          let arr = expr builder e1 in
          ignore (
            (match e1 with
              (A.Array(A.Float), SId(arrName)) -> 
                let set_arr_at_ind_f_external_func = L.declare_function "set_arr_at_ind_f" (L.function_type float_arr_t [|float_arr_t; float_t; i32_t|]) the_module in
                let new_arr = L.build_call set_arr_at_ind_f_external_func [|arr; e'; ind_llvm|] "set_arr_at_ind_f_llvm" builder in
                L.build_store new_arr (lookup arrName) builder
              |(A.Array(A.Int), SId(arrName)) -> 
                let set_arr_at_ind_i_external_func = L.declare_function "set_arr_at_ind_i" (L.function_type int_arr_t [|int_arr_t; i32_t; i32_t|]) the_module in
                let new_arr = L.build_call set_arr_at_ind_i_external_func [|arr; e'; ind_llvm|] "set_arr_at_ind_i_llvm" builder in
                L.build_store new_arr (lookup arrName) builder
              |(A.Array(A.Bool), SId(arrName)) -> 
                let set_arr_at_ind_b_external_func = L.declare_function "set_arr_at_ind_b" (L.function_type bool_arr_t [|bool_arr_t; i1_t; i32_t|]) the_module in
                let new_arr = L.build_call set_arr_at_ind_b_external_func [|arr; e'; ind_llvm|] "set_arr_at_ind_b_llvm" builder in
                L.build_store new_arr (lookup arrName) builder
              | _ -> raise (Failure ("This array type does not support index assignment."))
            )
          ); e'
      | SAssign (s, e) -> let e' = expr builder e in
                          ignore(L.build_store e' (lookup s) builder); e'
      | SBinop (((A.Poly,_ ) as e1), op, ((A.Float,_ ) as e2)) -> (* Binary op where e1 (poly), e2 (float) *)
        let e1' = expr builder e1
        and e2' = expr builder e2 in
        (match op with
            A.Div -> let poly_division_external_func = L.declare_function "poly_division" (L.function_type poly_t [|poly_t; float_t|]) the_module in
                    L.build_call poly_division_external_func [| e1'; e2' |] "poly_division_llvm" builder
          | A.Eval -> let eval_poly_external_func = L.declare_function "eval_poly" (L.function_type float_t [|poly_t; float_t|]) the_module in
                    L.build_call eval_poly_external_func [| e1'; e2' |] "eval_poly_llvm" builder
          | _ -> raise (Failure "This operation is invalid for a poly and float operand.")
        )

      | SBinop (((A.Poly,_ ) as e1), op, ((A.Poly,_ ) as e2)) -> (* Binary op where e1 (poly), e2 (poly) *)
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Add     -> let poly_addition_external_func = L.declare_function "poly_addition" (L.function_type poly_t [|poly_t; poly_t|]) the_module in
                    L.build_call poly_addition_external_func [| e1'; e2' |] "poly_addition_llvm" builder
	  | A.Sub     -> let poly_subtraction_external_func = L.declare_function "poly_subtraction" (L.function_type poly_t [|poly_t; poly_t|]) the_module in
                    L.build_call poly_subtraction_external_func [| e1'; e2' |] "poly_subtraction_llvm" builder
	  | A.Mult    -> let poly_multiplication_external_func = L.declare_function "poly_multiplication" (L.function_type poly_t [|poly_t; poly_t|]) the_module in
                    L.build_call poly_multiplication_external_func [| e1'; e2' |] "poly_multiplication_llvm" builder
	  | A.Compo    -> let poly_composition_external_func = L.declare_function "poly_composition" (L.function_type poly_t [|poly_t; poly_t|]) the_module in
                    L.build_call poly_composition_external_func [| e1'; e2' |] "poly_composition_llvm" builder
    | A.Exp     -> raise (Failure "internal error: semant should have rejected ^ on poly")
	  | A.Equal   -> let equal_compare_poly_external_func = L.declare_function "equal_compare_poly" (L.function_type i1_t [|poly_t; poly_t|]) the_module in
                    L.build_call equal_compare_poly_external_func [| e1'; e2' |] "equal_compare_poly_llvm" builder
	  | A.Neq   -> let nequal_compare_poly_external_func = L.declare_function "nequal_compare_poly" (L.function_type i1_t [|poly_t; poly_t|]) the_module in
                    L.build_call nequal_compare_poly_external_func [| e1'; e2' |] "nequal_compare_poly_llvm" builder
	  | A.Less    -> raise (Failure "internal error: semant should have rejected > on poly")
	  | A.Leq     -> raise (Failure "internal error: semant should have rejected <= on poly")
	  | A.Greater -> raise (Failure "internal error: semant should have rejected > on poly")
	  | A.Geq     -> raise (Failure "internal error: semant should have rejected >= on poly")
	  | A.And | A.Or -> raise (Failure "internal error: semant should have rejected and/or on poly")
    | _ -> raise (Failure "This operation is invalid for two poly operands."))

    | SBinop (((A.Array(arr_typ),_ ) as e1), op, ((A.Int,_ ) as e2)) -> (* Binary op where e1 (array), e2 (int) *)
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Ele_at_ind     -> (
        match arr_typ with
            A.Int -> 
              let arr_at_ind_i_external_func = L.declare_function "arr_at_ind_i" (L.function_type i32_t [|int_arr_t;i32_t|]) the_module in
              L.build_call arr_at_ind_i_external_func [| e1'; e2' |] "arr_at_ind_i_llvm" builder
          | A.Float -> 
              let arr_at_ind_f_external_func = L.declare_function "arr_at_ind_f" (L.function_type float_t [|float_arr_t;i32_t|]) the_module in
              L.build_call arr_at_ind_f_external_func [| e1'; e2' |] "arr_at_ind_f_llvm" builder
          | A.Bool -> 
              let arr_at_ind_b_external_func = L.declare_function "arr_at_ind_b" (L.function_type i1_t [|bool_arr_t;i32_t|]) the_module in
              L.build_call arr_at_ind_b_external_func [| e1'; e2' |] "arr_at_ind_b_llvm" builder
          | _ -> raise (Failure ("This array type does not support indexing."))
      )
      | _ -> raise (Failure ("This operation is invalid for array and int operands."))
    )

      | SBinop (((A.Float,_ ) as e1), op, ((A.Float,_ ) as e2)) -> (* Binary op where e1 (float), e2 (float) *)
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Add     -> L.build_fadd e1' e2' "tmp" builder
	  | A.Sub     -> L.build_fsub e1' e2' "tmp" builder
	  | A.Mult    -> L.build_fmul e1' e2' "tmp" builder
	  | A.Div     -> L.build_fdiv e1' e2' "tmp" builder
    | A.Exp     ->
      let pow_external_func_ff = L.declare_function "pow_operator_ff" (L.function_type float_t [|float_t;float_t|]) the_module in
        L.build_call pow_external_func_ff [| e1'; e2' |] "pow_operator_ff_llvm" builder
	  | A.Equal   -> L.build_fcmp L.Fcmp.Oeq e1' e2' "tmp" builder
	  | A.Neq     -> L.build_fcmp L.Fcmp.One e1' e2' "tmp" builder
	  | A.Less    -> L.build_fcmp L.Fcmp.Olt e1' e2' "tmp" builder
	  | A.Leq     -> L.build_fcmp L.Fcmp.Ole e1' e2' "tmp" builder
	  | A.Greater -> L.build_fcmp L.Fcmp.Ogt e1' e2' "tmp" builder
	  | A.Geq     -> L.build_fcmp L.Fcmp.Oge e1' e2' "tmp" builder
	  | A.And | A.Or -> raise (Failure "internal error: semant should have rejected and/or on float")
    | _ -> raise (Failure "This operation is invalid for two float operands."))

        | SBinop (((A.Float,_ ) as e1), op, ((A.Int,_ ) as e2)) -> (* Binary op where e1 (float), e2 (int) *)
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Add     -> L.build_fadd e1' e2' "tmp" builder
	  | A.Sub     -> L.build_fsub e1' e2' "tmp" builder
	  | A.Mult    -> L.build_fmul e1' e2' "tmp" builder
	  | A.Div     -> L.build_fdiv e1' e2' "tmp" builder
    | A.Exp     ->
      let pow_external_func_fi = L.declare_function "pow_operator_fi" (L.function_type float_t [|float_t;i32_t|]) the_module in
        L.build_call pow_external_func_fi [| e1'; e2' |] "pow_operator_fi_llvm" builder
	  | A.Equal   -> L.build_fcmp L.Fcmp.Oeq e1' e2' "tmp" builder
	  | A.Neq     -> L.build_fcmp L.Fcmp.One e1' e2' "tmp" builder
	  | A.Less    -> L.build_fcmp L.Fcmp.Olt e1' e2' "tmp" builder
	  | A.Leq     -> L.build_fcmp L.Fcmp.Ole e1' e2' "tmp" builder
	  | A.Greater -> L.build_fcmp L.Fcmp.Ogt e1' e2' "tmp" builder
	  | A.Geq     -> L.build_fcmp L.Fcmp.Oge e1' e2' "tmp" builder
	  | A.And | A.Or ->
	      raise (Failure "internal error: semant should have rejected and/or on float")
    | _ -> raise (Failure "This operation is invalid for these operands."))

        | SBinop (((A.Int,_ ) as e1), op, ((A.Float,_ ) as e2)) -> (* Binary op where e1 (int), e2 (float) *)
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Add     -> L.build_fadd e1' e2' "tmp" builder
	  | A.Sub     -> L.build_fsub e1' e2' "tmp" builder
	  | A.Mult    -> L.build_fmul e1' e2' "tmp" builder
	  | A.Div     -> L.build_fdiv e1' e2' "tmp" builder
    | A.Exp     ->
      let pow_external_func_if = L.declare_function "pow_operator_if" (L.function_type float_t [|i32_t;float_t|]) the_module in
        L.build_call pow_external_func_if [| e1'; e2' |] "pow_operator_if_llvm" builder
	  | A.Equal   -> L.build_fcmp L.Fcmp.Oeq e1' e2' "tmp" builder
	  | A.Neq     -> L.build_fcmp L.Fcmp.One e1' e2' "tmp" builder
	  | A.Less    -> L.build_fcmp L.Fcmp.Olt e1' e2' "tmp" builder
	  | A.Leq     -> L.build_fcmp L.Fcmp.Ole e1' e2' "tmp" builder
	  | A.Greater -> L.build_fcmp L.Fcmp.Ogt e1' e2' "tmp" builder
	  | A.Geq     -> L.build_fcmp L.Fcmp.Oge e1' e2' "tmp" builder
	  | A.And | A.Or ->
	      raise (Failure "internal error: semant should have rejected and/or on float")
    | _ -> raise (Failure "This operation is invalid for these operands."))

        | SBinop (((t,_ ) as e1), A.In, ((A.Array(_),_ ) as e2)) -> (* Binary op where op is "in" *)
    let e1' = expr builder e1 in
    let e2' = expr builder e2 in
    (match t with
      A.Int     -> let int_arr_contains_func = L.declare_function "int_arr_contains" (L.function_type i1_t [| i32_t; int_arr_t |]) the_module in
        L.build_call int_arr_contains_func [| e1'; e2'|] "int_arr_contains_llvm" builder
    | A.Float   -> let float_arr_contains_func = L.declare_function "float_arr_contains" (L.function_type i1_t [| float_t; float_arr_t |]) the_module in
      L.build_call float_arr_contains_func [| e1'; e2' |] "float_arr_contains_llvm" builder
    | A.String  -> let string_arr_contains_func = L.declare_function "string_arr_contains" (L.function_type i1_t [| string_t; string_arr_t |]) the_module in
      L.build_call string_arr_contains_func [| e1'; e2' |] "string_arr_contains_llvm" builder
    | A.Poly    -> let poly_arr_contains_func = L.declare_function "poly_arr_contains" (L.function_type i1_t [| poly_t; poly_arr_t |]) the_module in
      L.build_call poly_arr_contains_func [| e1'; e2' |] "poly_arr_contains_llvm" builder
    | _ -> raise (Failure "This operation is invalid for these operands."))

      | SBinop (e1, op, e2) -> (* Binary op where e1, e2 are both ints*)
	  let e1' = expr builder e1
	  and e2' = expr builder e2 in
	  (match op with
	    A.Add     -> L.build_add e1' e2' "tmp" builder
	  | A.Sub     -> L.build_sub e1' e2' "tmp" builder
	  | A.Mult    -> L.build_mul e1' e2' "tmp" builder
    | A.Div     -> L.build_sdiv e1' e2' "tmp" builder
    | A.Exp     ->
      let pow_external_func_ii = L.declare_function "pow_operator_ii" (L.function_type i32_t [|i32_t;i32_t|]) the_module in
        L.build_call pow_external_func_ii [| e1'; e2' |] "pow_operator_ii_llvm" builder
	  | A.And     -> L.build_and e1' e2' "tmp" builder
	  | A.Or      -> L.build_or e1' e2' "tmp" builder
	  | A.Equal   -> L.build_icmp L.Icmp.Eq e1' e2' "tmp" builder
	  | A.Neq     -> L.build_icmp L.Icmp.Ne e1' e2' "tmp" builder
	  | A.Less    -> L.build_icmp L.Icmp.Slt e1' e2' "tmp" builder
	  | A.Leq     -> L.build_icmp L.Icmp.Sle e1' e2' "tmp" builder
	  | A.Greater -> L.build_icmp L.Icmp.Sgt e1' e2' "tmp" builder
	  | A.Geq     -> L.build_icmp L.Icmp.Sge e1' e2' "tmp" builder
    | _ -> raise (Failure "This operation is invalid for these operands.")
	  )
      | SUnop(op, ((t, _) as e)) ->
          let e' = expr builder e in
	  (match op with
	    A.Neg when t = A.Float -> L.build_fneg e' "tmp" builder
    | A.Neg                  -> L.build_neg e' "tmp" builder
    | A.Not                  -> L.build_not e' "tmp" builder
    | A.Const_ret ->
      let constants_retriever_external_func = L.declare_function "constants_retriever" (L.function_type float_arr_t [|poly_t|]) the_module in
      L.build_call constants_retriever_external_func [| e' |] "constants_retriever_llvm" builder
    | A.Abs when t = A.Float ->
      let abs_external_func_floats = L.declare_function "abs_operator_float" (L.function_type float_t [|float_t|]) the_module in
      L.build_call abs_external_func_floats [| e' |] "abs_operator_float_llvm" builder
    | A.Abs                  ->
      let abs_external_func_ints = L.declare_function "abs_operator_int" (L.function_type i32_t [|i32_t|]) the_module in
      L.build_call abs_external_func_ints [| e' |] "abs_operator_int_llvm" builder
    )
      | SCall ("printint", [e]) | SCall ("printb", [e]) ->
	  L.build_call printf_func [| int_format_str ; (expr builder e) |]
	    "printf" builder
      | SCall ("printf", [e]) ->
	  L.build_call printf_func [| float_format_str ; (expr builder e) |]
	    "printf" builder
      | SCall ("printstr", [e]) ->
	  L.build_call printf_func [| str_format_str ; (expr builder e) |] "printf" builder
      | SCall ("new_poly", [e1;e2;e3]) ->
        let e1' = expr builder e1 in
        let e2' = expr builder e2 in
        let e3' = expr builder e3 in
        let new_poly_external_func = L.declare_function "new_poly" (L.function_type poly_t [|float_arr_t; int_arr_t; i32_t|]) the_module in
        L.build_call new_poly_external_func [| e1'; e2'; e3'|] "new_poly_llvm" builder
      | SCall ("poly_at_ind", [e1;e2]) ->
        let poly_at_ind_external_func = L.declare_function "poly_at_ind" (L.function_type float_t [|poly_t; i32_t|]) the_module in
        L.build_call poly_at_ind_external_func [| expr builder e1; expr builder e2 |] "poly_at_ind_llvm" builder
      | SCall ("order", [e]) ->
        let order_external_func = L.declare_function "order" (L.function_type i32_t [|poly_t|]) the_module in
        L.build_call order_external_func [| expr builder e |] "order_llvm" builder
      | SCall ("initialize_floats", [e]) ->
        let initialize_floats_external_func = L.declare_function "initialize_floats" (L.function_type float_arr_t [|i32_t|]) the_module in
        L.build_call initialize_floats_external_func [| expr builder e |] "initialize_floats_llvm" builder
      | SCall ("initialize_ints", [e]) ->
        let initialize_ints_external_func = L.declare_function "initialize_ints" (L.function_type int_arr_t [|i32_t|]) the_module in
        L.build_call initialize_ints_external_func [| expr builder e |] "initialize_ints_llvm" builder
      | SCall ("int_to_float", [e]) ->
        let int_to_float_external_func = L.declare_function "int_to_float" (L.function_type float_t [|i32_t|]) the_module in
        L.build_call int_to_float_external_func [| expr builder e |] "int_to_float_llvm" builder
      | SCall ("to_str", [e]) ->
        let poly_to_str_external_func = L.declare_function "poly_to_str" (L.function_type string_t [|poly_t|]) the_module in
        L.build_call poly_to_str_external_func [| expr builder e |] "poly_to_str_llvm" builder
      | SCall ("tex_document", [e1;e2]) ->
        let print_texdoc_external_func = L.declare_function "generate_texdoc" (L.function_type string_t [|string_arr_t; int_arr_t|]) the_module in
        L.build_call print_texdoc_external_func [| expr builder e1; expr builder e2 |] "print_texdoc_llvm" builder
        | SCall ("print_tex", [e]) ->
        let poly_to_tex_external_func = L.declare_function "poly_to_tex" (L.function_type string_t [|poly_t|]) the_module in
        L.build_call poly_to_tex_external_func [| expr builder e |] "poly_to_tex_llvm" builder
      | SCall ("plot", [e1;e2]) ->
        let e1' = expr builder e1 in
        let e2' = expr builder e2 in
        let len_e1 = L.const_int i32_t (list_length e1) in
        let plot_external_func = L.declare_function "plot" (L.function_type i32_t [|poly_arr_t; i32_t; string_t|]) the_module in
        L.build_call plot_external_func [| e1'; len_e1; e2' |] "plot_llvm" builder
      | SCall ("range_plot", [e1;e2;e3;e4]) ->
        let e1' = expr builder e1 in
        let e2' = expr builder e2 in
        let e3' = expr builder e3 in
        let e4' = expr builder e4 in
        let len_e1 = L.const_int i32_t (list_length e1) in
        let range_plot_external_func = L.declare_function "range_plot" (L.function_type i32_t [|poly_arr_t; i32_t; float_t; float_t; string_t|]) the_module in
        L.build_call range_plot_external_func [| e1'; len_e1; e2'; e3'; e4' |] "range_plot_llvm" builder
      | SCall (f, args) ->
         let (fdef, fdecl) = StringMap.find f function_decls in
	 let llargs = List.rev (List.map (expr builder) (List.rev args)) in
	 let result = (match fdecl.styp with
                        A.Void -> ""
                      | _ -> f ^ "_result") in
         L.build_call fdef (Array.of_list llargs) result builder
    in
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
	Some _ -> ()
      | None -> ignore (instr builder) in

    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)

    let rec stmt builder = function
	SBlock sl -> List.fold_left stmt builder sl
      | SExpr e -> ignore(expr builder e); builder
      | SReturn e -> ignore(match fdecl.styp with
                              (* Special "return nothing" instr *)
                              A.Void -> L.build_ret_void builder
                              (* Build return statement *)
                            | _ -> L.build_ret (expr builder e) builder );
                     builder
      | SIf (predicate, then_stmt, else_stmt) ->
         let bool_val = expr builder predicate in
	 let merge_bb = L.append_block context "merge" the_function in
         let build_br_merge = L.build_br merge_bb in (* partial function *)

	 let then_bb = L.append_block context "then" the_function in
	 add_terminal (stmt (L.builder_at_end context then_bb) then_stmt)
	   build_br_merge;

	 let else_bb = L.append_block context "else" the_function in
	 add_terminal (stmt (L.builder_at_end context else_bb) else_stmt)
	   build_br_merge;

	 ignore(L.build_cond_br bool_val then_bb else_bb builder);
	 L.builder_at_end context merge_bb

      | SWhile (predicate, body) ->
	  let pred_bb = L.append_block context "while" the_function in
	  ignore(L.build_br pred_bb builder);

	  let body_bb = L.append_block context "while_body" the_function in
	  add_terminal (stmt (L.builder_at_end context body_bb) body)
	    (L.build_br pred_bb);

	  let pred_builder = L.builder_at_end context pred_bb in
	  let bool_val = expr pred_builder predicate in

	  let merge_bb = L.append_block context "merge" the_function in
	  ignore(L.build_cond_br bool_val body_bb merge_bb pred_builder);
	  L.builder_at_end context merge_bb

      (* Implement for loops as while loops *)
      | SFor (e1, e2, e3, body) -> stmt builder
	    ( SBlock [SExpr e1 ; SWhile (e2, SBlock [body ; SExpr e3]) ] )
    in

    (* Build the code for each statement in the function *)
    let builder = stmt builder (SBlock fdecl.sbody) in

    (* Add a return if the last block falls off the end *)
    add_terminal builder (match fdecl.styp with
        A.Void -> L.build_ret_void
      | A.Float -> L.build_ret (L.const_float float_t 0.0)
      | t -> L.build_ret (L.const_int (ltype_of_typ t) 0))
  in

  List.iter build_function_body functions;
  the_module
