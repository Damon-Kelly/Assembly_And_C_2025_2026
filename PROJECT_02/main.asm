global run_sum
global register_adder
global string_to_integer

section .data
    prompt           db "Enter number: "
    prompt_len       equ $-prompt
    result_label     db "The sum is: "
    result_label_len equ $-result_label
    total_label      db "Final sum is: "
    total_label_len  equ $-total_label
    newline          db 10

section .bss
    input_buffer     resb 16
    output_buffer    resb 32

section .text

run_sum:
    push    rbx
    push    r13
    push    r14
    push    r15
    sub     rsp, 8                      ; keep stack 16-byte aligned for calls

    xor     r13, r13                    ; r13 = running sum = 0
    mov     r14, 3                      ; r14 = loop counter = 3

; -------------------------------------------------------
; INPUT LOOP — 3 iterations
; -------------------------------------------------------
.loop_start:
    cmp     r14, 0                      ; check whether all 3 iterations are done
    je      .loop_done                  ; exit loop if finished

    ; --- Prompt for first number ---
    mov     rsi, prompt
    mov     rdx, prompt_len
    call    print_string

    ; --- Read first number and save byte count ---
    mov     rsi, input_buffer
    mov     rdx, 16
    call    read_input
    cmp     rax, 0                      ; stop cleanly on EOF or read error
    jle     .loop_done
    mov     rbx, rax                    ; save byte count from read

    ; --- Convert first input to integer ---
    mov     rsi, input_buffer
    mov     rdx, rbx                    ; limit scan to bytes actually read
    call    string_to_integer
    cmp     rax, -1                     ; invalid input
    je      .loop_start                 ; re-prompt this iteration
    mov     r15, rax                    ; store first number

    ; --- Prompt for second number ---
    mov     rsi, prompt
    mov     rdx, prompt_len
    call    print_string

    ; --- Read second number and save byte count ---
    mov     rsi, input_buffer
    mov     rdx, 16
    call    read_input
    cmp     rax, 0                      ; stop cleanly on EOF or read error
    jle     .loop_done
    mov     rbx, rax                    ; save byte count from read

    ; --- Convert second input to integer ---
    mov     rsi, input_buffer
    mov     rdx, rbx                    ; limit scan to bytes actually read
    call    string_to_integer
    cmp     rax, -1                     ; invalid input
    je      .loop_start                 ; re-prompt this iteration

    ; --- Add two numbers using register_adder ---
    ; rax = second number, r15 = first number
    call    register_adder              ; rax = first + second
    mov     r15, rax                    ; save iteration sum

    ; --- Print iteration sum label ---
    mov     rsi, result_label
    mov     rdx, result_label_len
    call    print_string

    ; --- Print iteration sum ---
    mov     rax, r15
    mov     rdi, output_buffer
    call    integer_to_string
    mov     rsi, rax
    call    print_string

    ; --- Newline ---
    mov     rsi, newline
    mov     rdx, 1
    call    print_string

    ; --- Add iteration sum to running total ---
    add     r13, r15
    dec     r14
    jmp     .loop_start

; -------------------------------------------------------
; POST-LOOP — print final sum
; -------------------------------------------------------
.loop_done:
    ; --- Print final sum label ---
    mov     rsi, total_label
    mov     rdx, total_label_len
    call    print_string

    ; --- Convert running sum to string ---
    mov     rax, r13
    mov     rdi, output_buffer
    call    integer_to_string

    ; --- Print final sum ---
    mov     rsi, rax
    call    print_string

    ; --- Newline ---
    mov     rsi, newline
    mov     rdx, 1
    call    print_string

    add     rsp, 8                      ; undo alignment adjustment
    pop     r15
    pop     r14
    pop     r13
    pop     rbx
    ret

; -------------------------------------------------------
; register_adder | mirrors the 68000 REGISTER_ADDER subroutine
; rax = second number, r15 = first number
; returns: rax = sum
; -------------------------------------------------------
register_adder:
    add     rax, r15                    ; add first + second
    ret

; -------------------------------------------------------
; print_string | rsi = pointer, rdx = length
; -------------------------------------------------------
print_string:
    mov     rax, 1                      ; syscall: write
    mov     rdi, 1                      ; stdout
    syscall
    ret

; -------------------------------------------------------
; read_input | rsi = buffer, rdx = max length
; returns: rax = bytes read
; -------------------------------------------------------
read_input:
    mov     rax, 0                      ; syscall: read
    mov     rdi, 0                      ; stdin
    syscall
    ret

; -------------------------------------------------------
; string_to_integer | rsi = input string, rdx = byte count
; returns: rax = integer, or -1 on invalid input
; The scan is bounded by rdx so it never reads past input.
; -------------------------------------------------------
string_to_integer:
    xor     rax, rax
    xor     rcx, rcx
.next_char:
    cmp     rcx, rdx                    ; stop at byte count
    jge     .done
    movzx   r8, byte [rsi+rcx]
    cmp     r8b, 10                     ; newline
    je      .done
    cmp     r8b, 0                      ; null terminator
    je      .done
    cmp     r8b, '0'
    jl      .invalid
    cmp     r8b, '9'
    jg      .invalid
    sub     r8b, '0'
    imul    rax, 10
    add     rax, r8
    inc     rcx
    jmp     .next_char
.invalid:
    mov     rax, -1                     ; invalid character found
    ret
.done:
    ret

; -------------------------------------------------------
; integer_to_string | rax = number, rdi = output buffer
; returns: rax = pointer to string, rdx = length
; -------------------------------------------------------
integer_to_string:
    push    rbx                         ; preserve callee-saved register
    mov     rcx, 0
    mov     rbx, 10
.extract_digits:
    xor     rdx, rdx
    div     rbx
    add     dl, '0'
    push    rdx
    inc     rcx
    test    rax, rax
    jnz     .extract_digits
    mov     rax, rdi
    mov     r8, rcx
.write_digits:
    pop     rdx
    mov     [rdi], dl
    inc     rdi
    loop    .write_digits
    mov     rdx, r8
    pop     rbx                         ; restore rbx before return
    ret