require './lib/pretty_ancestors'


module M1
end

module M2
  include M1
end

module M3
end

module M4
end

module M5
end

class C
  include M4
  include M2
  prepend M5
end

class Object
  prepend M3
end

p C.pretty_ancestors

#prepend prepend
[M1, M2, M3]
[[[], M1, []], [[M1], M2, []], [[M1, M2], M3, []]]

#include include
[M3, M2, M1]
[[[], M3, [M2, M1]], [[], M2, [M1]], [[], M1, []]]

#include prepend
[M3, M1, M2]
[[[], M3, [M1, M2]], [[], M1, []], [[M1], M2, []]]

#prepend include
[M2, M1, M3]
[[[], M2, [M1]], [[], M1, []], [[M2, M1], M3, []]]
