global _start

section .data                           ; here we store variables
    PROMPT db "Please enter a number: ", 0xa    ; 0xa is new line

section .text 

_start:
    ; add 2 integars
    mov     eax, 5                      ; load first integer into eax
    mov     ebx, 10                     ; load second integer into ebx
    add     eax, ebx                    ; add ebx to eax, result is now in eax

system_exit:
    ; exit the program
    mov     rbx, STATUS_OK              ; return status 64 Bit Register
    mov     rax, SYS_EXIT               ; system call number (sys_exit) 64 Bit Register
    int     SYS_KERNEL                  ; call kernel, system call 64 bit System 
