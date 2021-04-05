require_relative '../enumerable_methods'

describe Enumerable do
  describe '#my_each' do
    let(:a) { %w[a b c] }
    it "prints each element of the array separated by ' -- '" do
      expect { a.my_each { |x| print x, ' -- ' } }.to output('a -- b -- c -- ').to_stdout
    end
    it 'returns the array which was called upon' do
      expect(a.my_each { |x| print x, ' -- ' }).to be == a
    end
    it 'returns an Enumerator if no block is passed for Array' do
      expect(a.my_each).to be_a(Enumerator)
    end

    h = { 'a' => 100, 'b' => 200 }
    it "puts each key/value pair of the hash in the format 'key is value'" do
      expect { h.my_each { |key, value| puts "#{key} is #{value}" } }.to output("a is 100\nb is 200\n").to_stdout
    end
    it 'returns the hash which was called upon' do
      expect(h.my_each { |key, value| puts "#{key} is #{value}" }).to be == h
    end
    it 'returns an Enumerator if no block is passed for Hash' do
      expect(h.my_each).to be_a(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    h = { 'cat' => 0, 'dog' => 1, 'wombat' => 2 }
    hash = {}
    array = %w[cat dog wombat]
    it 'return a hash which the key is the element and the value is its index' do
      array.my_each_with_index { |key, value| hash[key] = value }
      expect(hash).to eql(h)
    end
    it 'returns the array which was called upon' do
      expect(array.my_each_with_index { |key, value| hash[key] = value }).to be == array
    end
    it 'returns an Enumerator if no block is passed for Hash' do
      expect(array.my_each_with_index).to be_a(Enumerator)
    end
  end

  describe '#my_select' do
    it 'returns only an array with the multiple of 3 numbers in the Range' do
      expect((1..10).my_select { |i| i % 3 == 0 }).to eql([3, 6, 9])
    end
    it 'returns only an array with the even numbers on the Array' do
      expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([2, 4])
    end
    it 'return only an array with the selected element in the Array' do
      expect(%i[foo bar].my_select { |x| x == :foo }).to eql([:foo])
    end
    it 'return an enumerator when a block is not passed' do
      expect((1..10).my_select).to be_a(Enumerator)
    end
  end

  let(:animals) { %w[ant bear cat] }
  let(:numbers) { [1, 2i, 3.14] }
  let(:multi_values) { [nil, true, 99] }

  describe '#my_all?' do
    it 'returns true if all elements of the array have words with 3 or more letters' do
      expect(animals.my_all? { |word| word.length >= 3 }).to eql(true)
    end
    it 'returns false as not all elements have words with 4 or more letters' do
      expect(animals.my_all? { |word| word.length >= 4 }).to eql(false)
    end
    it 'accepts matching and returns false when not all elements have a match' do
      expect(animals.my_all?(/t/)).to eql(false)
    end
    it 'accepts matching against classes and return true when not all elements have a match' do
      expect(numbers.my_all?(Numeric)).to eql(true)
    end
    it 'checks if all elements are true, return true when they are and false otherwise' do
      expect(multi_values.my_all?).to eql(false)
    end
    it 'returns true when the array is empty (none elements passed)' do
      expect([].my_all?).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'returns true if any element of the array have 3 or more letters' do
      expect(animals.my_any? { |word| word.length >= 3 }).to eql(true)
    end
    it 'returns true if at least one element have 4 or more letters' do
      expect(animals.my_any? { |word| word.length >= 4 }).to eql(true)
    end
    it 'accepts matching and returns false when none elements have a match' do
      expect(animals.my_any?(/d/)).to eql(false)
    end
    it 'accepts matching against classes and return true when at least one element have a match' do
      expect(multi_values.my_any?(Integer)).to eql(true)
    end
    it 'checks if at least one element is true, return true when there is and false otherwise' do
      expect(multi_values.my_any?).to eql(true)
    end
    it 'returns false when the array is empty (none elements passed)' do
      expect([].my_any?).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'returns true if none element of the array have 5 letters' do
      expect(animals.my_none? { |word| word.length == 5 }).to eql(true)
    end
    it 'returns false as at least one element have 4 or more letters' do
      expect(animals.my_none? { |word| word.length >= 4 }).to eql(false)
    end
    it 'accepts matching and returns true when none elements have a match' do
      expect(animals.my_none?(/d/)).to eql(true)
    end
    it 'accepts matching against classes and return false as there is at least one element matching' do
      numbers = [1, 3.14, 42]
      expect(numbers.my_none?(Float)).to eql(false)
    end
    it 'returns true when the array is empty (none elements passed)' do
      expect([].my_none?).to eql(true)
    end
    it 'returns true when all elements of the Array are nil' do
      expect([nil].my_none?).to eql(true)
    end
    it 'returns true when all elements of the Array are nil or false' do
      expect([nil, false].my_none?).to eql(true)
    end
    it 'checks if at least one element is true, return false when there is and false otherwise' do
      values = [nil, false, true]
      expect(values.my_none?).to eql(false)
    end
  end

  describe '#my_count' do
    let(:array) { [1, 2, 4, 2] }
    it 'returns the number of elements in the array' do
      expect(array.my_count).to eql(4)
    end
    it 'returns the number of occurrences of the argument passed in the array' do
      expect(array.my_count(2)).to eql(2)
    end
    it 'returns the number of ocurrences in the array that satisfies the block passed' do
      expect(array.my_count(&:even?)).to eql(3)
    end
  end

  describe '#my_map' do
    let(:range) { (1..4) }

    it 'multiplies each element by itself in the Range' do
      expect(range.my_map { |i| i**2 }).to eql([1, 4, 9, 16])
    end
    it 'return the result of a block for each element on the array called upon' do
      expect(range.my_map { 'cat' }).to eql(%w[cat cat cat cat])
    end
    it 'returns an Enumerator when none block is given' do
      expect(range.my_map).to be_a(Enumerator)
    end
  end

  describe '#my_inject' do
    let(:range) { (5..10) }

    it 'returns the accumulation of values passed for each element in array (no argument passed)' do
      expect(range.my_inject { |sum, n| sum + n }).to eql(45)
    end
    it 'returns the accumulation of values passed for each element with argument as starting point (argument passed)' do
      expect(range.my_inject(1) { |product, n| product * n }).to eql(151_200)
    end
    it 'returns the longest word in the array' do
      longest = %w[cat sheep bear].my_inject do |memo, word|
        memo.length > word.length ? memo : word
      end
      expect(longest).to eql('sheep')
    end
  end

  describe '#multiply_els' do
    let(:array) { [2, 4, 5] }
    it 'multiplies all the elements of the array' do
      expect(array.my_inject { |memo, n| memo * n }).to eql(40)
    end
  end
end
