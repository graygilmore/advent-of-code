require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/10/input.txt'))
    @input = input
  end

  def solution
    one_difference = 0
    three_difference = 0

    adapters.each_cons(2) do |a,b|
      if b - a == 3
        three_difference += 1
      elsif b - a == 1
        one_difference += 1
      end
    end

    one_difference * three_difference
  end

  private

  attr_reader :input

  def adapters
    @adapters ||= begin
      all_adapters = input.split.map(&:to_i).sort
      all_adapters.prepend(0).append(all_adapters.last + 3)
    end
  end
end

class PartTwo < PartOne
  def solution
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 35, PartOne.new(input).solution
    assert_equal 220, PartOne.new(larger_input).solution
    assert_equal 1984, PartOne.new.solution
  end

  def test_part_two
    assert_equal 8, PartTwo.new(input).solution
    assert_equal 19208, PartTwo.new(larger_input).solution
  end

  def input
    <<~INPUT
      16
      10
      15
      5
      1
      11
      7
      19
      6
      12
      4
    INPUT
  end

  def larger_input
    <<~INPUT
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
    INPUT
  end
end
