require 'pry'
require 'minitest/autorun'
require 'pathname'

class PartOne
  def initialize(input = file_input)
    @input = input
  end

  def solution
    count_trees(right: 3, down: 1)
  end

  private

  attr_reader :input

  def count_trees(right:, down:)
    lateral_position = 0

    (down..input.length-1).step(down).to_a.count do |row_count|
      if input[row_count]
        lateral_position += right
        input[row_count][lateral_position % input[row_count].length] == '#'
      end
    end
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
      count_trees(right: slope[:right], down: slope[:down])
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
    assert_equal 237, PartOne.new().solution
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
    assert_equal 2106818610, PartTwo.new().solution
  end
end
