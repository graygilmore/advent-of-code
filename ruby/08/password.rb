require 'pry'
require 'minitest/autorun'
require 'pathname'

class PartOne
  def initialize(digits = input, dimensions = [25,6])
    @digits = digits.chars
    @dimensions = dimensions
  end

  def solution
    min_zero_layer.count('1') * min_zero_layer.count('2')
  end

  private

  def min_zero_layer
    @min_zero_layer ||=
      layers.map do |layer|
        [layer.count('0'), layer]
      end.to_h.sort.first[1]
  end

  def layers
    @layers ||= @digits.each_slice(image_size).to_a
  end

  def image_size
    @image_size ||= @dimensions[0] * @dimensions[1]
  end

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).strip
      end
  end
end

class PartTwo < PartOne
  def solution
    image = layers.slice(0)
    layers.each do |layer|
      image.each_with_index do |_digit, i|
        if image[i] == '2'
          image[i] = layer[i]
        end
      end
    end

    image.each_slice(@dimensions[0]).to_a.map { |a| a.join('') }.join("\n")
  end
end

class TestCircuit < Minitest::Test
  def test_part_one
  end

  def test_part_two
    assert_equal "01\n10", PartTwo.new('0222112222120000', [2,2]).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: \n#{::PartTwo.new.solution}"
