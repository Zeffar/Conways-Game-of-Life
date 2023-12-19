.data
    x: .space 4
    formatString: .asciz "%ld"
.text

.global main
main:
    pushl $x        #incarc adresa lui x in stiva
    pushl $x        #incarc adresa format ului in stiva
    call scanf      #scanf("%ld:, &x);

    popl %ebx
    popl %ebx       #eliberez stiva

    movl $1, %eax
    xorl %ebx, $ebx
    int $0x80