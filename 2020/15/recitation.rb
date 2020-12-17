require './base'

class PartOne
  def initialize(input, target = 2020)
    @input = input
    @target = target
  end

  def solution
    @spoken_numbers = starting_numbers.map.with_index { |v,i| [v.to_i, [i+1]] }.to_h
    @last_spoken = 0

    (starting_numbers.count+1..target-1).each do |turn|
      if @spoken_numbers[@last_spoken].nil?
        @spoken_numbers[@last_spoken] = [turn]
        @last_spoken = 0
      elsif @spoken_numbers[@last_spoken].count == 1
        @spoken_numbers[@last_spoken] << turn
        @spoken_numbers[@last_spoken].inject(:-).abs
        @last_spoken = @spoken_numbers[@last_spoken].inject(:-).abs
      else
        turns = @spoken_numbers[@last_spoken].insert(2, turn)[1..2]
        @spoken_numbers[@last_spoken] = turns
        @last_spoken = @spoken_numbers[@last_spoken].inject(:-).abs
      end
    end

    @last_spoken
  end

  private

  attr_reader :input, :target

  def starting_numbers
    @starting_numbers ||= input.split(',')
  end
end

class PartTwo < PartOne
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
    assert_equal 175594, PartTwo.new('0,3,6', 30000000).solution
    assert_equal 16671510, PartTwo.new('16,1,0,18,12,14,19', 30000000).solution
  end
end
