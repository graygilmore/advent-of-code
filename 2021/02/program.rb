require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/02/input.txt'))
    @input = input
  end

  def solution
    horizontal = 0
    depth = 0

    instructions.each do |direction, value|
      movement = value.to_i
      case direction
      when "forward"
        horizontal += movement
      when "up"
        depth -= movement
      when "down"
        depth += movement
      end
    end

    horizontal * depth
  end

  private

  attr_reader :input

  def instructions
    @instructions ||= input.chomp.lines.map(&:split)
  end
end

class PartTwo < PartOne
  def solution
    horizontal = 0
    depth = 0
    aim = 0

    instructions.each do |direction, value|
      movement = value.to_i
      case direction
      when "forward"
        horizontal += movement
        depth += movement * aim
      when "up"
        aim -= movement
      when "down"
        aim += movement
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
