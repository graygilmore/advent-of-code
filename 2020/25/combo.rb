require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/25/input.txt'))
    @input = input
  end

  def solution
    @door_key, @card_key = input.split(/\n/).map(&:to_i)
    encryption_key(@door_key, card_loop)
  end

  private

  attr_reader :input

  def encryption_key(subject, loop_size)
    value = 1
    loop_size.times do
      value = (value * subject) % 20201227
    end
    value
  end

  def card_loop
    loops = 1
    value = 1
    loop do 
      value = (value * 7) % 20201227
      break if value == @card_key
      loops += 1
    end
    loops
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 14897079, PartOne.new(input).solution
    assert_equal 19774660, PartOne.new.solution
  end

  def input
    <<~INPUT
      5764801
      17807724
    INPUT
  end
end
