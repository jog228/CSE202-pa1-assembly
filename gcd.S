.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    movl %edi, %eax     # eax = a
    testl %esi, %esi    # ZF=1 if b == 0
    je .Ldone           # if b == 0, return a
    cltd                # edx:eax = sign-extend a to 64 bits
    idivl %esi          # eax = a / b, edx = a % b
    movl %esi, %edi     # edi = b
    movl %edx, %esi     # esi = a % b
    call gcd            # eax = gcd(b, a % b)
.Ldone:
    retq                # return eax


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
