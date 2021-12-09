require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/09/input.txt'))
    @input = input
  end

  def solution
    low_points.values.map { _1.to_i + 1 }.sum
  end

  private

  attr_reader :input

  def low_points
    @low_points ||= begin
      grid.select do |coord, value|
        x, y = coord

        above = grid[[x,y+1]]
        below = grid[[x,y-1]]
        left = grid[[x-1,y]]
        right = grid[[x+1,y]]

        comps = [above, below, left, right].compact
        comps.all? { value < _1 }
      end
    end
  end

  def grid
    @grid ||= begin
      lines = input.lines.map(&:chomp).map(&:chars)

      obj = {}

      lines.each.with_index do |l, y|
        l.each.with_index do |v, x|
          obj[[x,y]] = v
        end
      end

      obj
    end
  end
end

class PartTwo < PartOne
  def solution
    low_points.map do |point, _value|
      build_basin(point, [])
    end.map(&:size).max(3).reduce(:*)
  end

  def build_basin(coord, basin)
    x, y = coord

    above = [x, y-1]
    below = [x, y+1]
    left = [x-1, y]
    right = [x+1, y]

    basin << coord

    [above, below, left, right].each do |pos|
      next if grid[pos].nil?
      next if basin.include?(pos)
      next if grid[pos].to_i == 9

      build_basin(pos, basin)
    end

    basin
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 15, PartOne.new(input).solution
    assert_equal 526, PartOne.new.solution
  end

  def test_part_two
    assert_equal 1134, PartTwo.new(input).solution
    assert_equal 1123524, PartTwo.new.solution
  end

  def input
    <<~INPUT
      2199943210
      3987894921
      9856789892
      8767896789
      9899965678
    INPUT
  end
end
