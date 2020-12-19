require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/19/input.txt'))
    @input = input
  end

  def solution
    messages.count { |message| valid_messages.include?(message) }
  end

  private

  attr_reader :input

  def valid_messages
    flatten_rule(rules[0].first.map { |n| rules[n] })
  end

  def flatten_rule(rule)
    rulez = rule.map do |f_rule|
      if f_rule.is_a?(String)
        f_rule
      elsif f_rule.is_a?(Integer)
        rules[f_rule]
      else
        f_rule.map { |o| flatten_rule(o) }
      end
    end

    if rulez.flatten.any? { |i| i.is_a?(Integer) }
      flatten_rule(rulez)
    else
      rulez
    end
  end

  def rules
    @rules ||= begin
      input.split(/\n\n/)[0].split(/\n/).map do |rule|
        number, matches = rule.split(/^(\d+)\: /).reject(&:empty?)

        [
          number.to_i,
          if ['"a"', '"b"'].include?(matches.to_s)
            matches.tr!('"', '')
          else
            matches.split(' | ').map { |n| n.split.map(&:to_i) }
          end
        ]
      end.to_h
    end
  end

  def messages
    @messages ||= input.split(/\n\n/)[1].split
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new(input).solution
    assert_equal 0, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      0: 4 1 5
      1: 2 3 | 3 2
      2: 4 4 | 5 5
      3: 4 5 | 5 4
      4: "a"
      5: "b"

      ababbb
      bababa
      abbbab
      aaabbb
      aaaabbb
    INPUT
  end
end
