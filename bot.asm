format PE64 console
entry main

include "win64ax.inc"

section ".bss" data readable writable
    stdout dq ?
    handle dq ?

section ".data" data readable writable
    struct IO_STATUS_BLOCK
        status dq ?
        info dq ?
    ends
    iostatus IO_STATUS_BLOCK
    message db "Hello from thread!", 10, 0

section ".text" code readable executable
proc strlen
    mov rax, -1
L1:
    add rax, 1
    cmp byte [rcx + rax], 0
    jnz L1
    ret
endp
proc foo
    sub rsp, 80
    mov rcx, message
    call strlen
    mov r10, [stdout]
    xor rdx, rdx
    xor r8, r8
    xor r9, r9
    mov qword [rsp + 40], iostatus
    mov qword [rsp + 48], message
    mov qword [rsp + 56], rax
    mov qword [rsp + 64], 0
    mov qword [rsp + 72], 0
    mov eax, 0x8
    syscall
    add rsp, 80
    ret
endp
proc main
    sub rsp, 96
    mov rsi, [gs:0x60]
    mov rsi, [rsi + 0x20]
    mov rsi, [rsi + 0x28]
    mov [stdout], rsi
    mov r10, handle
    mov rdx, 1048607
    xor r8, r8
    mov r9, -1
    mov qword [rsp + 40], foo
    mov qword [rsp + 48], 0
    mov qword [rsp + 56], 0
    mov qword [rsp + 64], 0
    mov qword [rsp + 72], 0
    mov qword [rsp + 80], 0
    mov qword [rsp + 88], 0
    mov eax, 0xc5
    syscall
    lea r10, [handle]
    mov eax, 0xf
    syscall
    add rsp, 96
    ret
endp
