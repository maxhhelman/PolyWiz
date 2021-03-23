int a;
int b;

def void printa()
{
  print(a);
}

def void printbb()
{
  print(b);
}

def void incab()
{
  a = a + 1;
  b = b + 1;
}

def int main()
{
  a = 42;
  b = 21;
  printa();
  printbb();
  incab();
  printa();
  printbb();
  return 0;
}
