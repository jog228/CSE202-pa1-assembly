.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  movl %esi, %r8d           # r8d = n
  shrl $1, %r8d             # r8d = n/2
  movl $0, %eax             # eax = i = 0
  cmpl %r8d, %eax           # compute i - n/2 (unsigned), skip loop
  jae .Ldone                # guard if i >= n/2 (unsigned), skip loop
.Lloop:
  movl %esi, %ecx           # ecx = n
  subl %eax, %ecx           # ecx = n - i
  subl $1, %ecx             # ecx = n - i - 1
  movq (%rdi,%rax,8), %rdx  # rdx = temp = list[i] = M[list + 8i]
  movq (%rdi,%rcx,8), %r9   # r9 = list[n-i-1] = M[list + 8(n-i-1)]
  movq %r9, (%rdi,%rax,8)   # list[i] = list[n-i-1]
  movq %rdx, (%rdi,%rcx,8)  # list[n-i-1] = temp
  addl $1, %eax             # eax = i = i + 1
  cmpl %r8d, %eax           # compute i - n/2, set flags
  jb .Lloop                 # if i < n/2, repeat loop
.Ldone:
  retq                      # return (void)


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
