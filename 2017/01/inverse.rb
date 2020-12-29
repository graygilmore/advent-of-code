require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/01/input.txt'))
    @input = input
  end

  def solution
    extended_numbers = numbers << numbers.first
    @organized_numbers = extended_numbers.each_cons(2).to_a
    sum
  end

  private

  attr_reader :input

  def numbers
    @numbers ||= input.chars.map(&:to_i)
  end

  def sum
    @organized_numbers.map do |matching_pair|
      matching_pair.uniq.first if matching_pair.uniq.size == 1
    end.compact.flatten.sum
  end
end

class PartTwo < PartOne
  def solution
    rotated_numbers = numbers.rotate(numbers.size / 2)
    @organized_numbers = zipped_numbers = numbers.zip(rotated_numbers)
    sum
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 3, PartOne.new('1122').solution
    assert_equal 4, PartOne.new('1111').solution
    assert_equal 0, PartOne.new('1234').solution
    assert_equal 9, PartOne.new('91212129').solution
    assert_equal 1044, PartOne.new.solution
  end

  def test_part_two
    assert_equal 6, PartTwo.new('1212').solution
    assert_equal 0, PartTwo.new('1221').solution
    assert_equal 4, PartTwo.new('123425').solution
    assert_equal 12, PartTwo.new('123123').solution
    assert_equal 4, PartTwo.new('12131415').solution
    assert_equal 1054, PartTwo.new.solution
  end
end
