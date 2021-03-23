int a;
bool b;

def void foo(int c, bool d)    
{
  int dd;
  bool e;
  a + c;
  c - a;
  a * 3;
  c / 2;
  d + a; /* Error: bool + int */
}

def int main()
{
  return 0;
}
