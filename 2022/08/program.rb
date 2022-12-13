require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/08/input.txt'))
    @input = input
  end

  def solution
    edges_visible = (trees.size * 2) + ((trees.size - 2) * 2)
    visible_trees + edges_visible
  end

  private

  attr_reader :input

  def trees
    @trees ||= input.lines.map(&:chomp).map(&:chars)
  end

  def visible_trees
    (1..(trees.size-2)).sum do |y|
      (1..(trees.size - 2)).count do |x|
        north?(x, y) || south?(x, y) || east?(x, y) || west?(x, y)
      end
    end
  end

  def north?(x, y)
    (0..y-1).all? { |ny| trees[ny][x] < trees[y][x] }
  end

  def south?(x, y)
    (y+1..trees.size-1).all? { |ny| trees[ny][x] < trees[y][x] }
  end

  def east?(x, y)
    (x+1..trees.size-1).all? { |nx| trees[y][nx] < trees[y][x] }
  end

  def west?(x, y)
    (0..x-1).all? { |nx| trees[y][nx] < trees[y][x] }
  end
end

class PartTwo < PartOne
  def solution
    scenic_scores.max
  end

  private

  def scenic_scores
    (1..(trees.size-2)).map do |y|
      (1..(trees.size - 2)).map do |x|
        tree_score(x, y)
      end
    end.flatten
  end

  def tree_score(x, y)
    up(x, y) * left(x, y) * down(x, y) * right(x, y)
  end

  def up(x, y)
    view((0..y-1).to_a.reverse.map { |ny| trees[ny][x] }, trees[y][x])
  end

  def down(x, y)
    view((y+1..trees.size-1).to_a.map { |ny| trees[ny][x] }, trees[y][x])
  end

  def right(x, y)
    view((x+1..trees.size-1).to_a.map { |nx| trees[y][nx] }, trees[y][x])
  end

  def left(x, y)
    view((0..x-1).to_a.reverse.map { |nx| trees[y][nx] }, trees[y][x])
  end

  def view(ts, consideration)
    count = 0

    if ts.size == 1
      return 1
    end

    ts.each do |t|
      if t == consideration
        count += 1
        break
      elsif t < consideration
        count += 1
      else
        count += 1
        break
      end
    end

    count
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 21, PartOne.new(input).solution
    assert_equal 1829, PartOne.new.solution
  end

  def test_part_two
    assert_equal 8, PartTwo.new(input).solution
    assert_equal 291840, PartTwo.new.solution
  end

  def input
    <<~INPUT
      30373
      25512
      65332
      33549
      35390
    INPUT
  end
end
