global _start

section .data
    prompt          db "Enter number: ", 0
    prompt_len      equ $-prompt
    result_label    db "Sum: ", 0
    result_label_len equ $-result_label
    newline         db 10

section .bss
    input_buffer    resb 16             ; single reusable buffer
    output_buffer   resb 16

section .text

_start:
    xor     r13, r13                    ; r13 = running sum = 0
    mov     r14, 3                      ; r14 = loop counter = 3

; -------------------------------------------------------
; INPUT LOOP — 3 iterations
; -------------------------------------------------------
.loop_start:
    cmp     r14, 0                      ; check if counter is 0
    je      .loop_done                  ; exit loop if done

    ; --- Prompt user ---
    mov     rsi, prompt
    mov     rdx, prompt_len
    call    print_string

    ; --- Read input into reusable buffer ---
    mov     rsi, input_buffer
    mov     rdx, 16
    call    read_input

    ; --- Convert string to integer ---
    mov     rsi, input_buffer
    call    string_to_integer           ; result in rax

    ; --- Accumulate into running sum ---
    add     r13, rax                    ; r13 += rax

    dec     r14                         ; decrement counter
    jmp     .loop_start                 ; repeat loop

; -------------------------------------------------------
; POST-LOOP — Print the result
; -------------------------------------------------------
.loop_done:
    ; --- Print result label ---
    mov     rsi, result_label
    mov     rdx, result_label_len
    call    print_string

    ; --- Convert sum to string ---
    mov     rax, r13                    ; move running sum into rax for conversion
    mov     rdi, output_buffer
    call    integer_to_string           ; rax = pointer, rdx = length

    ; --- Print result string ---
    mov     rsi, rax
    call    print_string

    ; --- Newline ---
    mov     rsi, newline
    mov     rdx, 1
    call    print_string

    ; --- Exit ---
    mov     rax, 60
    xor     rdi, rdi
    syscall

; -------------------------------------------------------
; print_string  | rsi = pointer, rdx = length
; -------------------------------------------------------
print_string:
    mov     rax, 1                      ; syscall: write
    mov     rdi, 1                      ; stdout
    syscall
    ret

; -------------------------------------------------------
; read_input    | rsi = buffer, rdx = max length
; -------------------------------------------------------
read_input:
    mov     rax, 0                      ; syscall: read
    mov     rdi, 0                      ; stdin
    syscall
    ret

; -------------------------------------------------------
; string_to_integer | rsi = input string, returns rax
; -------------------------------------------------------
string_to_integer:
    xor     rax, rax
    xor     rcx, rcx
.next_char:
    movzx   r8, byte [rsi+rcx]
    cmp     r8b, 10                     ; newline
    je      .done
    cmp     r8b, 0                      ; null terminator
    je      .done
    sub     r8b, '0'                    ; ASCII -> digit
    imul    rax, 10
    add     rax, r8
    inc     rcx
    jmp     .next_char
.done:
    ret

; -------------------------------------------------------
; integer_to_string | rax = number, rdi = output buffer
; returns: rax = pointer to string, rdx = length
; -------------------------------------------------------
integer_to_string:
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
    ret