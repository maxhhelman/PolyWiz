# "make test" Compiles everything and runs the regression tests

.PHONY : test
test : all testall.sh
	./testall.sh

# "make all" builds the executable as well as the "library_functions" library designed
# to test linking external code

.PHONY : all
all : polywiz.native library_functions

# "make polywiz.native" compiles the compiler
#
# The _tags file controls the operation of ocamlbuild, e.g., by including
# packages, enabling warnings
#
# See https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc

polywiz.native :
	opam config exec -- \
	ocamlbuild -use-ocamlfind polywiz.native

# "make clean" removes all generated files

.PHONY : clean
clean :
	ocamlbuild -clean
	rm -rf testall.log library_functions ocamlllvm *.diff *.o

# Testing the "library_functions" example
library_functions : library_functions.o
	apt-get update
	apt-get -yq --no-install-suggests --no-install-recommends install gnuplot
	gcc -o library_functions library_functions.c -DBUILD_TEST -lm

# Building the tarball

TESTS = \
  add1 arith1 arith2 arith3 fib float1 float2 float3 for1 for2 func1 \
  func2 func3 func4 func5 func6 func7 func8 func9 gcd2 gcd global1 \
  global2 global3 hello if1 if2 if3 if4 if5 if6 local1 local2 ops1 \
  ops2 library_functions var1 var2 while1 while2

FAILS = \
  assign1 assign2 assign3 dead1 dead2 expr1 expr2 expr3 float1 float2 \
  for1 for2 for3 for4 for5 func1 func2 func3 func4 func5 func6 func7 \
  func8 func9 global1 global2 if1 if2 if3 nomain library_functions printb print \
  return1 return2 while1 while2

TESTFILES = $(TESTS:%=test-%.pwiz) $(TESTS:%=test-%.out) \
	    $(FAILS:%=fail-%.pwiz) $(FAILS:%=fail-%.err)

TARFILES = ast.ml sast.ml codegen.ml Makefile _tags polywiz.ml polywizparse.mly \
	README scanner.mll semant.ml testall.sh \
	library_functions.c arcade-font.pbm font2c \
	Dockerfile \
	$(TESTFILES:%=tests/%)

polywiz.tar.gz : $(TARFILES)
	cd .. && tar czf polywiz/polywiz.tar.gz \
		$(TARFILES:%=polywiz/%)
