type token =
  | SEMI
  | LPAREN
  | RPAREN
  | LBRACE
  | RBRACE
  | COMMA
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | ASSIGN
  | NOT
  | EQ
  | NEQ
  | LT
  | LEQ
  | GT
  | GEQ
  | AND
  | OR
  | RETURN
  | IF
  | ELSE
  | FOR
  | WHILE
  | INT
  | BOOL
  | FLOAT
  | VOID
  | DEF
  | EXP
  | ABS
  | LITERAL of (int)
  | BLIT of (bool)
  | ID of (string)
  | FLIT of (string)
  | EOF

open Parsing;;
let _ = parse_error;;
# 4 "microcparse.mly"
open Ast
# 45 "microcparse.ml"
let yytransl_const = [|
  257 (* SEMI *);
  258 (* LPAREN *);
  259 (* RPAREN *);
  260 (* LBRACE *);
  261 (* RBRACE *);
  262 (* COMMA *);
  263 (* PLUS *);
  264 (* MINUS *);
  265 (* TIMES *);
  266 (* DIVIDE *);
  267 (* ASSIGN *);
  268 (* NOT *);
  269 (* EQ *);
  270 (* NEQ *);
  271 (* LT *);
  272 (* LEQ *);
  273 (* GT *);
  274 (* GEQ *);
  275 (* AND *);
  276 (* OR *);
  277 (* RETURN *);
  278 (* IF *);
  279 (* ELSE *);
  280 (* FOR *);
  281 (* WHILE *);
  282 (* INT *);
  283 (* BOOL *);
  284 (* FLOAT *);
  285 (* VOID *);
  286 (* DEF *);
  287 (* EXP *);
  288 (* ABS *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  289 (* LITERAL *);
  290 (* BLIT *);
  291 (* ID *);
  292 (* FLIT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\004\000\006\000\006\000\009\000\
\009\000\005\000\005\000\005\000\005\000\007\000\007\000\003\000\
\008\000\008\000\010\000\010\000\010\000\010\000\010\000\010\000\
\010\000\012\000\012\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\013\000\013\000\014\000\014\000\000\000"

let yylen = "\002\000\
\002\000\000\000\002\000\002\000\010\000\000\000\001\000\002\000\
\004\000\001\000\001\000\001\000\001\000\000\000\002\000\003\000\
\000\000\002\000\002\000\003\000\003\000\005\000\007\000\009\000\
\005\000\000\000\001\000\001\000\001\000\001\000\001\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\002\000\002\000\003\000\
\004\000\003\000\000\000\001\000\001\000\003\000\002\000"

let yydefred = "\000\000\
\002\000\000\000\055\000\000\000\010\000\011\000\012\000\013\000\
\000\000\001\000\003\000\004\000\000\000\000\000\000\000\000\000\
\016\000\000\000\000\000\000\000\000\000\008\000\000\000\000\000\
\014\000\000\000\000\000\009\000\015\000\000\000\000\000\017\000\
\005\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\028\000\030\000\000\000\029\000\018\000\000\000\000\000\000\000\
\046\000\047\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\019\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\050\000\021\000\020\000\000\000\000\000\000\000\045\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\036\000\
\000\000\000\000\000\000\049\000\000\000\000\000\000\000\025\000\
\000\000\000\000\000\000\023\000\000\000\000\000\024\000"

let yydgoto = "\002\000\
\003\000\004\000\011\000\012\000\013\000\020\000\027\000\030\000\
\021\000\045\000\046\000\052\000\081\000\082\000"

let yysindex = "\013\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\
\229\255\000\000\000\000\000\000\239\254\240\254\019\255\041\255\
\000\000\229\255\027\255\068\255\038\255\000\000\071\255\229\255\
\000\000\037\255\229\255\000\000\000\000\056\255\013\255\000\000\
\000\000\013\255\013\255\013\255\077\255\082\255\085\255\013\255\
\000\000\000\000\006\255\000\000\000\000\141\000\180\000\061\255\
\000\000\000\000\001\001\098\255\013\255\013\255\013\255\237\000\
\013\255\013\255\000\000\013\255\013\255\013\255\013\255\013\255\
\013\255\013\255\013\255\013\255\013\255\013\255\013\255\013\255\
\000\000\000\000\000\000\199\000\106\255\218\000\000\000\001\001\
\099\255\104\255\001\001\253\254\253\254\080\255\080\255\051\001\
\051\001\043\255\043\255\043\255\043\255\039\001\020\001\000\000\
\136\255\013\255\136\255\000\000\013\255\089\255\161\000\000\000\
\001\001\136\255\013\255\000\000\111\255\136\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\112\255\000\000\000\000\113\255\000\000\000\000\000\000\
\000\000\000\000\096\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\118\255\000\000\000\000\000\000\000\000\
\000\000\000\000\172\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\009\255\000\000\000\000\118\255\000\000\000\000\
\121\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\051\255\
\000\000\124\255\010\255\232\255\003\000\192\255\212\255\111\000\
\115\000\031\000\051\000\071\000\091\000\144\255\095\000\000\000\
\000\000\000\000\000\000\000\000\000\000\101\255\000\000\000\000\
\053\255\000\000\138\255\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\112\000\000\000\245\000\000\000\000\000\110\000\
\000\000\056\000\225\255\204\255\000\000\000\000"

let yytablesize = 594
let yytable = "\047\000\
\010\000\077\000\049\000\050\000\051\000\062\000\063\000\057\000\
\056\000\027\000\048\000\027\000\048\000\001\000\031\000\048\000\
\058\000\015\000\016\000\017\000\034\000\076\000\051\000\078\000\
\035\000\080\000\083\000\072\000\084\000\085\000\086\000\087\000\
\088\000\089\000\090\000\091\000\092\000\093\000\094\000\095\000\
\096\000\048\000\018\000\024\000\040\000\041\000\042\000\043\000\
\044\000\060\000\061\000\062\000\063\000\053\000\109\000\054\000\
\053\000\031\000\054\000\032\000\033\000\022\000\031\000\034\000\
\032\000\074\000\103\000\035\000\034\000\105\000\023\000\028\000\
\035\000\072\000\025\000\051\000\036\000\037\000\053\000\038\000\
\039\000\036\000\037\000\054\000\038\000\039\000\055\000\040\000\
\041\000\042\000\043\000\044\000\040\000\041\000\042\000\043\000\
\044\000\017\000\075\000\017\000\017\000\100\000\022\000\017\000\
\022\000\022\000\098\000\017\000\022\000\101\000\072\000\106\000\
\022\000\110\000\006\000\007\000\017\000\017\000\026\000\017\000\
\017\000\022\000\022\000\051\000\022\000\022\000\052\000\017\000\
\017\000\017\000\017\000\017\000\022\000\022\000\022\000\022\000\
\022\000\031\000\029\000\032\000\026\000\048\000\000\000\034\000\
\043\000\000\000\043\000\035\000\000\000\043\000\000\000\000\000\
\102\000\000\000\104\000\000\000\036\000\037\000\000\000\038\000\
\039\000\108\000\043\000\043\000\000\000\111\000\000\000\040\000\
\041\000\042\000\043\000\044\000\031\000\000\000\031\000\043\000\
\000\000\031\000\031\000\031\000\031\000\031\000\000\000\000\000\
\031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
\034\000\000\000\034\000\000\000\000\000\034\000\034\000\034\000\
\034\000\034\000\031\000\031\000\034\000\034\000\034\000\034\000\
\034\000\034\000\034\000\034\000\035\000\000\000\035\000\000\000\
\000\000\035\000\035\000\035\000\035\000\035\000\000\000\034\000\
\035\000\035\000\035\000\035\000\035\000\035\000\035\000\035\000\
\032\000\000\000\032\000\000\000\000\000\032\000\032\000\032\000\
\000\000\000\000\000\000\035\000\032\000\032\000\032\000\032\000\
\032\000\032\000\032\000\032\000\000\000\014\000\005\000\006\000\
\007\000\008\000\000\000\033\000\000\000\033\000\019\000\032\000\
\033\000\033\000\033\000\000\000\026\000\000\000\000\000\033\000\
\033\000\033\000\033\000\033\000\033\000\033\000\033\000\000\000\
\000\000\000\000\005\000\006\000\007\000\008\000\009\000\039\000\
\000\000\039\000\033\000\000\000\039\000\000\000\000\000\000\000\
\000\000\000\000\000\000\039\000\039\000\039\000\039\000\039\000\
\039\000\039\000\039\000\040\000\000\000\040\000\000\000\000\000\
\040\000\000\000\000\000\000\000\000\000\000\000\039\000\040\000\
\040\000\040\000\040\000\040\000\040\000\040\000\040\000\041\000\
\000\000\041\000\000\000\000\000\041\000\000\000\000\000\000\000\
\000\000\000\000\040\000\041\000\041\000\041\000\041\000\041\000\
\041\000\041\000\041\000\042\000\000\000\042\000\000\000\044\000\
\042\000\044\000\000\000\000\000\044\000\000\000\041\000\042\000\
\042\000\042\000\042\000\042\000\042\000\042\000\042\000\037\000\
\000\000\037\000\044\000\038\000\037\000\038\000\000\000\000\000\
\038\000\000\000\042\000\037\000\037\000\000\000\044\000\038\000\
\038\000\037\000\037\000\000\000\000\000\038\000\038\000\000\000\
\000\000\000\000\000\000\000\000\000\000\059\000\037\000\000\000\
\000\000\000\000\038\000\060\000\061\000\062\000\063\000\000\000\
\000\000\064\000\065\000\066\000\067\000\068\000\069\000\070\000\
\071\000\107\000\000\000\000\000\000\000\000\000\000\000\060\000\
\061\000\062\000\063\000\072\000\000\000\064\000\065\000\066\000\
\067\000\068\000\069\000\070\000\071\000\000\000\073\000\000\000\
\000\000\000\000\060\000\061\000\062\000\063\000\000\000\072\000\
\064\000\065\000\066\000\067\000\068\000\069\000\070\000\071\000\
\000\000\097\000\000\000\000\000\000\000\060\000\061\000\062\000\
\063\000\000\000\072\000\064\000\065\000\066\000\067\000\068\000\
\069\000\070\000\071\000\000\000\099\000\000\000\000\000\000\000\
\060\000\061\000\062\000\063\000\000\000\072\000\064\000\065\000\
\066\000\067\000\068\000\069\000\070\000\071\000\000\000\000\000\
\000\000\000\000\000\000\060\000\061\000\062\000\063\000\000\000\
\072\000\064\000\065\000\066\000\067\000\068\000\069\000\070\000\
\071\000\000\000\000\000\000\000\000\000\000\000\000\000\060\000\
\061\000\062\000\063\000\072\000\079\000\064\000\065\000\066\000\
\067\000\068\000\069\000\070\000\071\000\000\000\000\000\000\000\
\000\000\000\000\060\000\061\000\062\000\063\000\000\000\072\000\
\064\000\065\000\066\000\067\000\068\000\069\000\070\000\000\000\
\000\000\000\000\000\000\000\000\000\000\060\000\061\000\062\000\
\063\000\000\000\072\000\064\000\065\000\066\000\067\000\068\000\
\069\000\060\000\061\000\062\000\063\000\000\000\000\000\000\000\
\000\000\066\000\067\000\068\000\069\000\072\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\072\000"

let yycheck = "\031\000\
\000\000\054\000\034\000\035\000\036\000\009\001\010\001\002\001\
\040\000\001\001\001\001\003\001\003\001\001\000\002\001\006\001\
\011\001\035\001\035\001\001\001\008\001\053\000\054\000\055\000\
\012\001\057\000\058\000\031\001\060\000\061\000\062\000\063\000\
\064\000\065\000\066\000\067\000\068\000\069\000\070\000\071\000\
\072\000\032\001\002\001\006\001\032\001\033\001\034\001\035\001\
\036\001\007\001\008\001\009\001\010\001\003\001\107\000\003\001\
\006\001\002\001\006\001\004\001\005\001\035\001\002\001\008\001\
\004\001\005\001\098\000\012\001\008\001\101\000\003\001\035\001\
\012\001\031\001\004\001\107\000\021\001\022\001\002\001\024\001\
\025\001\021\001\022\001\002\001\024\001\025\001\002\001\032\001\
\033\001\034\001\035\001\036\001\032\001\033\001\034\001\035\001\
\036\001\002\001\001\001\004\001\005\001\003\001\002\001\008\001\
\004\001\005\001\001\001\012\001\008\001\006\001\031\001\023\001\
\012\001\003\001\003\001\003\001\021\001\022\001\001\001\024\001\
\025\001\021\001\022\001\003\001\024\001\025\001\003\001\032\001\
\033\001\034\001\035\001\036\001\032\001\033\001\034\001\035\001\
\036\001\002\001\027\000\004\001\003\001\032\000\255\255\008\001\
\001\001\255\255\003\001\012\001\255\255\006\001\255\255\255\255\
\097\000\255\255\099\000\255\255\021\001\022\001\255\255\024\001\
\025\001\106\000\019\001\020\001\255\255\110\000\255\255\032\001\
\033\001\034\001\035\001\036\001\001\001\255\255\003\001\032\001\
\255\255\006\001\007\001\008\001\009\001\010\001\255\255\255\255\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\020\001\
\001\001\255\255\003\001\255\255\255\255\006\001\007\001\008\001\
\009\001\010\001\031\001\032\001\013\001\014\001\015\001\016\001\
\017\001\018\001\019\001\020\001\001\001\255\255\003\001\255\255\
\255\255\006\001\007\001\008\001\009\001\010\001\255\255\032\001\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\020\001\
\001\001\255\255\003\001\255\255\255\255\006\001\007\001\008\001\
\255\255\255\255\255\255\032\001\013\001\014\001\015\001\016\001\
\017\001\018\001\019\001\020\001\255\255\009\000\026\001\027\001\
\028\001\029\001\255\255\001\001\255\255\003\001\018\000\032\001\
\006\001\007\001\008\001\255\255\024\000\255\255\255\255\013\001\
\014\001\015\001\016\001\017\001\018\001\019\001\020\001\255\255\
\255\255\255\255\026\001\027\001\028\001\029\001\030\001\001\001\
\255\255\003\001\032\001\255\255\006\001\255\255\255\255\255\255\
\255\255\255\255\255\255\013\001\014\001\015\001\016\001\017\001\
\018\001\019\001\020\001\001\001\255\255\003\001\255\255\255\255\
\006\001\255\255\255\255\255\255\255\255\255\255\032\001\013\001\
\014\001\015\001\016\001\017\001\018\001\019\001\020\001\001\001\
\255\255\003\001\255\255\255\255\006\001\255\255\255\255\255\255\
\255\255\255\255\032\001\013\001\014\001\015\001\016\001\017\001\
\018\001\019\001\020\001\001\001\255\255\003\001\255\255\001\001\
\006\001\003\001\255\255\255\255\006\001\255\255\032\001\013\001\
\014\001\015\001\016\001\017\001\018\001\019\001\020\001\001\001\
\255\255\003\001\020\001\001\001\006\001\003\001\255\255\255\255\
\006\001\255\255\032\001\013\001\014\001\255\255\032\001\013\001\
\014\001\019\001\020\001\255\255\255\255\019\001\020\001\255\255\
\255\255\255\255\255\255\255\255\255\255\001\001\032\001\255\255\
\255\255\255\255\032\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\019\001\
\020\001\001\001\255\255\255\255\255\255\255\255\255\255\007\001\
\008\001\009\001\010\001\031\001\255\255\013\001\014\001\015\001\
\016\001\017\001\018\001\019\001\020\001\255\255\003\001\255\255\
\255\255\255\255\007\001\008\001\009\001\010\001\255\255\031\001\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\020\001\
\255\255\003\001\255\255\255\255\255\255\007\001\008\001\009\001\
\010\001\255\255\031\001\013\001\014\001\015\001\016\001\017\001\
\018\001\019\001\020\001\255\255\003\001\255\255\255\255\255\255\
\007\001\008\001\009\001\010\001\255\255\031\001\013\001\014\001\
\015\001\016\001\017\001\018\001\019\001\020\001\255\255\255\255\
\255\255\255\255\255\255\007\001\008\001\009\001\010\001\255\255\
\031\001\013\001\014\001\015\001\016\001\017\001\018\001\019\001\
\020\001\255\255\255\255\255\255\255\255\255\255\255\255\007\001\
\008\001\009\001\010\001\031\001\032\001\013\001\014\001\015\001\
\016\001\017\001\018\001\019\001\020\001\255\255\255\255\255\255\
\255\255\255\255\007\001\008\001\009\001\010\001\255\255\031\001\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\255\255\
\255\255\255\255\255\255\255\255\255\255\007\001\008\001\009\001\
\010\001\255\255\031\001\013\001\014\001\015\001\016\001\017\001\
\018\001\007\001\008\001\009\001\010\001\255\255\255\255\255\255\
\255\255\015\001\016\001\017\001\018\001\031\001\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\031\001"

let yynames_const = "\
  SEMI\000\
  LPAREN\000\
  RPAREN\000\
  LBRACE\000\
  RBRACE\000\
  COMMA\000\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIVIDE\000\
  ASSIGN\000\
  NOT\000\
  EQ\000\
  NEQ\000\
  LT\000\
  LEQ\000\
  GT\000\
  GEQ\000\
  AND\000\
  OR\000\
  RETURN\000\
  IF\000\
  ELSE\000\
  FOR\000\
  WHILE\000\
  INT\000\
  BOOL\000\
  FLOAT\000\
  VOID\000\
  DEF\000\
  EXP\000\
  ABS\000\
  EOF\000\
  "

let yynames_block = "\
  LITERAL\000\
  BLIT\000\
  ID\000\
  FLIT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    Obj.repr(
# 35 "microcparse.mly"
            ( _1 )
# 368 "microcparse.ml"
               : Ast.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 38 "microcparse.mly"
                 ( ([], [])               )
# 374 "microcparse.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 39 "microcparse.mly"
               ( ((_2 :: fst _1), snd _1) )
# 382 "microcparse.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'fdecl) in
    Obj.repr(
# 40 "microcparse.mly"
               ( (fst _1, (_2 :: snd _1)) )
# 390 "microcparse.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 8 : 'typ) in
    let _3 = (Parsing.peek_val __caml_parser_env 7 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 5 : 'formals_opt) in
    let _8 = (Parsing.peek_val __caml_parser_env 2 : 'vdecl_list) in
    let _9 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 44 "microcparse.mly"
     ( { typ = _2;
	 fname = _3;
	 formals = List.rev _5;
	 locals = List.rev _8;
	 body = List.rev _9 } )
# 405 "microcparse.ml"
               : 'fdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 51 "microcparse.mly"
                  ( [] )
# 411 "microcparse.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'formal_list) in
    Obj.repr(
# 52 "microcparse.mly"
                  ( _1 )
# 418 "microcparse.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 55 "microcparse.mly"
                             ( [(_1,_2)]     )
# 426 "microcparse.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'formal_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 56 "microcparse.mly"
                             ( (_3,_4) :: _1 )
# 435 "microcparse.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "microcparse.mly"
          ( Int   )
# 441 "microcparse.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 60 "microcparse.mly"
          ( Bool  )
# 447 "microcparse.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 61 "microcparse.mly"
          ( Float )
# 453 "microcparse.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 62 "microcparse.mly"
          ( Void  )
# 459 "microcparse.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 65 "microcparse.mly"
                     ( [] )
# 465 "microcparse.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'vdecl_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 66 "microcparse.mly"
                     ( _2 :: _1 )
# 473 "microcparse.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 69 "microcparse.mly"
               ( (_1, _2) )
# 481 "microcparse.ml"
               : 'vdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 72 "microcparse.mly"
                   ( [] )
# 487 "microcparse.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 73 "microcparse.mly"
                   ( _2 :: _1 )
# 495 "microcparse.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 76 "microcparse.mly"
                                            ( Expr _1               )
# 502 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr_opt) in
    Obj.repr(
# 77 "microcparse.mly"
                                            ( Return _2             )
# 509 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 78 "microcparse.mly"
                                            ( Block(List.rev _2)    )
# 516 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 79 "microcparse.mly"
                                            ( If(_3, _5, Block([])) )
# 524 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 80 "microcparse.mly"
                                            ( If(_3, _5, _7)        )
# 533 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 6 : 'expr_opt) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'expr_opt) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 82 "microcparse.mly"
                                            ( For(_3, _5, _7, _9)   )
# 543 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 83 "microcparse.mly"
                                            ( While(_3, _5)         )
# 551 "microcparse.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "microcparse.mly"
                  ( Noexpr )
# 557 "microcparse.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 87 "microcparse.mly"
                  ( _1 )
# 564 "microcparse.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 90 "microcparse.mly"
                     ( Literal(_1)            )
# 571 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 91 "microcparse.mly"
              ( Fliteral(_1)           )
# 578 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : bool) in
    Obj.repr(
# 92 "microcparse.mly"
                     ( BoolLit(_1)            )
# 585 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 93 "microcparse.mly"
                     ( Id(_1)                 )
# 592 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 94 "microcparse.mly"
                     ( Binop(_1, Add,   _3)   )
# 600 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 95 "microcparse.mly"
                     ( Binop(_1, Sub,   _3)   )
# 608 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 96 "microcparse.mly"
                     ( Binop(_1, Mult,  _3)   )
# 616 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 97 "microcparse.mly"
                     ( Binop(_1, Div,   _3)   )
# 624 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 98 "microcparse.mly"
                  ( Binop(_1, Exp,   _3)   )
# 632 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 99 "microcparse.mly"
                     ( Binop(_1, Equal, _3)   )
# 640 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 100 "microcparse.mly"
                     ( Binop(_1, Neq,   _3)   )
# 648 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 101 "microcparse.mly"
                     ( Binop(_1, Less,  _3)   )
# 656 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 102 "microcparse.mly"
                     ( Binop(_1, Leq,   _3)   )
# 664 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 103 "microcparse.mly"
                     ( Binop(_1, Greater, _3) )
# 672 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 104 "microcparse.mly"
                     ( Binop(_1, Geq,   _3)   )
# 680 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 105 "microcparse.mly"
                     ( Binop(_1, And,   _3)   )
# 688 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 106 "microcparse.mly"
                     ( Binop(_1, Or,    _3)   )
# 696 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 107 "microcparse.mly"
                 ( Unop(Abs, _2)   )
# 703 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 108 "microcparse.mly"
                         ( Unop(Neg, _2)      )
# 710 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 109 "microcparse.mly"
                     ( Unop(Not, _2)          )
# 717 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 110 "microcparse.mly"
                     ( Assign(_1, _3)         )
# 725 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'args_opt) in
    Obj.repr(
# 111 "microcparse.mly"
                              ( Call(_1, _3)  )
# 733 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 112 "microcparse.mly"
                       ( _2                   )
# 740 "microcparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 115 "microcparse.mly"
                  ( [] )
# 746 "microcparse.ml"
               : 'args_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'args_list) in
    Obj.repr(
# 116 "microcparse.mly"
               ( List.rev _1 )
# 753 "microcparse.ml"
               : 'args_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 119 "microcparse.mly"
                            ( [_1] )
# 760 "microcparse.ml"
               : 'args_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'args_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 120 "microcparse.mly"
                         ( _3 :: _1 )
# 768 "microcparse.ml"
               : 'args_list))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.program)
