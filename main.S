.data
    m: .space 4
    n: .space 4
    p: .space 4
    x: .space 4
    y: .space 4
    k: .space 4
    a: .space 400
    i: .space 4
    j: .space 4
    dir: .space 4

    formatScan: .asciz "%ld"
    formatPrint: .asciz "%ld "
    debug: .asciz "%ld\n" #may the Lord have mercy on me
    newLine: .asciz "\n"
.text


.global main
main:

    # Read m, n, p (yes, I swapped n and m, you monsters) 
    pushl $n        
    pushl $formatScan               
    call scanf                 
    addl $8, %esp

    pushl $m                 
    pushl $formatScan               
    call scanf                 
    addl $8, %esp

    pushl $p                
    pushl $formatScan               
    call scanf                 
    addl $8, %esp



    cmpl $0, p
        je cleanup 

    movl $0, k



read_loop:
    #input (x, y) as the live coordinates. 

    movl k, %ecx
    cmpl %ecx, p
    je cleanup

    pushl $x
    pushl $formatScan
    call scanf
    addl $8, %esp

    pushl $y
    pushl $formatScan
    call scanf
    addl $8, %esp 


    movl x, %eax
    xorl %edx, %edx
    mull m
    addl y, %eax
    # %eax = x * nr_coloane + y
    leal a, %edi
    movl $1, (%edi, %eax, 4)

    incl k
    jmp read_loop


cleanup:
    xorl %edi, %edi
    xorl %edx, %edx
    xorl %ecx, %ecx
    xorl %ebx, %ebx
    xorl %eax, %eax
    movl $0, k
    #no idea if this helps, got lost in debugging
    #hope I'll remember deleting this to check if it works
    

solve: 
    #I'm throwing up so hard rn

    pushl $k
    pushl $formatScan
    call scanf
    addl $8, %esp

    for_k:

        movl k, %ecx
        cmp %ecx, $0
        je write

        movl $0, i
        lines:
            mov i, %ecx
            cmp %ecx, n
            je incLin

            movl $0, j
            columns:
                mov j, %ecx
                cmp %ecx, m
                je incCol

                movl $0, dir
                directions:
            
            incDir:

        incCol:

    incLin:


    


write:
    #output matrix, stolen from cs.unibuc.ro/~crusu/asc/labs.html
    #hope this doesn't count as plagiarism

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
            mull m
            addl j, %eax
            #eax = i*n+j


            lea a, %edi
            movl (%edi, %eax, 4), %ebx

            pushl %ebx
            pushl $formatPrint
            call printf
            addl $8, %esp

            pushl $0
            call fflush
            addl $4, %esp

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
