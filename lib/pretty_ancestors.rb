class Module
  def prepended_modules
    ancestors.take_while{|x| x != self}
  end

  def included_modules
    ancestors.drop_while{|x| x != self}.drop(1).take_while{|x| x.instance_of? Module}
  end

  def pretty_ancestors
    map = {}

    analyze = lambda do |mod|
      #p mod
      case
      when map[mod]
        false
      when mod.prepended_modules.empty? && mod.included_modules.empty?
        map[mod] = true
        mod
      else
        a = mod.prepended_modules.reverse.map do |x|
          analyze.call x
        end.select(&:itself).reverse

        b = mod.included_modules.reverse.map do |x|
          analyze.call x
        end.select(&:itself).reverse

        map[mod] = true

        if a.empty? && b.empty?
          mod
        else
          [a, mod, b]
        end
      end
    end

    if self.instance_of? Class
      ancestors.select{|x| x.instance_of? Class}.reverse.map{|x| analyze.call x}.reverse
    else
      analyze.call self
    end
  end
end

