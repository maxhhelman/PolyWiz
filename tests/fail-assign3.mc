def void myvoid()
{
  return;
}

def int main()
{
  int i;

  i = myvoid(); /* Fail: assigning a void to an integer */
}
