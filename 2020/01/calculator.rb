require './base'

class Calculator
  def initialize(count = 2, expense_report = Base.file_input('2020/01/expense_report.txt'))
    @count = count
    @expense_report = expense_report
  end

  def solution
    @expense_report.map(&:to_i).combination(@count) do |items|
      return items.inject(:*) if items.sum == 2020
    end
  end
end

class TestCalculator < Minitest::Test
  def test_part_one
    assert_equal 514579, Calculator.new(2, [1721, 979, 366, 299, 675, 1456]).solution
  end

  def test_part_two
    assert_equal 241861950, Calculator.new(3, [1721, 979, 366, 299, 675, 1456]).solution
  end
end

puts "Part One: #{::Calculator.new(2).solution}"
puts "Part Two: #{::Calculator.new(3).solution}"
