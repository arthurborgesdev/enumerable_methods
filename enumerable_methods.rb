# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength, Metrics/ModuleLength

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      yield to_a[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < size
      yield to_a[i], i
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    selected_el = []
    my_each { |sel| selected_el << sel if yield sel }
    selected_el
  end

  def my_all?(*args)
    check = true
    if block_given?
      my_each { |el| check = false if yield(el) == false }
    elsif args.size.positive? # have argument - for matching
      if args[0].instance_of?(Regexp)
        my_each { |el| check = false unless args[0] =~ el }
      elsif args[0].instance_of?(Class)
        my_each { |el| check = false unless [el.class, el.class.superclass].include?(args[0]) }
      else
        my_each { |el| check = false unless el == args[0] }
      end
    else
      my_each { |el| check = false if [nil, false].include?(el) }
    end
    check
  end

  def my_any?(*args)
    check = false
    if block_given?
      my_each { |el| check = true if yield(el) == true }
    elsif args.size.positive? # have argument - for matching
      if args[0].instance_of?(Regexp)
        my_each { |el| check = true if args[0] =~ el }
      else
        my_each { |el| check = true if [el.class, el.class.superclass].include?(args[0]) }
      end
    else
      check = 0
      my_each { |el| check += 1 if el == true }
      return true if check.positive?

      return false
    end
    check
  end

  def my_none?(*args)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) == false }
    elsif args.size.positive? # have argument - for matching
      my_each { |el| count += 1 unless args[0] =~ el } if args[0].instance_of?(Regexp)
      my_each { |el| count += 1 unless [el.class, el.class.superclass].include?(args[0]) }
    else
      my_each { |el| count += 1 if [nil, false].include?(el) }
    end
    return true if count == size

    false
  end

  def my_count(*args)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) == true }
    elsif args.size.positive?
      my_each { |el| count += 1 if el == args[0] }
    else
      count = size
    end
    count
  end

  def my_map(prc = nil, &blk)
    return to_enum unless !prc.nil? || block_given?

    new_array = []
    prc.nil? ? my_each { |n| new_array << blk.call(n) } : my_each { |n| new_array << prc.call(n) }
    new_array
  end

  def my_inject(arg = nil, symbol = nil)
    if symbol.nil?
      symbol = arg
      arg = nil
    end
    arr = to_a
    if !arg.nil? && (symbol.is_a?(Symbol) || symbol.is_a?(String)) # both exists
      init = arg
      result = arr[0]
      i = 0
      while i < arr.size
        result = result.send(symbol, init)
        init = arr[i + 1]
        i += 1
      end
    elsif arg.nil? && (symbol.is_a?(Symbol) || symbol.is_a?(String)) # only symbol exists
      result = arr[0]
      init = arr[1]
      i = 0
      while i < arr.size - 1
        result = result.send(symbol, init)
        init = arr[i + 2]
        i += 1
      end
    elsif !arg.nil? && (!symbol.is_a?(Symbol) || !symbol.is_a?(String)) # only arg and block exists
      init = arg
      result = arr[0]
      i = 0
      while i < arr.size - 1
        result = yield(result, init)
        init = arr[i + 2]
        i += 1
      end
    else # when nothing exists (only block)
      result = arr[0]
      init = arr[1]
      i = 0
      while i < arr.size - 1
        result = yield(result, init)
        init = arr[i + 2]
        i += 1
      end
    end
    result
  end
end

def multiply_els(args)
  args.my_inject { |result, init| result * init }
end
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength, Metrics/ModuleLength


# my_all?
p "%w[ant bear cat].my_all? { |word| word.length >= 3 } #{%w[ant bear cat].my_all? { |word| word.length >= 3 }}" #=> true
p "%w[ant bear cat].my_all? { |word| word.length >= 4 } #{%w[ant bear cat].my_all? { |word| word.length >= 4 }}" #=> false
p "%w[ant bear cat].my_all?(/t/)                        #{%w[ant bear cat].my_all?(/t/)}"                        #=> false
p "[1, 2i, 3.14].my_all?(Numeric)                       #{[1, 2i, 3.14].my_all?(Numeric)}"                       #=> true
p "[nil, true, 99].my_all?                              #{[nil, true, 99].my_all?}"                              #=> false
p "[].my_all?                                           #{[].my_all?}"                                           #=> true

p "---"
p [1, 2i, 3.14].my_all?(2i)  
p [1, 2i, 3.14].my_all?(1)  
p [1, 1, 1].my_all?(1)

=begin
#my_any?
p "%w[ant bear cat].my_any? { |word| word.length >= 3 } #{%w[ant bear cat].my_any? { |word| word.length >= 3 }}" #=> true
p "%w[ant bear cat].my_any? { |word| word.length >= 4 } #{%w[ant bear cat].my_any? { |word| word.length >= 4 }}" #=> true
p "%w[ant bear cat].my_any?(/d/)                        #{%w[ant bear cat].my_any?(/d/) }"                       #=> false
p "[nil, true, 99].my_any?(Integer)                     #{[nil, true, 99].my_any?(Integer)}"                     #=> true
p "[nil, true, 99].my_any?                              #{[nil, true, 99].my_any? }"                             #=> true
p "[].my_any?                                           #{[].my_any?}"                                           #=> false

#my_none?
p "%w{ant bear cat}.my_none? { |word| word.length == 5 } #{%w{ant bear cat}.my_none? { |word| word.length == 5 }}" #=> true
p "%w{ant bear cat}.my_none? { |word| word.length >= 4 } #{%w{ant bear cat}.my_none? { |word| word.length >= 4 }}" #=> false
p "%w{ant bear cat}.my_none?(/d/)                        #{%w{ant bear cat}.my_none?(/d/)}"                        #=> true
p "[1, 3.14, 42].my_none?(Float)                         #{[1, 3.14, 42].my_none?(Float)}"                         #=> false
p "[].my_none?                                           #{[].my_none?}"                                           #=> true
p "[nil].my_none?                                        #{[nil].my_none?}"                                        #=> true
p "[nil, false].my_none?                                 #{[nil, false].my_none?}"                                 #=> true
p "[nil, false, true].my_none?                           #{[nil, false, true].my_none?}"                           #=> false
=end