require './base'
require 'set'

class PartOne
  def initialize(input = Base.file_input('2018/02/input.txt'))
    @input = input
  end

  def solution
    twice = 0
    thrice = 0

    input.each do |box_id|
      letter_count =
        box_id.chars.each_with_object(Hash.new(0)) { |letter,counts| counts[letter] += 1 }

      thrice += letter_count.values.include?(3) ? 1 : 0
      twice += letter_count.values.include?(2) ? 1 : 0
    end

    twice * thrice
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
  def solution
    box_id_length = input.first.size

    input.combination(2).each do |first_box, second_box|
      comparison = first_box.chars.select.each_with_index do |char, index|
        second_box.chars[index] == char
      end

      if comparison.size == input.first.size - 1
        return comparison.join('')
      end
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 12, PartOne.new(%w(abcdef bababc abbcde abcccd aabcdd abcdee ababab)).solution
    assert_equal 7105, PartOne.new().solution
  end

  def test_part_two
    assert_equal 'fgij', PartTwo.new(%w(abcde fghij klmno pqrst fguij axcye wvxyz)).solution
    assert_equal 'omlvgdokxfncvqyersasjziup', PartTwo.new().solution
  end
end
