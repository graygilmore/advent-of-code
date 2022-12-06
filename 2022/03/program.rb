require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/03/input.txt'))
    @input = input
  end

  def solution
    mismanaged_bags.sum
  end

  private

  attr_reader :input

  def mismanaged_bags
    input.lines.map(&:chomp).map do |bag|
      side1, side2 = bag.chars.each_slice(bag.size/2).to_a

      unless (bad_items = side1 & side2).any?
        return
      end

      priorities[bad_items[0]]
    end.compact
  end

  def priorities
    @priorities ||= begin
      scores = {}

      lower = ('a'..'z').to_a
      upper = ('A'..'Z').to_a

      (lower + upper).each.with_index do |letter, index|
        scores[letter] = index + 1
      end

      scores
    end
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 157, PartOne.new(input).solution
    assert_equal 7674, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
    INPUT
  end
end
