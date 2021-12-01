require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/#DAY#/input.txt'))
    @input = input
  end

  def solution
    0
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 0, PartOne.new(input).solution
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
