require 'pry'
require "minitest/autorun"
require 'pathname'

class Calculator
  def initialize(count = 2, expense_report = input)
    @count = count
    @expense_report = expense_report
  end

  def solution
    @expense_report.combination(@count) do |items|
      if items.sum == 2020
        return items.inject(:*)
      end
    end
  end

  private

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("expense_report.txt")).chomp.lines.map(&:chomp).map(&:to_i)
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
