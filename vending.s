.global  main
.data
ten: .long 10
itoa_string: .ascii "    "
msg:
    .ascii "\nenter coin choice (q/Q,d/D,n/N):" # length 34
    len = . - msg 	# setting len to current position - position of msg = 34
coinchoice:
    .ascii "    "
counter: .long 0
unit: .ascii " cents\n"
current: .ascii "change:"
final: .ascii "end change:"
.text
main:
#   similar to eax = write(1,"\nenter coin choice (q/Q,d/D,n/N):",34)
    mov    $4,%eax
    mov    $1,%ebx
    mov    $msg,%ecx
    mov    $len,%edx
    int    $0x80
#   similar to eax = read(0,&coinchoice,2)
    mov    $3,%eax
    mov    $0,%ebx
    mov    $coinchoice,%ecx
    mov    $2,%edx
    int    $0x80

#   if coinchoice == 'q' jump to add25 to add 25 to counter and print the new value
    cmpb   $'q',coinchoice
    je     add25
#   if coinchoice == 'Q' jump to add25 to add 25 to counter and print the new value
    cmpb   $'Q',coinchoice
    je     add25
    cmpb   $'d',coinchoice
    je     add10
    cmpb   $'D',coinchoice
    je     add10
    cmpb   $'n',coinchoice
    je     add5
    cmpb   $'N',coinchoice
    je     add5
    jmp    call_exit
add25:
    add    $25,counter

    mov    $4,%eax
    mov    $1,%ebx
    mov    $current,%ecx
    mov    $7,%edx
    int    $0x80

    call   itoa		# jump to the label itoa, which will return to next instruction
    mov    %edi,%esi   # so now esi has the memory address of the space right before the first digit
    inc    %esi         # now it is on the memory of the first digit

    lea    itoa_string+4,%eax      #space after last digit
    mov    %eax,%edx
    sub    %esi,%edx   #now edx has the exact length of the digit
    
    mov    $4,%eax
    mov    $1,%ebx
    mov    %esi,%ecx    #the first digit is the first buffer
    int    $0x80

    mov    $4,%eax
    mov    $1,%ebx
    mov    $unit,%ecx
    mov    $6,%edx
    int    $0x80

    jmp     main
add10:
    add   $10,counter

    mov    $4,%eax
    mov    $1,%ebx
    mov    $current,%ecx
    mov    $7,%edx
    int    $0x80

    call   itoa         # jump to the label itoa, which will return to next instruction
    mov    %edi,%esi   # so now esi has the memory address of the space right before the first digit
    inc    %esi         # now it is on the memory of the first digit

    lea    itoa_string+4,%eax      #space after last digit
    mov    %eax,%edx
    sub    %esi,%edx   #now edx has the exact length of the digit

    mov    $4,%eax
    mov    $1,%ebx
    mov    %esi,%ecx    #the first digit is the first buffer
    int    $0x80

    mov    $4,%eax
    mov    $1,%ebx
    mov    $unit,%ecx
    mov    $6,%edx
    int    $0x80

    jmp    main
add5:
    add    $5,counter
    
    mov    $4,%eax
    mov    $1,%ebx
    mov    $current,%ecx
    mov    $7,%edx
    int    $0x80

    call   itoa         # jump to the label itoa, which will return to next instruction
    mov    %edi,%esi   # so now esi has the memory address of the space right before the first digit
    inc    %esi         # now it is on the memory of the first digit

    lea    itoa_string+4,%eax      #space after last digit
    mov    %eax,%edx
    sub    %esi,%edx   #now edx has the exact length of the digit

    mov    $4,%eax
    mov    $1,%ebx
    mov    %esi,%ecx    #the first digit is the first buffer
    int    $0x80

    mov    $4,%eax
    mov    $1,%ebx
    mov    $unit,%ecx
    mov    $6,%edx
    int    $0x80

    jmp    main
# exit here
call_exit:
    mov    $4,%eax
    mov    $1,%ebx
    mov    $final,%ecx
    mov    $12,%edx
    int    $0x80
    
    mov    %edi,%esi   # so now esi has the memory address of the space right before the first digit
    inc    %esi         # now it is on the memory of the first digit

    lea    itoa_string+4,%eax      #space after last digit
    mov    %eax,%edx
    sub    %esi,%edx   #now edx has the exact length of the digit

    mov    $4,%eax
    mov    $1,%ebx
    mov    %esi,%ecx    #the first digit is the first buffer
    int    $0x80
    
    mov    $4,%eax
    mov    $1,%ebx
    mov    $unit,%ecx
    mov    $7,%edx
    int    $0x80

    mov    $1,%eax
    mov    $0,%ebx
    int    $0x80

#   Function itoa() to convert integer variable counter's value to ASCII characters, placed in variable itoa_string.
itoa:
#   copy counter to %eax to prepare for division
    mov    counter,%eax
#   copy four spaces to itoa_string
    movl   $0x20202020,itoa_string
#   point %edi index register to the last byte of itoa_string, think:
#   char *itoa_string="    ";
#   char *edi = &itoa_string[1];
    lea    itoa_string+3,%edi
itoa_loop:
    mov    $0,%edx
    idivl  ten
    addl   $'0',%edx	# convert from binary 0 (or 1-9) to '0' (or '1'-'9')
    movb   %dl,(%edi)	# think: *(edi) = '0'
    dec    %edi		# think: edi--;
    cmpl   $0,%eax
    jg     itoa_loop
    ret			# ret: returns/jumps to the instruction after CALL itoa
