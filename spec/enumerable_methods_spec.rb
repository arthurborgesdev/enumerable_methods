require_relative '../enumerable_methods'

describe Enumerable do
  describe '#my_each' do
    it "prints each element of the array separated by ' -- '" do
      a = ["a", "b", "c"]
      expect { a.my_each { |x| print x, " -- "} }.to output("a -- b -- c -- ").to_stdout
    end
  end
end