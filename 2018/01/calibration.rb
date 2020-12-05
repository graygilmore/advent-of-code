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
  def solution
    frequencies = [0]
    duplicate_frequency = nil

    values = input.map(&:to_i)

    while !duplicate_frequency do
      values.each do |value|
        new_frequency = frequencies.last + value

        if frequencies.include?(new_frequency)
          return new_frequency
        else
          frequencies << new_frequency
        end
      end
    end
  end
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
    assert_equal 2, PartTwo.new(['+1', '-2', '+3', '+1']).solution
    assert_equal 0, PartTwo.new(%w(+1, -1)).solution
    assert_equal 10, PartTwo.new(%w(+3, +3, +4, -2, -4)).solution
    assert_equal 5, PartTwo.new(%w(-6, +3, +8, +5, -6)).solution
    assert_equal 14, PartTwo.new(%w(+7, +7, -2, -7, -4)).solution
    assert_equal 73272, PartTwo.new().solution
  end
end
