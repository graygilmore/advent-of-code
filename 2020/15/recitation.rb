require './base'

class PartOne
  def initialize(input)
    @input = input
  end

  def solution
    @spoken_numbers = starting_numbers.map.with_index { |v,i| [v.to_i, [i+1]] }.to_h
    speak_number(0, starting_numbers.count+1)
  end

  private

  attr_reader :input

  def starting_numbers
    @starting_numbers ||= input.split(',')
  end

  def speak_number(number, turn)
    return number if turn == 2020

    if @spoken_numbers[number].nil?
      @spoken_numbers[number] = [turn]
      speak_number(0, turn + 1)
    elsif @spoken_numbers[number].count == 1
      @spoken_numbers[number] << turn
      speak_number(@spoken_numbers[number].inject(:-).abs, turn + 1)
    else
      turns = @spoken_numbers[number].insert(2, turn)[1..2]
      @spoken_numbers[number] = turns
      speak_number(@spoken_numbers[number].inject(:-).abs, turn + 1)
    end
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 436, PartOne.new('0,3,6').solution
    assert_equal 1, PartOne.new('1,3,2').solution
    assert_equal 10, PartOne.new('2,1,3').solution
    assert_equal 27, PartOne.new('1,2,3').solution
    assert_equal 78, PartOne.new('2,3,1').solution
    assert_equal 438, PartOne.new('3,2,1').solution
    assert_equal 1836, PartOne.new('3,1,2').solution
    assert_equal 929, PartOne.new('16,1,0,18,12,14,19').solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new('16,1,0,18,12,14,19').solution
  end

  def input
    <<~INPUT

    INPUT
  end
end
