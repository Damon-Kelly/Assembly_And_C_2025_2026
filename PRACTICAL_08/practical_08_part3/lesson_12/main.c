#include "stdio.h" // standard IO header file

// Function declaration
int add(int, int);

int main()
{
    int result;

    // Calling add function
    result = add(3, 4);

    // Display result
    printf("Result : %d\n", result);

    result = sub(6, 2);
    printf("Result : %d\n", result);

    return 0;
}

// Function definition
int add(int a, int b)
{
    return a + b;
}

int sub(int a, int b)
{
    return a - b;
}