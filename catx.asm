
global _start

section .text

_start:
    ; open the file
    mov rax , 2 ; syscall for open
    mov rdi, [rsp+ 16] ; argc = 2 for file name
    xor rsi, rsi ; rsi = 0 for 0_RDONLY flag
    xor rdx, rdx ; set rdx = 0 for no mod
    syscall 
    
    ; check if there was a problem
    cmp rax, 0 ; 
    jl _error   ; jump to error if there was a problem
    
    ; move file descriptor to r8
    mov r8, rax ; if rax is not negative then we got it
loop_read:
    
    mov rax, 0 ; sys call for read()
    mov rdi, r8; move the open file to rdi
    mov rsi, buffer ; file will be read into the buffer
    mov rdx, 1024 ; counter for the read stuff to the buffer
    syscall
    
    ; check for end of file
    cmp eax, 0
    jz _exit    ;exit if eax == 0 
    
    ; write the output
    mov rax, 1  ; sys call for write
    mov rdi, 1 ; 1 for stdout. output to terminal
    mov rsi , buffer
    mov rdx, 1024 ; counter for writing
    syscall
    
    ; loop to read more
    jmp loop_read
    
 _error:
    mov rax, 60 ; exit 
    xor rdi, 1  ; exit with 1 for error
    syscall
    
_exit:
    mov rax, 60; exit
    xor rdi, rdi; rdi = 0 for exit with no error
    syscall

section .bss
buffer resb 1024