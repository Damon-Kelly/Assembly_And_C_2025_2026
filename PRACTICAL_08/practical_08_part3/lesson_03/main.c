#include "stdio.h"

int main()
{
    int a;
    int b;

    // Call to printf function a is substituted for %d
    printf("Value of a is %d\n", a);
    // print value of b without setting it
    printf("Value of b is %d\n", b);

    // Scope
    {
        a = 10;
        b =90;
        printf("Value of a is %d\n", a);
        // set b to 90 and print it out
        printf("Value of b is %d\n", b);
        // redeclare b, this wipes the value
        int b;
        // this prints theof b before it was set
        printf("Value of b is now %d\n", b);
        int a;
        printf("Value of a is %d\n", a);
    }

    // Scope
    {
        b = 70;
        a = 100;
        printf("Value of a is %d\n", a);
        printf("Value of b is now %d\n", b);
    }

    printf("Value of a is %d\n", a);

    return 0;
}