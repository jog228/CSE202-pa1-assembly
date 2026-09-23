.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  movl $0, %eax             # eax = lo = 0
  movl %esi, %r8d           # r8d = n
  subl $1, %r8d             # r8d = hi = (int)n - 1
  cmpl %r8d, %eax           # compute lo - hi, set flags
  jg .Lnotfound             # guard if lo > hi, return -1
.Lloop:
  movl %r8d, %ecx           # ecx = hi
  subl %eax, %ecx           # ecx = hi - lo
  sarl $1, %ecx             # ecx = (hi - lo) / 2
  addl %eax, %ecx           # ecx = mid = (hi - lo) / 2
  movl (%rdi,%rcx,4), %r9d  # r9d = arr[mid] = M[arr + 4*mid]
  cmpl %edx, %r9d           # compute arr[mid] - target, set flags
  je .Lfound                # if arr[mid] == target, return mid
  jl .Lgoright              # else if arr[mid] < target, search right half
  leal -1(%rcx), %r8d       # else r8d = hi = mid - 1
  jmp .Ltest                # skip else-if branch
.Lgoright:
  leal 1(%rcx), %eax        # eax = lo = mid + 1
.Ltest:
  cmpl %r8d, %eax           # compute lo - hi, set flags
  jle .Lloop                # if lo <= hi, repeat loop
.Lnotfound:
  movl $-1, %eax            # eax = -1
  jmp .Ldone                # return -1
.Lfound:
  movl %ecx, %eax           # eax = mid
.Ldone:
  retq                      # return eax


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
