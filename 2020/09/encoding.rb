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
    bar = (0..numbers_to_search.length).to_a.combination(2).map{|i,j| numbers_to_search[i...j]}.select do |foo|
      foo.sum == invalid_number
    end.flatten

    bar.min + bar.max
  end

  private

  def numbers_to_search
    @numbers_to_search ||= begin
      numbers.slice(0, numbers.find_index(invalid_number))
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 127, PartOne.new(test_input, 5).solution
    assert_equal 177777905, PartOne.new.solution
  end

  def test_part_two
    assert_equal 62, PartTwo.new(test_input, 5).solution
    assert_equal 23463012, PartTwo.new.solution
  end

  def test_input
    <<~INPUT
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
  end
end
