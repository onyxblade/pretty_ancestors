require './lib/pretty_ancestors'

module M1
end

module M2
  include M1
end

module M3
  prepend M2
end

p M3.ancestors
p M3.ancestors.map{|x| [x.prepended_modules, x, x.included_modules]}
p M3.pretty_ancestors

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
