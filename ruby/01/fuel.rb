require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(masses = input)
    @masses = masses
  end

  def solution
    @masses.map do |mass|
      (mass / 3).floor - 2
    end.inject(0, :+)
  end

  private

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("modules.txt")).chomp.lines.map(&:chomp).map(&:to_i)
      end
  end
end

class PartTwo < PartOne
  def initialize(masses = input)
    @masses = masses
    @total = 0
  end

  def solution
    @masses.map do |mass|
      fuel_for_fuel(mass)
    end

    @total
  end

  private

  def fuel_for_fuel(mass)
    fuel = (mass / 3).floor - 2

    if fuel > 0
      @total += fuel
      fuel_for_fuel(fuel)
    end
  end
end

class TestFuel < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new([12]).solution
    assert_equal 2, PartOne.new([14]).solution
    assert_equal 654, PartOne.new([1969]).solution
    assert_equal 33583, PartOne.new([100756]).solution
  end

  def test_part_two
    assert_equal 2, PartTwo.new([12]).solution
    assert_equal 966, PartTwo.new([1969]).solution
    assert_equal 50346, PartTwo.new([100756]).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
