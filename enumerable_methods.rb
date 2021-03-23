# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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
      else
        my_each { |el| check = false unless [el.class, el.class.superclass].include?(args[0]) }
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

  def my_inject(*arg)
    p arg
    arr = to_a
    n = arr[1]
    result = arr[0]
    i = 0
    while i < arr.size - 1
      result = yield(result, n)
      n = arr[i + 2]
      i += 1
    end
    result
  end
end

def multiply_els(args)
  args.my_inject{ |memo, n| memo * n }
end
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

#my_inject
# Same using a block and inject
(5..10).my_inject { |sum, n| sum + n }            #=> 45

# Same using a block
p (5..10).my_inject(3) { |product, n| product * n } #=> 151200
 #find the longest word
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
longest                                        #=> "sheep"