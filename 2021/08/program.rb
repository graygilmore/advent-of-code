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
    lines.sum do |segments, codes|
      sorted_segments = segments.map do
        _1.chars.sort
      end

      one = sorted_segments.find { _1.size == 2 }
      four = sorted_segments.find { _1.size == 4 }
      seven = sorted_segments.find { _1.size == 3 }
      eight = sorted_segments.find { _1.size == 7 }
      nine = sorted_segments.find{ _1.size == 6 && (_1 & four).size == 4}

      bottom_left = eight - nine

      two = sorted_segments.find{ _1.size == 5 && _1.include?(bottom_left[0]) }
      three = sorted_segments.find { _1.size == 5 && _1.include?(one[0]) && _1.include?(one[1]) }
      five = (sorted_segments.select { _1.size == 5 } - [two] - [three]).flatten
      six = (five + bottom_left).sort
      zero = (sorted_segments.select { _1.size == 6 } - [six] - [nine]).flatten

      map = {
        zero.sort.join => 0,
        one.sort.join => 1,
        two.sort.join => 2,
        three.sort.join => 3,
        four.sort.join => 4,
        five.sort.join => 5,
        six.sort.join => 6,
        seven.sort.join => 7,
        eight.sort.join => 8,
        nine.sort.join => 9,
      }

      codes.map { map[_1.chars.sort.join] }.join.to_i
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
    assert_equal 5353, PartTwo.new(small_input).solution
    assert_equal 61229, PartTwo.new(input).solution
    assert_equal 940724, PartTwo.new.solution
  end

  def small_input
    "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
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
