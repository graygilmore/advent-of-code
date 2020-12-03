require 'pry'
require 'minitest/autorun'
require 'pathname'

class PartOne
  def initialize(input = file_input)
    @input = input
  end

  def solution
    lateral_position = 0

    (1..input.length-1).to_a.count do |row_count|
      if input[row_count]
        lateral_position += 3

        if lateral_position >= input[row_count].length
          lateral_position = lateral_position - input[row_count].length
        end

        # Adding X's and O's so that I can debug this easier
        if input[row_count][lateral_position] == '#'
          input[row_count][lateral_position] = 'X'
        else
          input[row_count][lateral_position] = 'O'
        end

        input[row_count][lateral_position] == 'X'
      end
    end
  end

  private

  attr_reader :input

  def count_trees(right:, down:)
  end

  def file_input
    @file_input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).chomp.lines.map(&:chomp)
      end
  end
end

class PartTwo < PartOne
  def solution
    slopes.map do |slope|
      lateral_position = 0

      (1..input.length-1).to_a.count do |row_count|
        next if slope[:down] == 2 && row_count % 2 != 0

        if input[row_count]
          lateral_position += slope[:right]

          if lateral_position >= input[row_count].length
            lateral_position = lateral_position - input[row_count].length
          end

          input[row_count][lateral_position] == '#'
        end
      end
    end.inject(:*)
  end

  private

  def slopes
    [
      { right: 1, down: 1 },
      { right: 3, down: 1 },
      { right: 5, down: 1 },
      { right: 7, down: 1 },
      { right: 1, down: 2 },
    ]
  end
end

class TestToboggan < Minitest::Test
  def test_part_one
    assert_equal 7, PartOne.new([
      '..##.......',
      '#...#...#..',
      '.#....#..#.',
      '..#.#...#.#',
      '.#...##..#.',
      '..#.##.....',
      '.#.#.#....#',
      '.#........#',
      '#.##...#...',
      '#...##....#',
      '.#..#...#.#',
    ]).solution
  end

  def test_part_two
    assert_equal 336, PartTwo.new([
      '..##.......',
      '#...#...#..',
      '.#....#..#.',
      '..#.#...#.#',
      '.#...##..#.',
      '..#.##.....',
      '.#.#.#....#',
      '.#........#',
      '#.##...#...',
      '#...##....#',
      '.#..#...#.#',
    ]).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
