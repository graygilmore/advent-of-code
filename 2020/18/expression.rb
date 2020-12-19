require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/18/input.txt'))
    @input = input
  end

  def solution
    expressions.sum { |expression| calculate(expression) }
  end

  private

  attr_reader :input

  def expressions
    @expressions ||= input.split(/\n/).map { |e| e.tr(' ', '') }
  end

  def calculate(expression)
    foo = expression.chars
    start = foo.shift
    foo.each_slice(2).inject(start.to_i) { |acc, n| n[0] == '+' ? acc + n[1].to_i : acc * n[1].to_i }
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 71, PartOne.new('1 + 2 * 3 + 4 * 5 + 6').solution
    assert_equal 51, PartOne.new('1 + (2 * 3) + (4 * (5 + 6))').solution
    assert_equal 26, PartOne.new('2 * 3 + (4 * 5)').solution
    assert_equal 437, PartOne.new('5 + (8 * 3 + 9 + 3 * 4 * 3)').solution
    assert_equal 12240, PartOne.new('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))').solution
    assert_equal 13632, PartOne.new('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2').solution
    assert_equal 0, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
    INPUT
  end
end
