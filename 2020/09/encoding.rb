require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/09/input.txt'), preamble = 25)
    @input = input
    @preamble = preamble
  end

  def solution
    numbers.each.with_index do |number, index|
      next if index < preamble

      success = numbers.slice(index - preamble, index).combination(2).any? do |combo|
        combo.sum == number
      end

      return number if !success
    end
  end

  private

  attr_reader :input, :preamble

  def numbers
    @numbers ||= input.split(/\n/).map(&:to_i)
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
