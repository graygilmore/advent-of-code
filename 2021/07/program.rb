require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/07/input.txt'))
    @input = input
  end

  def solution
    min, max = positions.minmax

    fuel_payloads = {}

    (min..max).each do |i|
      fuel_payloads[i] = positions.map { fuel_calculation(_1, i) }.sum
    end

    fuel_payloads.values.min
  end

  private

  attr_reader :input

  def positions
    @positions ||= input.chomp.split(',').map(&:to_i)
  end

  def fuel_calculation(v, i)
    (v - i).abs
  end
end

class PartTwo < PartOne
  private

  def fuel_calculation(v, i)
    n = (v - i).abs
    (n * (n + 1)) / 2
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 37, PartOne.new(input).solution
    assert_equal 356992, PartOne.new.solution
  end

  def test_part_two
    assert_equal 168, PartTwo.new(input).solution
    assert_equal 101268110, PartTwo.new.solution
  end

  def input
    <<~INPUT
      16,1,2,0,4,2,7,1,2,14
    INPUT
  end
end
