.data
    m: .space 4
    n: .space 4
    p: .space 4
    x: .space 4
    y: .space 4
    k: .space 4
    a: .space 325
    i: .space 4
    j: .space 4

    formatScan: .asciz "%ld"
    formatPrint: .asciz "%ld "
    debug: .asciz "%ld\n"
    newLine: .asciz "\n"
.text


.global main
main:

    # Read
    pushl $m                 
    pushl $formatScan               
    call scanf                 
    addl $8, %esp

    pushl $n                 
    pushl $formatScan               
    call scanf                 
    addl $8, %esp

    pushl $p                
    pushl $formatScan               
    call scanf                 
    addl $8, %esp



    cmpl $0, p
        je write 

    movl $0, %edi



read_loop:
    cmpl %edi, p
    je cleanup

    pushl $x
    pushl $formatScan
    call scanf
    popl %ecx
    popl %ecx 

    pushl $y
    pushl $formatScan
    call scanf
    popl %ecx
    popl %ecx 

    addl $1, %edi
    jmp read_loop


cleanup:
    xorl %edi, %edi
    xorl %ecx, %ecx
    xorl %ebx, %ebx
    xorl %eax, %eax


solve:


write:
    movl $0, i

    for_line:
        movl i, %ecx
        cmp %ecx, n
        je exit

        movl $0, j
        for_column:
            movl j, %ecx
            cmp %ecx, m
            je cont

            #print a[i][j]
            movl i, %eax
            movl $0, %edx
            mull n
            addl j, %eax
            #eax = i*n+j

            lea a, %edi
            movl (%edi, %eax, 4), %ebx

            pushl %ebx
            pushl $formatPrint
            call printf
            addl $8, %esp



            incl j
            jmp for_column
    cont:

        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80

        incl i
        jmp for_line
    
exit:

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
