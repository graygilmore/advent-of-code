require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/02/input.txt'))
    @input = input
  end

  def solution
    horizontal = 0
    depth = 0

    directions.each do |movement, value|
      case movement
      when "forward"
        horizontal += value.to_i
      when "up"
        depth -= value.to_i
      when "down"
        depth += value.to_i
      end
    end

    horizontal * depth
  end

  private

  attr_reader :input

  def directions
    @directions ||= input.chomp.lines.map(&:split)
  end
end

class PartTwo < PartOne
  def solution
    horizontal = 0
    depth = 0
    aim = 0

    directions.each do |movement, value|
      move_value = value.to_i
      case movement
      when "forward"
        horizontal += move_value
        depth += move_value * aim
      when "up"
        aim -= move_value
      when "down"
        aim += move_value
      end
    end

    horizontal * depth
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 150, PartOne.new(input).solution
    assert_equal 1947824, PartOne.new.solution
  end

  def test_part_two
    assert_equal 900, PartTwo.new(input).solution
    assert_equal 1813062561, PartTwo.new.solution
  end

  def input
    <<~INPUT
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    INPUT
  end
end
