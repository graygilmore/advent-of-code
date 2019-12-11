require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(wires = input)
    @wires = wires
  end

  def solution
    grid = { [0, 0] => [] }

    @wires.each_with_index do |wire, index|
      grid_position = [0, 0]

      wire.each do |wire_instructions|
        wire_direction = wire_instructions[0]
        wire_length = wire_instructions[1..-1].to_i

        for i in [*1..wire_length] do
          case wire_direction
          when 'U'
            grid_position = [grid_position[0], grid_position[1] + 1]
          when 'R'
            grid_position = [grid_position[0] + 1, grid_position[1]]
          when 'D'
            grid_position = [grid_position[0], grid_position[1] - 1]
          when 'L'
            grid_position = [grid_position[0] - 1, grid_position[1]]
          end

          if grid[grid_position]
            grid[grid_position].push(index)
          else
            grid[grid_position] = [index]
          end
        end
      end
    end

    overlapping_positions = grid.select { |key, wires| wires.uniq.length > 1 }

    overlapping_positions.map do |position, _value|
      position[0].abs + position[1].abs
    end.sort.first
  end

  private

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).chomp.lines.map(&:chomp).map{ |line| line.split(",") }
      end
  end
end

class PartTwo < PartOne
  def solution
    grid = { [0, 0] => {} }

    @wires.each_with_index do |wire, index|
      grid_position = [0, 0]
      wire_steps = 0

      wire.each do |wire_instructions|
        wire_direction = wire_instructions[0]
        wire_length = wire_instructions[1..-1].to_i

        for i in [*1..wire_length] do
          case wire_direction
          when 'U'
            grid_position = [grid_position[0], grid_position[1] + 1]
          when 'R'
            grid_position = [grid_position[0] + 1, grid_position[1]]
          when 'D'
            grid_position = [grid_position[0], grid_position[1] - 1]
          when 'L'
            grid_position = [grid_position[0] - 1, grid_position[1]]
          end

          wire_steps += 1

          if grid[grid_position] && !grid[grid_position][index]
            grid[grid_position][index] = wire_steps
          else
            grid[grid_position] = {
              index => wire_steps
            }
          end
        end
      end
    end

    overlapping_positions = grid.select { |key, wires| wires.length > 1 }

    overlapping_positions.map do |_position, wires|
      wires.values.inject(:+)
    end.sort.first
  end
end

class TestFuel < Minitest::Test
  # def test_part_one
  #   assert_equal 6, PartOne.new(
  #     [
  #       ['R8','U5','L5','D3'],
  #       ['U7','R6','D4','L4']
  #     ]
  #   ).solution
  #   assert_equal 159, PartOne.new(
  #     [
  #       ['R75','D30','R83','U83','L12','D49','R71','U7','L72'],
  #       ['U62','R66','U55','R34','D71','R55','D58','R83']
  #     ]
  #   ).solution
  #   assert_equal 135, PartOne.new(
  #     [
  #       ['R98','U47','R26','D63','R33','U87','L62','D20','R33','U53','R51'],
  #       ['U98','R91','D20','R16','D67','R40','U7','R15','U6','R7']
  #     ]
  #   ).solution
  # end

  def test_part_two
    assert_equal 30, PartTwo.new(
      [
        ['R8','U5','L5','D3'],
        ['U7','R6','D4','L4']
      ]
    ).solution
    assert_equal 610, PartTwo.new(
      [
        ['R75','D30','R83','U83','L12','D49','R71','U7','L72'],
        ['U62','R66','U55','R34','D71','R55','D58','R83']
      ]
    ).solution
    assert_equal 410, PartTwo.new(
      [
        ['R98','U47','R26','D63','R33','U87','L62','D20','R33','U53','R51'],
        ['U98','R91','D20','R16','D67','R40','U7','R15','U6','R7']
      ]
    ).solution
  end
end

# puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
