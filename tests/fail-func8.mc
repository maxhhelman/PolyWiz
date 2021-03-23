def void foo(int a, bool b)
{
}

def void bar()
{
}

def int main()
{
  foo(42, true);
  foo(42, bar()); /* int and void, not int and bool */
}
