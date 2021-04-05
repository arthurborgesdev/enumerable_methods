require_relative '../enumerable_methods'

describe Enumerable do
  describe '#my_each' do
    let(:a)  { ["a", "b", "c"] }
    it "prints each element of the array separated by ' -- '" do
      expect { a.my_each { |x| print x, " -- "} }.to output("a -- b -- c -- ").to_stdout
    end
    it "returns the array which was called upon" do
      expect(a.my_each { |x| print x, " -- "}).to be == a
    end
    it "returns an Enumerator if no block is passed for Array" do
      expect(a.my_each).to be_a(Enumerator)
    end

    h = {"a" => 100, "b" => 200 }
    it "puts each key/value pair of the hash in the format 'key is value'" do
      expect { h.my_each { |key, value| puts "#{key} is #{value}" } }.to output("a is 100\nb is 200\n").to_stdout
    end
    it "returns the hash which was called upon" do
      expect(h.my_each { |key, value| puts "#{key} is #{value}" }).to be == h
    end
    it "returns an Enumerator if no block is passed for Hash" do
      expect(h.my_each).to be_a(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    h = {"cat" => 0, "dog" => 1, "wombat" => 2}
    hash = {}
    array = %w(cat dog wombat)
    it 'return a hash which the key is the element and the value is its index' do
      array.my_each_with_index {|key, value| hash[key] = value }
      expect(hash).to eql(h)
    end
    it "returns the array which was called upon" do
      expect(array.my_each_with_index { |key, value| hash[key] = value }).to be == array
    end
    it "returns an Enumerator if no block is passed for Hash" do
      expect(array.my_each_with_index).to be_a(Enumerator)
    end
  end

  describe '#my_select' do
    it 'returns only an array with the multiple of 3 numbers in the Range' do
      expect((1..10).my_select { |i| i % 3 == 0 }).to eql([3, 6, 9])
    end
    it 'returns only an array with the even numbers on the Array' do
      expect([1, 2, 3, 4, 5].my_select { |num| num.even? }).to eql([2, 4])
    end
    it 'return only an array with the selected element in the Array' do
      expect([:foo, :bar].my_select { |x| x == :foo }).to eql([:foo])
    end
    it 'return an enumerator when a block is not passed' do
      expect((1..10).my_select).to be_a(Enumerator)
    end
  end

  let(:animals) { %w[ant bear cat] }
  let(:numbers) { [1, 2i, 3.14] }
  let(:multi_values) { [nil, true, 99] }

  describe '#my_all' do
    it 'returns true if all elements of the array have words with 3 or more letters' do
      expect(animals.my_all? { |word| word.length >= 3 }).to eql(true)
    end
    it 'returns false as not all elements have words with 4 or more letters' do
      expect(animals.my_all? { |word| word.length >= 4}).to eql(false)
    end
    it "accepts matching and returns false when not all elements have a match" do
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
end