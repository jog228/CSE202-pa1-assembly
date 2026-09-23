.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    movq $0, %rax       # rax = total = 0
    testq %rdi, %rdi    # ZF=1 if ptr == NULL
    je .Ldone           # if ptr == NULL, skip loop, return 0
.Lloop:
    addq 8(%rdi), %rax  # rax = total + ptr->value
    movq 16(%rdi), %rdi # rdi = ptr->next
    testq %rdi, %rdi    # set flags on new ptr
    jne .Lloop          # if ptr != NULL, repeat loop
.Ldone:
    retq                # return rax

# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
