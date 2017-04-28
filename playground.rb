require './lib/pretty_ancestors'
require 'pp'

module M1
end

module M2
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

module M2
  include M1
end

pp C.pretty_ancestors