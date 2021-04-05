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
end