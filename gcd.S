.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    movl %edi, %eax
    testl %esi, %esi
    je .Ldone
    cltd
    idivl %esi
    movl %esi, %edi
    movl %edx, %esi
    call gcd
.Ldone:
    retq


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
