require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(expense_report = input)
    @expense_report = expense_report
  end

  def solution
    @expense_report.permutation(2) do |x,y|
      if x + y == 2020
        return x * y
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

class PartTwo < PartOne
  def solution
    @expense_report.permutation(3) do |x,y,z|
      if x + y + z == 2020
        return x * y * z
      end
    end
  end
end

class TestFuel < Minitest::Test
  def test_part_one
    assert_equal 514579, PartOne.new([1721, 979, 366, 299, 675, 1456]).solution
  end

  def test_part_two
    assert_equal 241861950, PartTwo.new([1721, 979, 366, 299, 675, 1456]).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
