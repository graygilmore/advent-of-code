require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/19/input.txt'))
    @input = input
  end

  def solution
    regex = build_regex(rules["0"]).tr(' ', '')
    messages.count { |message| message.match?(/\A#{regex}\z/) }
  end

  private

  attr_reader :input

  def build_regex(regex)
    return regex if !regex.match?(/\d+/)
    regex.
      gsub(/(.+\|.+)/, '(\1)').
      gsub(/\d+/) { |d| build_regex(rules[d]) }
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
    assert_equal 230, PartOne.new.solution
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
