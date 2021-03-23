def int foo(int a, bool b, int c) { }

def void bar(int a, bool b, int a) {} /* Error: duplicate formal a in bar */

def int main()
{
  return 0;
}
