section .data
bufr times 2000 db 32
pidv dq 0.017453292519943295
rad dq 10.0
midw dq 40.0
midh dq 12.0
depth dq 5.0
half dq 0.5
angl dq 0.0
tmpx dq 0.0
tmpy dq 0.0
tmpz dq 0.0
dlys dq 0
dlyn dq 50000
shade db ' .,*O@'

section .text
global _start

_start:
finit

main_loop:
mov rdi,bufr
mov rcx,2000
mov al,32
rep stosb

xor r12,r12
lat_loop:
xor r13,r13
lon_loop:
push r12
fild qword [rsp]
add rsp,8
fmul qword [pidv]
fsin
fmul qword [rad]
fstp qword [tmpy]

push r13
fild qword [rsp]
add rsp,8
fmul qword [pidv]
fcos
fmul qword [rad]
fstp qword [tmpx]

push r13
fild qword [rsp]
add rsp,8
fmul qword [pidv]
fsin
fmul qword [rad]
fstp qword [tmpz]

fld qword [tmpx]
fld qword [angl]
fcos
fmulp
fld qword [tmpz]
fld qword [angl]
fsin
fmulp
faddp
fstp qword [tmpx]

fld qword [tmpx]
fadd qword [midw]
fistp qword [tmpx]

fld qword [tmpy]
fadd qword [midh]
fistp qword [tmpy]

mov rax,[tmpx]
mov rbx,[tmpy]
cmp rax,0
jl skip
cmp rax,79
jg skip
cmp rbx,0
jl skip
cmp rbx,24
jg skip

imul rbx,80
add rax,rbx

fld qword [tmpz]
fadd qword [rad]
fmul qword [half]
fistp qword [tmpz]
mov rcx,[tmpz]
and rcx,5
mov dl,byte [shade+rcx]
mov rdi,bufr
add rdi,rax
mov [rdi],dl

skip:
inc r13
cmp r13,90
jl lon_loop

inc r12
cmp r12,45
jl lat_loop

fld qword [angl]
fadd qword [pidv]
fstp qword [angl]

mov rax,1
mov rdi,1
mov rsi,bufr
mov rdx,2000
syscall

mov rax,35
mov rdi,dlys
xor rsi,rsi
syscall

jmp main_loop

mov rax,60
xor rdi,rdi
syscall