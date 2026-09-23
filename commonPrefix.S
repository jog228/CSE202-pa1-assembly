.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  movl $0, %eax             # eax = n = 0
  movb (%rdi,%rax,1), %cl   # cl = a[n] = M[a + n]
  testb %cl, %cl            # ZF=1 if a[n] == '\0'
  je .Ldone                 # guard if a[n] == '\0', return n
  cmpb (%rsi,%rax,1), %cl   # compute a[n] - b[n], set flags
  jne .Ldone                # guard if a[n] != b[n], return n
.Lloop:
  addl $1, %eax             # eax = n = n + 1
  movb (%rdi,%rax,1), %cl   # cl = a[n] = M[a + n]
  testb %cl, %cl            # set flags on a[n]
  je .Ldone                 # if a[n] == '\0', exit loop
  cmpb (%rsi,%rax,1), %cl   # compute a[n] - b[n], set flags
  je .Lloop                 # compute a[n] == b[n], repeat loop
.Ldone:
  retq                      # return n in eax


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
