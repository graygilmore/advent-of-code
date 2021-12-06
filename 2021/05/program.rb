require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/05/input.txt'))
    @input = input
    @coordinates = {}
  end

  def solution
    compute_lines(diagonal: false)
    @coordinates.count { _2 >= 2 }
  end

  private

  attr_reader :input

  def lines
    @lines ||= begin
      input.lines.map(&:chomp).
        map { _1.split(' -> ').
        map { |v| v.split(',').map(&:to_i) }}
    end
  end

  def compute_lines(diagonal:)
    lines.each do |f|
      x1, x2, y1, y2 = [f[0][0], f[1][0], f[0][1], f[1][1]]

      next if !diagonal && x1 != x2 && y1 != y2

      length = [(x1 - x2).abs, (y1 - y2).abs].max + 1
      x_s = generate_coord(x1, x2, length)
      y_s = generate_coord(y1, y2, length)

      [x_s, y_s].transpose.each do |x|
        if @coordinates.key?(x)
          @coordinates[x] += 1
        else
          @coordinates[x] = 1
        end
      end
    end
  end

  def generate_coord(a, b, length)
    if a == b
      Array.new(length, a)
    else
      a < b ? (a..b).to_a : a.downto(b).to_a
    end
  end
end

class PartTwo < PartOne
  def solution
    compute_lines(diagonal: true)
    @coordinates.count { _2 >= 2 }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 5, PartOne.new(input).solution
    assert_equal 6666, PartOne.new.solution
  end

  def test_part_two
    assert_equal 12, PartTwo.new(input).solution
    assert_equal 19081, PartTwo.new.solution
  end

  def input
    <<~INPUT
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
    INPUT
  end
end
