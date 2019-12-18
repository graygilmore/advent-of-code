require 'pry'
require 'minitest/autorun'
require 'pathname'

class PartOne
  def initialize(digits = input, dimensions = [25,6])
    @digits = digits
    @dimensions = dimensions
  end

  def solution
    min_zero_layer.count(1) * min_zero_layer.count(2)
  end

  private

  def min_zero_layer
    @min_zero_layer ||=
      layers.map do |layer|
        [
          layer.count(0),
          layer
        ]
      end.to_h.sort.first[1]
  end

  def layers
    @layers ||=
      @digits.digits.reverse.each_slice(@dimensions[0] * @dimensions[1]).to_a
  end

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).to_i
      end
  end
end

class PartTwo < PartOne
  def solution
  end
end

class TestCircuit < Minitest::Test
  def test_part_one
  end

  def test_part_two
  end
end

puts "Part One: #{::PartOne.new.solution}"
# puts "Part Two: #{::PartTwo.new.solution}"
