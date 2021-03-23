def void foo() {}

def int bar(int a, bool b, int c) { return a + c; }

def int main()
{
  print(bar(17, false, 25));
  return 0;
}
