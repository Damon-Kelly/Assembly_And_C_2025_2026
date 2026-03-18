#include "stdio.h" // standard IO header file

int main()
{
    // Unary operator example
    // Unary -a operates on single operand (negative a)
    int a = 10;
    int b = -a;
    printf("Unary Example: %d\n", b);
    // this sets b to positive a
    b = +a;
    printf("B is now %d\n", b);

    // Binary operator example
    // Binary plus operates on two operands
    int total = a + b;
    printf("Binary Example: %d\n", total);
    int c = 4;
    int d = c + 2;
    printf("c + 2 is %d\n", d);

    // Ternary operator example
    // Ternary conditional operator operates on three operands
    char *result = (total % 2 == 0) ? "even" : "odd";
    printf("Ternary Example: %d is %s\n", total, result);

    char *result2 = (d % c == 0) ? "Yes" : "No";
    printf("Is %d evenly divisible by %d : %s\n", d, c, result2);

    return 0;
}