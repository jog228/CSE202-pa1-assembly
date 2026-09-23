.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  cmpw %si, %di     # compute v1 - v2, set flags
  jl .Lv2first      # if v1 < v2, go to else
  movw %di, %r8w    # r8w = first = v1
  movw %si, %ax     # ax = second = v2
  jmp .Lcheckv3     # skip else
.Lv2first:
  movw %si, %r8w    # r8w = first = v2
  movw %di, %ax     # ax = second = v1
.Lcheckv3:
  cmpw %r8w, %dx    # compute v3 - first, set flags
  jle .Lv3second    # if v3 <= first, go to else if
  movw %r8w, %ax   # ax = second = first
  movw %dx, %r8w    # r8w = first = v3
  jmp .Lcheckv4     # skip else if
.Lv3second:
  cmpw %ax, %dx    # compute v3 - second, set flags
  jle .Lcheckv4     # if v3 <= second, no change
  movw %dx, %ax     # ax = second = v3
.Lcheckv4:
  cmpw %r8w, %cx    # compute v4 - first, set flags
  jle .Lv4second    # if v4 <= first, go to else if
  movw %r8w, %ax    # ax = second = first
  movw %cx, %r8w    # r8w = first = v4
  jmp .Ldone        # skip else if
.Lv4second:
  cmpw %ax, %cx     # compute v4 - second, set flags
  jle .Ldone        # if v4 <= second, no change
  movw %cx, %ax     # ax = second = v4
.Ldone:
  retq              # return second in ax

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
