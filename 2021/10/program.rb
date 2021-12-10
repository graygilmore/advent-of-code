require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/10/input.txt'))
    @input = input
  end

  def solution
    lines.map do |line|
      find_broken_line(line, 0)[0]
    end.compact.sum
  end

  private

  attr_reader :input

  def find_broken_line(line, index)
    if closing.include?(line[index]) && line[index-1] == matching_opening[line[index]]
      chars = line.chars
      chars.delete_at(index - 1)
      chars.delete_at(index - 1)
      line = chars.join()
      find_broken_line(line, index - 1)
    elsif closing.include?(line[index]) && line[index-1] != matching_opening[line[index]]
      return [scores[line[index]], line]
    elsif line.size == index
      return [nil, line]
    else
      find_broken_line(line, index + 1)
    end
  end

  def lines
    @lines ||= input.lines.map(&:chomp)
  end

  def matching_opening
    {
      ")" => "(",
      "]" => "[",
      "}" => "{",
      ">" => "<",
    }
  end

  def closing
    [")", "]", "}", ">"]
  end

  def opening
    ["(", "[", "{", "<"]
  end

  def scores
    {
      ")" => 3,
      "]" => 57,
      "}" => 1197,
      ">" => 25137,
    }
  end
end

class PartTwo < PartOne
  def solution
    incomplete_lines = lines.map do
      k, v = find_broken_line(_1, 0)
      if k.nil?
        v
      end
    end.compact

    scored_lines = incomplete_lines.map do |line|
      line.chars.reverse.reduce(0) do |cur, char|
        cur * 5 + scores[matching_closing[char]]
      end
    end

    scored_lines.sort[scored_lines.size / 2]
  end

  private

  def scores
    {
      ")" => 1,
      "]" => 2,
      "}" => 3,
      ">" => 4,
    }
  end

  def matching_closing
    {
      "(" => ")",
      "[" => "]",
      "{" => "}",
      "<" => ">",
    }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 26397, PartOne.new(input).solution
    assert_equal 392139, PartOne.new.solution
  end

  def test_part_two
    assert_equal 288957, PartTwo.new(input).solution
    assert_equal 4001832844, PartTwo.new.solution
  end

  def input
    <<~INPUT
      [({(<(())[]>[[{[]{<()<>>
      [(()[<>])]({[<{<<[]>>(
      {([(<{}[<>[]}>{[]{[(<()>
      (((({<>}<{<{<>}{[]{[]{}
      [[<[([]))<([[{}[[()]]]
      [{[{({}]{}}([{[{{{}}([]
      {<[[]]>}<{[{[{[]{()[[[]
      [<(<(<(<{}))><([]([]()
      <{([([[(<>()){}]>(<<{{
      <{([{{}}[<[[[<>{}]]]>[]]
    INPUT
  end
end
