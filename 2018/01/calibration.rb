require './base'

class PartOne
  def initialize(input = Base.file_input('2018/01/input.txt'))
    @input = input
  end

  def solution
    input.map(&:to_i).sum
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 3, PartOne.new(['+1', '-2', '+3', '+1']).solution
    assert_equal 3, PartOne.new(%w(+1 +1 +1)).solution
    assert_equal 0, PartOne.new(%w(+1, +1, -2)).solution
    assert_equal -6, PartOne.new(%w(-1, -2, -3)).solution
    assert_equal 533, PartOne.new().solution
  end

  def test_part_two
  end
end
