require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/07/input.txt'))
    @input = input
  end

  def solution
    min, max = positions.minmax

    least_fuel = nil

    (min..max).each do |i|
      new_fuel = positions.map { (_1 - i).abs }.sum
      if !least_fuel || new_fuel < least_fuel
        least_fuel = new_fuel
      end
    end

    least_fuel
  end

  private

  attr_reader :input

  def positions
    @positions ||= input.chomp.split(',').map(&:to_i)
  end
end

class PartTwo < PartOne
  def solution
    min, max = positions.minmax

    least_fuel = nil

    (min..max).each do |i|
      new_fuel = positions.map {
        v = (_1 - i).abs
        (v * (v + 1)) / 2
      }.sum

      if !least_fuel || new_fuel < least_fuel
        least_fuel = new_fuel
      end
    end

    least_fuel
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
