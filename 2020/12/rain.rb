require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/12/input.txt'))
    @input = input
  end

  def solution
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
    @current_position = {
      N: 0,
      E: 0,
      S: 0,
      W: 0,
    }
    @directions = {
      N: 0,
      E: 90,
      S: 180,
      W: 270
    }
    @waypoint = {
      N: 1,
      E: 10,
      S: 0,
      W: 0,
    }

    instructions.each do |instruction|
      action, value = instruction

      case action
      when :N, :E, :S, :W
        @waypoint[action] += value
      when :L, :R
        rotation = (value % 360) / 90 * (action == :R ? -1 : 1)

        next if rotation.zero?

        rotated_values = @waypoint.values.rotate(rotation)
        @waypoint.transform_values!.with_index { |_, i| rotated_values[i] }
      when :F
        current_position.each do |direction, _|
          @current_position[direction] += @waypoint[direction] * value
        end
      end
    end

    (current_position[:E] - current_position[:W]).abs +
      (current_position[:N] - current_position[:S]).abs
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 25, PartOne.new(input).solution
    assert_equal 2879, PartOne.new.solution
  end

  def test_part_two
    assert_equal 286, PartTwo.new(input).solution
    assert_equal 178986, PartTwo.new.solution
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
