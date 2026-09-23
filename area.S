.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    leal (%rdi,%rsi), %eax      # eax = a + b
    addl %edx, %eax             # eax = a + b + c
    movl %edx, %ecx             # ecx = c
    cltd                        # edx:eax = sign-extend (a + b + c)
    movl $2, %r8d               # %r8d = 2 (divsor)
    idivl %r8d                  # eax = p = (a + b + c) / 2
    movl %eax, %r9d             # r9d = p
    movl %r9d, %r10d            # r10d = p
    subl %edi, %r10d            # r10d = p - a
    imull %r10d, %eax           # eax = p * (p - a)
    movl %r9d, %r10d            # r10d = p
    subl %esi, %r10d            # r10d = p - b
    imull %r10d, %eax           # eax = p * (p - a) * (p - b)
    movl %r9d, %r10d            # r10d = p
    subl %ecx, %r10d            # r10d = p - c
    imull %r10d, %eax           # eax = p * (p - a) * (p - b) * (p - c)
    movl %eax, %edi             # edi = p
    call r_sqrt                 # eax = r_sqrt(p)
    retq                        # return sqrt(p)
# x in %edi, result in %eax
r_sqrt:
    movl $-1, %eax              # eax = -1
    testl %edi, %edi            # set flags on x
    jl .Lret                    # if x < 0, return -1
    movl %edi, %eax             # eax = x
    cmpl $2, %edi               # compute x - 2, set flags
    jl .Lret                    # if x < 2, return x
    pushq %rbx                  # save caller's rbx
    movl %edi, %ebx             # ebx = x
    sarl $2, %edi               # edi = x >> 2
    call r_sqrt                 # eax = r_sqrt(x >> 2)
    sall $1, %eax               # eax = small_cand = r_sqrt(x >> 2) << 1
    leal 1(%rax), %ecx          # ecx = large_cand = small_cand + 1
    movl %ecx, %edx             # edx = large_cand
    imull %ecx, %edx            # edx = large_cand * large_cand
    cmpl %ebx, %edx             # computer large_cand^2 - x, set flags
    jg .Lpop                    # if large_cand^2 > x, return small_cand
    movl %ecx, %eax             # eax = large_cand
.Lpop:
    popq %rbx                   # restore caller's rbx
.Lret:
    retq                        # reurn eax

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
