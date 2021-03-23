def void foo(int a, bool b)
{
}

def int main()
{
  foo(42, true);
  foo(42, 42); /* Fail: int, not bool */
}
