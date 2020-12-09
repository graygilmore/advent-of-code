require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/09/input.txt'), preamble = 25)
    @input = input
    @preamble = preamble
  end

  def solution
    invalid_number
  end

  private

  attr_reader :input, :preamble

  def numbers
    @numbers ||= input.split(/\n/).map(&:to_i)
  end

  def invalid_number
    @invalid_number ||= begin
      failed_index = (0..numbers.length-1).select do |index|
        next if index < preamble

        numbers.slice(index - preamble, index).combination(2).none? do |combo|
          combo.sum == numbers[index]
        end
      end

      numbers[failed_index[0]]
    end
  end
end

class PartTwo < PartOne
  def solution
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 127, PartOne.new(
      <<~INPUT,
        35
        20
        15
        25
        47
        40
        62
        55
        65
        95
        102
        117
        150
        182
        127
        219
        299
        277
        309
        576
      INPUT
    5).solution
    assert_equal 177777905, PartOne.new.solution
  end

  def test_part_two
  end
end
