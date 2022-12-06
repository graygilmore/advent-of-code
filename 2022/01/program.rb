require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/01/input.txt'))
    @input = input
  end

  def solution
    elves.max
  end

  private

  attr_reader :input

  def elves
    input.split("\n\n").map do |calories|
      calories.split("\n").map(&:to_i).sum
    end
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 24000, PartOne.new(input).solution
    assert_equal 69836, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    INPUT
  end
end
