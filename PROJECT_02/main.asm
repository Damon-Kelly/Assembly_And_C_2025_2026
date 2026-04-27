global _start

section .data
    prompt db "Enter number: ", 0
    prompt_len equ $-prompt

    result_label db "Sum: ", 0
    result_label_len equ $-result_label

    newline db 10

section .bss
    first_input_buffer  resb 16
    second_input_buffer resb 16
    output_buffer       resb 16

section .text

_start:
    ; --- Get First Number ---
    mov rsi, prompt
    mov rdx, prompt_len
    call print_string

    mov rsi, first_input_buffer
    mov rdx, 16
    call read_input

    mov rsi, first_input_buffer
    call string_to_integer

    mov r12, rax      ; store first number

    ; --- Get Second Number ---
    mov rsi, prompt
    mov rdx, prompt_len
    call print_string

    mov rsi, second_input_buffer
    mov rdx, 16
    call read_input

    mov rsi, second_input_buffer
    call string_to_integer

    ; --- Add Numbers ---
    add rax, r12      ; rax = second + first

    ; --- Print Result Label ---
    push rax
    mov rsi, result_label
    mov rdx, result_label_len
    call print_string
    pop rax

    ; --- Convert Result to String ---
    mov rdi, output_buffer
    call integer_to_string   ; clearer than itoa

    ; --- Print Result ---
    mov rsi, rax
    call print_string

    ; --- Newline ---
    mov rsi, newline
    mov rdx, 1
    call print_string

    ; --- Exit ---
    mov rax, 60
    xor rdi, rdi
    syscall

; -------------------------
; print_string
; rsi = pointer to text
; rdx = length
; -------------------------
print_string:
    mov rax, 1        ; syscall: write
    mov rdi, 1        ; stdout
    syscall
    ret

; -------------------------
; read_input
; rsi = buffer
; rdx = max length
; -------------------------
read_input:
    mov rax, 0        ; syscall: read
    mov rdi, 0        ; stdin
    syscall
    ret

; -------------------------
; string_to_integer
; converts ASCII digits to integer
; rsi = input string
; returns rax = integer
; -------------------------
string_to_integer:
    xor rax, rax
    xor rcx, rcx

.next_char:
    movzx r8, byte [rsi+rcx]
    cmp r8b, 10      ; newline
    je .done
    cmp r8b, 0       ; null terminator
    je .done

    sub r8b, '0'     ; ASCII -> number
    imul rax, 10
    add rax, r8

    inc rcx
    jmp .next_char

.done:
    ret

; -------------------------
; integer_to_string
; converts integer to ASCII string
; rax = number
; rdi = output buffer
; returns:
;   rax = pointer to string
;   rdx = length
; -------------------------
integer_to_string:
    mov rcx, 0
    mov rbx, 10

.extract_digits:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .extract_digits

    mov rax, rdi
    mov r8, rcx

.write_digits:
    pop rdx
    mov [rdi], dl
    inc rdi
    loop .write_digits

    mov rdx, r8
    ret