.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  movl $0, %eax       # eax = 0
  cmpl $2, %edi       # compute n - 2, set flags
  jl .Ldone           # if n < 2, return 0
  testl $1, %edi      # compute n & 1, set flags
  jne .Lodd           # if n is odd, go to the loop
  cmpl $2, %edi       # n is even: compute n - 2, set flags
  sete %al            # al = (n == 2), 1 if true, 0 if false
  jmp .Ldone          # return if n == 2
.Lodd:
  movl $3, %ecx       # ecx = i = 3 (init)
  movl %ecx, %r8d     # r8d = i
  imull %ecx, %r8d    # r8d = i * i
  cmpl %edi, %r8d     # compute i*i - n, set flags
  jg .Lprime          # if i*i > n, skip loop, n is prime
.Lloop:
  movl %edi, %eax     # eax = n
  cltd                # edx:eax= sign-extend n
  idivl %ecx          # eax = n / i, edx = n % i
  testl %edx, %edx    # set flags on n % i
  je .Lnotprime       # if n % i == 0, return 0
  addl $2, %ecx       # ecx = i = i + 2
  movl %ecx, %r8d     # r8d = i
  imull %ecx, %r8d    # r8d = i * i
  cmpl %edi, %r8d     # compute i*i - n, set flags
  jle .Lloop          # if i*i <= n, repeat loop
.Lprime:
  movl $1, %eax       # eax = 1 (n is prime)
  jmp .Ldone          # return 1
.Lnotprime:
  movl $0, %eax       # eax = 0 (n is not prime)
.Ldone:
  retq                # retrun eax


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
