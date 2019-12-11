require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(range = [*402328..864247])
    @range = range
  end

  def solution
    @range.select { |number| valid_password?(number) }.count
  end

  def valid_password?(password)
    digits = password.digits.reverse
    return false if digits.length != 6

    increasing_values = digits.each_cons(2).to_a.all? { |a, b| a <= b }
    return false if !increasing_values

    valid_pairs?(digits)
  end

  private

  def valid_pairs?(digits)
    digits.chunk_while(&:==).map(&:length).any? { |x| x > 1 }
  end
end

class PartTwo < PartOne
  private

  def valid_pairs?(digits)
    digits.chunk_while(&:==).map(&:length).any? { |x| x == 2 }
  end
end

class TestFuel < Minitest::Test
  def test_part_one
  end

  def test_part_two
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
