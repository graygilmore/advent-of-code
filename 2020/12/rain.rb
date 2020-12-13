require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/12/input.txt'))
    @input = input
    @current_position = {
      N: 0,
      E: 0,
      S: 0,
      W: 0,
    }
    @current_direction = :E
    @directions = {
      N: 0,
      E: 90,
      S: 180,
      W: 270
    }
  end

  def solution
    instructions.each do |instruction|
      action, value = instruction

      case action
      when :N, :E, :S, :W
        current_position[action] += value
      when :L
        new_degrees = (directions[current_direction] - value) % 360
        @current_direction = directions.detect { |d,v| v == new_degrees }[0]
      when :R
        new_degrees = (directions[current_direction] + value) % 360
        @current_direction = directions.detect { |d,v| v == new_degrees }[0]
      when :F
        current_position[current_direction] += value
      end
    end

    (current_position[:E] - current_position[:W]).abs +
      (current_position[:N] - current_position[:S]).abs
  end

  private

  attr_reader :input, :current_direction, :current_position, :directions

  def instructions
    @instructions ||= begin
      input.split.map { |a| [a[0].to_sym, a[1..a.length].to_i] }
    end
  end
end

class PartTwo < PartOne
  def solution
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 25, PartOne.new(input).solution
    assert_equal 2879, PartOne.new.solution
  end

  def test_part_two
  end

  def input
    <<~INPUT
      F10
      N3
      F7
      R90
      F11
    INPUT
  end
end
