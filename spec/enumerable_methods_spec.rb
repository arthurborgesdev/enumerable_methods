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
end