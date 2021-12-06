require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/05/input.txt'))
    @input = input
    @coordinates = {}
  end

  def solution
    compute_straight_lines
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

  def straight_lines
    @straight_lines ||= lines.select { |l| l[0][0] == l[1][0] || l[0][1] == l[1][1] }
  end

  def compute_straight_lines
    straight_lines.each do |f|
      x1, x2, y1, y2 = [f[0][0], f[1][0], f[0][1], f[1][1]]

      if x1 == x2
        start, finish = [y1, y2].sort
        (start..finish).each do |i|
          if @coordinates.key?([x1, i])
            @coordinates[[x1, i]] += 1
          else
            @coordinates[[x1, i]] = 1
          end
        end
      else
        start, finish = [x1, x2].sort
        (start..finish).each do |i|
          if @coordinates.key?([i, y1])
            @coordinates[[i, y1]] += 1
          else
            @coordinates[[i, y1]] = 1
          end
        end
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    compute_straight_lines
    compute_horizontal_lines
    @coordinates.count { _2 >= 2 }
  end

  private

  def horizontal_lines
    @horizontal_lines ||= lines - straight_lines
  end

  def compute_horizontal_lines
    horizontal_lines.each do |f|
      x1, x2, y1, y2 = [f[0][0], f[1][0], f[0][1], f[1][1]]

      x_start, x_finish = [x1, x2]
      y_start, y_finish = [y1, y2]

      x_s = x_start < x_finish ? (x_start..x_finish).to_a : x_start.downto(x_finish).to_a
      y_s = y_start < y_finish ? (y_start..y_finish).to_a : y_start.downto(y_finish).to_a

      [x_s, y_s].transpose.each do |x|
        if @coordinates.key?(x)
          @coordinates[x] += 1
        else
          @coordinates[x] = 1
        end
      end
    end
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
