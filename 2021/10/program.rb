require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/10/input.txt'))
    @input = input
  end

  def solution
    lines.map do |line|
      begin
        build_stack(line)
        nil
      rescue => e
        scores[e.message]
      end
    end.compact.sum
  end

  private

  attr_reader :input

  def build_stack(line)
    stack = []

    line.chars.each do |char|
      if pairs.key?(char)
        closed = stack.pop

        unless pairs[char] == closed
          raise char
        end
      else
        stack.push(char)
      end
    end

    stack
  end

  def lines
    @lines ||= input.lines.map(&:chomp)
  end

  def pairs
    @pairs ||= {
      ")" => "(",
      "]" => "[",
      "}" => "{",
      ">" => "<",
    }
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
    incomplete_lines = lines.map do |line|
      begin
        build_stack(line)
      rescue => e
        nil
      end
    end.compact

    scored_lines = incomplete_lines.map do |line|
      line.reverse.reduce(0) do |current, char|
        current * 5 + scores[pairs.key(char)]
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
