.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    movl $0, %eax                   # eax = i = 0
    cmpl %ecx, %eax                 # compute i - size, set flags
    jae .Ldone                      # guard if i >= size, skip loop
.Lloop:
    movss (%rdi,%rax,4), %xmm0      # xmm0 = a[i] = M[a + 4i]
    mulss (%rsi,%rax,4), %xmm0      # xmm0 = a[i] * b[i], b[i] = M[b + 4i]
    movss %xmm0, (%rdx,%rax,4)      # c[i] = a[i] * b[i], M[c + 4i] = xmm0
    addl $1, %eax                   # eax = i = i + 1
    cmpl %ecx, %eax                 # compute i - size, set flags
    jb .Lloop                       # if i < size, repeat loop
.Ldone:
    retq                            # return (void)

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
