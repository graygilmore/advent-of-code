require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/16/input.txt'))
    @input = input
  end

  def solution
    ticket_values.select do |value|
      rule_ranges.none? { |range| range.include?(value) }
    end.sum
  end

  private

  attr_reader :input

  def rule_ranges
    @rule_ranges ||= begin
      input.split(/\n\nyour ticket:/)[0].scan(/\d+\-\d+/).map do |rule|
        first, last = rule.split('-')
        (first.to_i..last.to_i)
      end
    end
  end

  def ticket_values
    @ticket_values ||= begin
      input.split("nearby tickets:")[1].split(/,|\n/).map(&:to_i)
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
    assert_equal 71, PartOne.new(input).solution
    assert_equal 19060, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
    INPUT
  end
end
