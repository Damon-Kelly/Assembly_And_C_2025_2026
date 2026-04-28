#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>

int main() {
    printf("Running Assembly Unit Tests...\n");

    // Test Case 1: Simple Addition
    // Testing: 10 + 20 = 30
    assert(asm_bridge_adder(10, 20) == 30);
    
    // Test Case 2: Just Zero Addition
    assert(asm_bridge_adder(0, 0) == 0);

    // Test Case 3: Enter String to Integer
    // Testing: "123" with length 3
    assert(asm_bridge_atoi("123", 3) == 123);

    // Test Case 4: Invalid characters
    assert(asm_bridge_atoi("12a3", 4) == -1);

    // Test Case 5: Large numbers
    assert(asm_bridge_atoi("999", 3) == 999);

    printf("All tests passed! (It didn't trigger a crash, YIPPEE!)\n");
    return 0;
}