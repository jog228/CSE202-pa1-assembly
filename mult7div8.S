.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movsbl %dil, %edi     # edi = a
  leal (,%rdi,8), %eax  # eax = 8a
  subl %edi, %eax       # eax = 8a - a = 7a
  movsbl %al, %eax      # eax = mult = (char)(7a)
  testl %edi, %edi      # set flags on a
  jg .Lapos             # if a > 0, go check mult < 0
  je .Lnoovf            # if a == 0, no overflow
  testl %eax, %eax      # a < 0 here; set flags on mult
  jg .Lovf              # if a < 0 && mult > 0, overflow
  jmp .Lnoovf           # else no overflow
.Lapos:
  testl %eax, %eax      # a > 0 here: set flags on mult
  jl .Lovf              # if a > 0 && mult < 0, overflow
.Lnoovf:
  movb $0, (%rsi)       # *overflow = 0
  jmp .Ldiv             # skip overflow branch
.Lovf:
  movb $1, (%rsi)       # *overflow = 1
.Ldiv:
  cltd                  # edx:eax = sign-extend mult to 64 bits
  movl $8, %ecx         # ecx = 8 (divsor)
  idivl %ecx            # eax = mult / 8, edx = mult % 8
  ret                   # return mult / 8 in eax



# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
