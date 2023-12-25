.data
    m: .space 4
    n: .space 4
    p: .space 4
    x: .space 4
    y: .space 4
    k: .space 4
    a: .space 400
    b: .space 400
    i: .space 4
    j: .space 4
    turn: .space 4
    cnt: .space 4
    dir: .space 4
    dx: .long 0, 1, 0, -1, 1, 1, -1, -1
    dy: .long 1, 0, -1, 0, 1, -1, 1, -1
    fileRead: .asciz "in.txt"
    fileWrite: .asciz "out.txt"
    formatScan: .asciz "%ld"
    formatPrint: .asciz "%ld "
    modeRead: .asciz "r"
    modeWrite: .asciz "w"
    debug: .asciz "%ld\n" 
    newLine: .asciz "\n"
.text
.global main
main:
    pushl $modeRead
    pushl $fileRead
    call fopen
    popl %ecx
    popl %ecx
    movl %eax, %esi # file pointer for reading is in %ebx

    # Read m, n, p (yes, I swapped n and m, you monsters) 
    pushl $n        
    pushl $formatScan  
    pushl %esi             
    call fscanf                 
    popl %ecx
    popl %ecx
    popl %ecx
    

    pushl $m                 
    pushl $formatScan               
    pushl %esi             
    call fscanf                 
    popl %ecx
    popl %ecx
    popl %ecx

    pushl $p                
    pushl $formatScan               
    pushl %esi             
    call fscanf                 
    popl %ecx
    popl %ecx
    popl %ecx

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
    pushl %esi             
    call fscanf
    popl %ecx
    popl %ecx
    popl %ecx

    pushl $y
    pushl $formatScan
    pushl %esi             
    call fscanf
    popl %ecx
    popl %ecx
    popl %ecx
    


    movl x, %eax
    incl %eax
    xorl %edx, %edx
    movl m, %ebx
    addl $2, %ebx 
    mull %ebx
    addl y, %eax
    incl %eax
    

    # %eax = x * nr_coloane + y
    lea a, %edi
    movl $1, (%edi, %eax, 4)
    # now a[x][y]=1
    leal b, %edi
    movl $1, (%edi, %eax, 4)
    # now b[x][y]=1

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
    pushl %esi             
    call fscanf
    popl %ecx
    popl %ecx
    popl %ecx

    pushl %esi
    call fclose
    popl %ecx
    
    movl k, %ecx
    cmp $0, %ecx
        je write
        
    movl $0, turn
    #I hope the skelly is right, hot damn
    for_k:

        movl turn, %ecx
        cmpl k, %ecx
        je write

        movl $1, i
        lines:

            movl i, %ecx
            cmpl n, %ecx
                jg equalizer

            movl $1, j
            columns:
                    

                movl j, %ecx
                cmpl m, %ecx
                    jg incCol

                movl $0, dir
                movl $0, cnt
                directions:
                    movl dir, %ecx
                    cmpl $8, %ecx
                        je decision1

                    lea dx, %edi
                    movl dir, %ecx

                    movl i, %eax
                    cmpl $0, (%edi, %ecx, 4)
                        jg incI
                    cmpl $0, (%edi, %ecx, 4)
                        jl decI
                    
                    jmp contDirI

                    incI:
                        addl $1, %eax
                        jmp contDirI

                    decI:
                        subl $1, %eax
                        jmp contDirI


                    contDirI:
                    #%eax = i + dx[dir] 

                    lea dy, %edi
                    movl j, %ebx
                    cmpl $0, (%edi, %ecx, 4)
                        jg incJ
                    cmpl $0, (%edi, %ecx, 4)
                        jl decJ
                    
                    jmp contDirJ

                    incJ:
                        addl $1, %ebx
                        jmp contDirJ

                    decJ:
                        subl $1, %ebx
                        jmp contDirJ


                    contDirJ:
                    # %ebx = j + dy[dir]
        
                    # movl %eax, x
                    # movl %ebx, y
                    xorl %edx, %edx
                    movl m, %ecx
                    addl $2, %ecx
                    mull %ecx
                    addl %ebx, %eax
                    # %eax = %eax * nr_coloane + %ebx
                    lea a, %edi

                    cmpl $0, (%edi, %eax, 4)
                        jg et_inc_cnt
                    #technically, if(a[%eax][%ebx] != 0) cnt++

                    incl dir
                    jmp directions
                    
                    et_inc_cnt:
                        incl cnt
                        incl dir
                        jmp directions

                decision1:
                    movl cnt, %ecx
                    cmpl $2, %ecx
                        jl kill_b
                    #tooDo if (cnt<2) b[i][j] = 0;

                decision2:
                    movl cnt, %ecx
                    cmpl $3, %ecx
                        jg kill_b
                    #tooDo if (cnt>3) b[i][j] = 0;

                decision3:
                    movl cnt, %ecx
                    cmpl $3, %ecx
                        je birth_b
                    #tooDo if(cnt == 3) b[i][j]=1

                incDir:
                    incl j
                    jmp columns
            incCol:
                incl i 
                jmp lines


        
        equalizer:
        movl $1, i
        forI:
            movl i, %ecx
            cmpl n, %ecx
                jg incTurn
            movl $1, j

            forJ:
                movl j, %ecx
                cmpl m, %ecx
                    jg increment
                # a[i][j] = b[i][j]

                movl i, %eax
                xorl %edx, %edx
                movl m, %ebx
                addl $2, %ebx 
                mull %ebx
                addl j, %eax
                # %eax = x * nr_coloane + y
                leal b, %edi
                movl (%edi, %eax, 4), %ebp
                
                movl i, %eax
                xorl %edx, %edx
                movl m, %ebx
                addl $2, %ebx 
                mull %ebx
                addl j, %eax
                leal a, %edi
                movl %ebp, (%edi, %eax, 4)

                incl j  
                jmp forJ

            increment:
                incl i
                jmp forI

        incTurn:
            incl turn
            jmp for_k




    jmp write

kill_b:

    movl i, %eax
    xorl %edx, %edx
    movl m, %ebx
    addl $2, %ebx 
    mull %ebx
    addl j, %eax
    # %eax = x * nr_coloane + y
    leal b, %edi
    movl $0, (%edi, %eax, 4)
    # now b[x][y]=0

    jmp incDir

birth_b:

    movl i, %eax
    xorl %edx, %edx
    movl m, %ebx
    addl $2, %ebx 
    mull %ebx
    addl j, %eax
    # %eax = i * nr_coloane + j
    leal b, %edi
    movl $1, (%edi, %eax, 4)

    jmp incDir

write:
    #output matrix
    pushl $modeWrite
    pushl $fileWrite
    call fopen 
    popl %ecx
    popl %ecx
    movl %eax, %esi
    
    movl $1, i
    for_line:
        movl i, %ecx
        cmpl n, %ecx
        jg exit

        movl $1, j
        for_column:
            movl j, %ecx
            cmpl m, %ecx
            jg cont

            #print a[i][j]
            movl i, %eax
            movl $0, %edx
            movl m, %ebx
            addl $2, %ebx
            mull %ebx
            addl j, %eax
            #eax = i*m+j


            lea a, %edi
            movl (%edi, %eax, 4), %ebx

            pushl %ebx
            pushl $formatPrint
            pushl %esi
            call fprintf
            popl %ecx
            popl %ecx
            popl %ecx
    

            pushl $0
            call fflush
            popl %ecx

            incl j
            jmp for_column
    cont:

        pushl $newLine
        pushl $newLine
        pushl %esi
        call fprintf
        popl %ecx
        popl %ecx
        popl %ecx

        incl i
        jmp for_line
    
exit:

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
