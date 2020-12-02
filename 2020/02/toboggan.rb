require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(password_list = input)
    @password_list = password_list
  end

  def solution
    @password_list.select do |password_item|
      rules, password = password_item.split(': ')
      limit_range, required_letter = rules.split(' ')
      limit_min, limit_max = limit_range.split('-').map(&:to_i)

      password.count(required_letter) >= limit_min && password.count(required_letter) <= limit_max
    end.count
  end

  private

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("password_list.txt")).chomp.lines.map(&:chomp)
      end
  end
end

class PartTwo < PartOne
  def solution
    @password_list.select do |password_item|
      rules, password = password_item.split(': ')
      limit_range, required_letter = rules.split(' ')
      first_index, second_index = limit_range.split('-').map(&:to_i)

      characters = password.split('')
      first_index_matches = characters[first_index - 1] == required_letter
      second_index_matches = characters[second_index - 1] == required_letter

      (first_index_matches && !second_index_matches) || (!first_index_matches && second_index_matches)
    end.count
  end
end

class TestToboggan < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new(['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']).solution
  end

  def test_part_two
    assert_equal 1, PartTwo.new(['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
