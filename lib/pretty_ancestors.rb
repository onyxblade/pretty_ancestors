class Module
  def modules_prepended
    ancestors.take_while{|x| x != self}
  end

  def modules_included
    ancestors.drop_while{|x| x != self}.drop(1).select{|x| x.instance_of? Module}
  end

  def shift_recur mods, map, level
    return [[], map] if mods.empty?
    origin_map = map
    init, *tail = mods

    if map[init]
      if map[init] < level
        return false, map
      else
        result, map = shift_recur(tail, map, level + 1)
        if result
          return result, map
        else
          return false, map
        end
      end
    end

    prepended = init.modules_prepended
    included = init.modules_included

    in_front, map = shift_recur(prepended, map.merge(init => level), level + 1)
    behind, map = shift_recur(included, map.merge(init => level), level + 1)
    #p [in_front, behind]
    if in_front && behind
      result, map = shift_recur(tail, map.merge(init => level), level + 1)
      if result
        if in_front.empty? && behind.empty?
          [[init].concat(result), map]
        else
          [[[in_front, init, behind]].concat(result), map]
        end
      else
        map = origin_map
        shift_recur(tail, map, level)
      end
    else
      [false, map]
    end

  end

  def pretty_ancestors
    if self.instance_of? Module
      shift_recur([self], {}, 0)[0][0]
    elsif self.instance_of? Class
      ancestors.select{|x| x.instance_of? Class}.reverse.reduce([[], {}]) do |(arr, map), x|
        result = shift_recur([x], map, 0)
        #p result
        arr << result[0][0]
        [arr, map.merge(x.ancestors.map{|x| [x, 99]}.to_h)]
      end[0].reverse
    end
  end
end

