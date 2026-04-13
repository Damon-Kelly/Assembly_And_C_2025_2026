#include <stdio.h>

extern int sub(int a, int b);

int main(int argc, char **argv)
{
  printf("%d\n", sub(4, 6));
  return 0;
}
