require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/17/input.txt'))
    @input = input
  end

  def solution
    find_highest.values.max
  end

  private

  attr_reader :input

  def find_highest
    attempts = {}
    minimumx_x_velo = find_minimumx_x_velo
    maximum_x_velo = x_minmax[1]

    (minimumx_x_velo..maximum_x_velo).each do |x_velo|
      (y_minmax[0]..y_minmax[0].abs).each do |y_velo|
        if peak = hits_target?(x_velo, y_velo)
          attempts[[x_velo, y_velo]] = peak
        end
      end
    end

    attempts
  end

  def find_minimumx_x_velo
    x = 0
    while true
      return x if (0..x).sum >= x_minmax[0]
      x += 1
    end
  end

  def hits_target?(xv, yv)
    x, y = [0, 0]
    highest_point = 0
    while true
      x += xv
      y += yv

      return false if y < y_minmax[0]
      return false if x > x_minmax[1]

      highest_point = [y, highest_point].max
      return highest_point if targets.include?([x, y])

      xv = xv == 0 ? 0 : (xv.positive? ? xv - 1 : xv + 1)
      yv -= 1
    end
  end

  def x_minmax
    @x_minmax = targets.transpose[0].minmax
  end

  def y_minmax
    @y_minmax = targets.transpose[1].minmax
  end

  def targets
    @targets ||= begin
      x_range, y_range = input.split('target area: ')[1].split(', ').map(&:chomp)
      x_s = x_range.split('x=')[1].split('..').map(&:to_i)
      y_s = y_range.split('y=')[1].split('..').map(&:to_i)

      (y_s[0]..y_s[1]).map do |y|
        (x_s[0]..x_s[1]).map do |x|
          [x, y]
        end
      end.flatten(1)
    end
  end
end

class PartTwo < PartOne
  def solution
    find_highest.size
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 45, PartOne.new(input).solution
    assert_equal 9180, PartOne.new.solution
  end

  def test_part_two
    assert_equal 112, PartTwo.new(input).solution
    assert_equal 3767, PartTwo.new.solution
  end

  def input
    <<~INPUT
      target area: x=20..30, y=-10..-5
    INPUT
  end
end
