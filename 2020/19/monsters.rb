require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/19/input.txt'))
    @input = input
  end

  def solution
    binding.pry
    regex = build_regex(find_rule(0).flatten(1))
    messages.count { |message| message.match?(/\A#{regex}\z/) }
  end

  private

  attr_reader :input

  def build_regex(regex)
    # binding.pry
    if regex.include?('|')
      regex.gsub(/(\d+|\s+)/) { |d| "(#{build_regex(d)})" }
    elsif ['a', 'b'].include?(regex)
      regex
    else
      regex.split(' ').map do |r|
        build_regex(rules[r])
      end
    end
  end

  def find_rule(rule)
    if rule.is_a?(Array)
      rule.map { |n| find_rule(n) }
    else
      rules[rule].is_a?(Array) ? rules[rule].map { |n| find_rule(n) } : rules[rule]
    end
  end

  def rules
    @rules ||= begin
      input.split(/\n\n/)[0].split(/\n/).map do |rule|
        number, matches = rule.split(/^(\d+)\: /).reject(&:empty?)

        [
          number,
          matches.tr('"', '').gsub(/ \| /, '|')
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
