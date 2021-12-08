require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/08/input.txt'))
    @input = input
  end

  def solution
    easy_numbers.count {
      displays.values.include?(_1.split('').uniq.size)
    }
  end

  private

  attr_reader :input

  def easy_numbers
    input.lines.map(&:chomp).map { _1.split(' | ')[1] }.map { |v| v.split(' ') }.flatten
  end

  def displays
    @displays ||= begin
      {
        1 => 2,
        4 => 4,
        7 => 3,
        8 => 7,
      }
    end
  end
end

class PartTwo < PartOne
  def solution
    lines.sum do |segment, code|
      one = segment.find { _1.size == 2 }
      four = segment.find { _1.size == 4 }
      seven = segment.find { _1.size == 3 }
      eight = segment.find { _1.size == 7 }

      map = {
        top: [seven, eight] - one,
        middle: [four, eight],
        bottom: [eight],
        top_left: [four, eight],
        top_right: [one, four, seven, eight],
        bottom_left: [eight],
        bottom_right: [one, four, seven, eight],
      }

      binding.pry
    end
  end

  def lines
    input.lines.map(&:chomp).map { _1.split(' | ') }.map { |v| v.map { |k| k.split(' ') } }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 26, PartOne.new(input).solution
    assert_equal 288, PartOne.new.solution
  end

  def test_part_two
    assert_equal 61229, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    INPUT
  end
end
