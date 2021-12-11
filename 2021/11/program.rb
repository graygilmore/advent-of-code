require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/11/input.txt'))
    @input = input
    @grid = initial_grid
    @flashes = 0
    @step = 0
  end

  def solution
    100.times do |i|
      @grid.each do |coord, value|
        @grid[coord] += 1
      end

      count_flashes
    end

    @flashes
  end

  private

  attr_reader :input

  def count_flashes
    @grid.select { |k, v| v > 9 }.each do |coord, value|
      @grid[coord] = 0
      @flashes += 1

      adjacent_tiles(coord).each do |adj|
        next if @grid[adj].nil?
        next if @grid[adj] == 0

        @grid[adj] += 1
      end
    end

    if @grid.any? { |k, v| v > 9 }
      count_flashes
    end
  end

  def adjacent_tiles(coord)
    x, y = coord
    [
      [x-1, y-1],
      [x-1, y],
      [x-1, y+1],
      [x, y-1],
      [x, y+1],
      [x+1, y-1],
      [x+1, y],
      [x+1, y+1],
    ]
  end

  def initial_grid
    obj = {}

    input.lines.map(&:chomp).each.with_index do |line, y|
      line.chars.each.with_index do |char, x|
        obj[[x,y]] = char.to_i
      end
    end

    obj
  end
end

class PartTwo < PartOne
  def solution
    while @grid.any? { |k, v| v != 0 } do
      @step +=1

      @grid.each do |coord, value|
        @grid[coord] += 1
      end

      count_flashes
    end

    @step
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 1656, PartOne.new(input).solution
    assert_equal 1649, PartOne.new.solution
  end

  def test_part_two
    assert_equal 195, PartTwo.new(input).solution
    assert_equal 256, PartTwo.new.solution
  end

  def input
    <<~INPUT
      5483143223
      2745854711
      5264556173
      6141336146
      6357385478
      4167524645
      2176841721
      6882881134
      4846848554
      5283751526
    INPUT
  end
end
