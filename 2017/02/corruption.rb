require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/02/input.txt'))
    @input = input
  end

  def solution
    spreadsheet.map do |row|
      (row.minmax[1] - row.minmax[0])
    end.sum
  end

  private

  attr_reader :input

  def spreadsheet
    @spreadsheet ||= input.split(/\n/).map { |r| r.split.map(&:to_i) }
  end
end

class PartTwo < PartOne
  def solution
    spreadsheet.map do |row|
      row.sort.reverse.combination(2).to_a.map do |first, second|
        if (first % second == 0) && first != second
          (first / second)
        end
      end.compact
    end.flatten.sum
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 18, PartOne.new(input).solution
    assert_equal 53460, PartOne.new.solution
  end

  def test_part_two
    assert_equal 9, PartTwo.new(input2).solution
    assert_equal 282, PartTwo.new.solution
  end

  def input
    <<~INPUT
      5 1 9 5
      7 5 3
      2 4 6 8
    INPUT
  end

  def input2
    <<~INPUT
      5 9 2 8
      9 4 7 3
      3 8 6 5
    INPUT
  end
end
