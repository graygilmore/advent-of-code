require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/16/input.txt'))
    @input = input
  end

  def solution
    invalid_ticket_values.sum
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

  def invalid_ticket_values
    ticket_values.select do |value|
      rule_ranges.none? { |range| range.include?(value) }
    end
  end
end

class PartTwo < PartOne
  def solution
    @possible_ticket_meanings = (0..tickets.first.count-1).map do |i|
      [i, rules.keys]
    end.to_h

    until @possible_ticket_meanings.all? { |i, possibilities| possibilities.count == 1 } do
      tickets.each do |ticket|
        @possible_ticket_meanings.reject { |i,p| p.count == 1}.each do |index, p|
          p.reject! { |name| rules[name].none? { |r| r.include?(ticket[index]) } }

          if p.count == 1
            remove_found_meaning(p.first)
          end
        end
      end
    end

    @possible_ticket_meanings.select { |i, vs| vs.first.include?("departure") }.keys.map do |f|
      my_ticket[f]
    end.inject(:*)
  end

  private

  def remove_found_meaning(name)
    @possible_ticket_meanings.each do |index, possibilities|
      next if possibilities.count == 1 && possibilities.first == name

      if possibilities.count > 1
        possibilities.delete(name)

        if possibilities.count == 1
          remove_found_meaning(possibilities.first)
        end
      end
    end
  end

  def my_ticket
    @my_ticket ||= input.match(/your ticket:\n(\S+)/)[1].split(',').map(&:to_i)
  end

  def rules
    @rules ||= begin
      input.split(/\n\nyour ticket:/)[0].split(/\n/).map do |rule|
        name, values = rule.split(': ')

        [
          name,
          values.scan(/\d+\-\d+/).map do |value|
            first, last = value.split('-')
            (first.to_i..last.to_i)
          end
        ]
      end.to_h
    end
  end

  def tickets
    @tickets ||= begin
      input.split("nearby tickets:")[1].split.map do |ticket|
        ticket.split(',').map(&:to_i)
      end.reject do |ticket|
        ticket.any? { |ticket_value| invalid_ticket_values.include?(ticket_value) }
      end
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 71, PartOne.new(input).solution
    assert_equal 19060, PartOne.new.solution
  end

  def test_part_two
    assert_equal 953713095011, PartTwo.new.solution
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
