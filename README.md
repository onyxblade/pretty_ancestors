# pretty_ancestors

better ancestor info for ruby classes

## Usage

```ruby
module M1
end

module M2
  include M1
end

module M3
end

module M4
  prepend M3
end

module M5
end

class C
  include M4
  include M2
  prepend M5
end

pp C.pretty_ancestors
# =>
# [[[M5], C, [[M2, [M1]], [[M3], M4]]],
#  [Object,
#   [PP::ObjectMixin, Kernel]],
#  BasicObject]

pp C.pretty_ancestors(:raw)
# =>
# [[[[[], M5, []]], C, [[[], M2, [[[], M1, []]]], [[[[], M3, []]], M4, []]]],
#  [[], Object, [[[], PP::ObjectMixin, []], [[], Kernel, []]]],
#  [[], BasicObject, []]]

# C.pretty_ancestors.flatten will always be equal to C.ancestors
```
