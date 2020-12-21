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
    rules["8"] = "(42)+"
    rules["11"] = "(42 31|(?<re>(42)\\g<re>?(31))+)"

    regex = build_regex(rules["0"]).tr(' ', '')
    messages.count { |message| message.match?(/\A#{regex}\z/) }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new(input).solution
    assert_equal 230, PartOne.new.solution
  end

  def test_part_two
    assert_equal 3, PartOne.new(input_two).solution
    assert_equal 12, PartTwo.new(input_two).solution
    assert_equal 341, PartTwo.new.solution
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

  def input_two
    <<~INPUT
      42: 9 14 | 10 1
      9: 14 27 | 1 26
      10: 23 14 | 28 1
      1: "a"
      11: 42 31
      5: 1 14 | 15 1
      19: 14 1 | 14 14
      12: 24 14 | 19 1
      16: 15 1 | 14 14
      31: 14 17 | 1 13
      6: 14 14 | 1 14
      2: 1 24 | 14 4
      0: 8 11
      13: 14 3 | 1 12
      15: 1 | 14
      17: 14 2 | 1 7
      23: 25 1 | 22 14
      28: 16 1
      4: 1 1
      20: 14 14 | 1 15
      3: 5 14 | 16 1
      27: 1 6 | 14 18
      14: "b"
      21: 14 1 | 1 14
      25: 1 1 | 1 14
      22: 14 14
      8: 42
      26: 14 22 | 1 20
      18: 15 15
      7: 14 5 | 1 21
      24: 14 1

      abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
      bbabbbbaabaabba
      babbbbaabbbbbabbbbbbaabaaabaaa
      aaabbbbbbaaaabaababaabababbabaaabbababababaaa
      bbbbbbbaaaabbbbaaabbabaaa
      bbbababbbbaaaaaaaabbababaaababaabab
      ababaaaaaabaaab
      ababaaaaabbbaba
      baabbaaaabbaaaababbaababb
      abbbbabbbbaaaababbbbbbaaaababb
      aaaaabbaabaaaaababaa
      aaaabbaaaabbaaa
      aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
      babaaabbbaaabaababbaabababaaab
      aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    INPUT
  end
end
