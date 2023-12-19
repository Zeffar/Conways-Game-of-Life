.data
x: .long 4           # Reserves 4 bytes of space for the variable x
format: .asciz "x are valoarea: %ld\n" # Defines a format string for printf

.text
.global main

main:
pushl x              # Pushes the address of x onto the stack
push $format         # Pushes the address of the format string onto the stack
call printf          # Calls printf with the arguments on the stack
add $8, %esp		 # Cleans up the stack (4 bytes * 2 arguments = 8 bytes)
pop %ebx             # Cleans up the stack
pop %ebx             # Cleans up the stack again

push $0
call fflush
pop %ebx

mov $1, %eax         # Sets up the return value for the syscall (1 is the code for exit)
mov $0, %ebx         # Sets up the exit status code (0 means success)
int $0x80            # Performs the syscall to exit the program