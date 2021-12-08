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
      one = segment.find { _1.size == 2 }.split('')
      four = segment.find { _1.size == 4 }.split('')
      seven = segment.find { _1.size == 3 }.split('')
      eight = segment.find { _1.size == 7 }.split('')
      six, nine = segment.select{ _1.size == 6 }.map{ |v| v.split('') }

      top = seven - four
      top_right = (six - nine | nine - six) & one
      bottom_left = (six - nine | nine - six) - top_right
      bottom_right = seven - top - top_right
      bottom = five - top - bottom_right - four

      three = segment.select { _1.size == 5 && }

      top_left = six - nine - top_right
      middle = four - one - top_left
      bottom_right = four - top_left - middle - top_right

      five = segment.find { _1.size == 5 && !top_right.include?(_1) }.split('')
      two = segment.find { _1.size == 5 && !_1.include?(bottom_right) }

      bottom = five - top - top_left - middle - bottom_right
      bottom_left = two - top - top_right - middle - bottom

      map = {
        [top_right + bottom_right] => 1,
        [top + top_right + middle + bottom_left + bottom] => 2,
        [top + top_right + middle + bottom_right + bottom] => 3,
        [top_left + middle + top_right + bottom_right] => 4,
        [top + top_left + middle + bottom_right + bottom] => 5,
        [top + top_left + middle + bottom_right + bottom + bottom_left] => 6,
        [top + top_right + bottom_right] => 7,
        [top + top_right + top_left + middle + bottom_left + bottom_right + bottom] => 8,
        [top + top_left + top_right + middle + bottom_right + bottom] => 9,
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
