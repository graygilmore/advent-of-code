
require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/13/input.txt'))
    @input = input
  end

  def solution
    initial_time, busses = input.split
    time = initial_time.to_i
    busses = busses.split(',').reject { |b| b == 'x' }.map(&:to_i)

    loop do
      bus = busses.detect { |b| time % b == 0 }
      if bus
        return bus * (time - initial_time.to_i)
      else
        time += 1
      end
    end
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
  def solution
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 295, PartOne.new(input).solution
    assert_equal 3966, PartOne.new.solution
  end

  def test_part_two
  end

  def input
    <<~INPUT
      939
      7,13,x,x,59,x,31,19
    INPUT
  end
end
