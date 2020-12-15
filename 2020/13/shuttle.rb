
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
  # Thank you Jared for this one!
  def solution
    buses_seen = []
    step = 1
    index = 0
    busses.each do |next_bus|
      buses_seen << next_bus
      until buses_seen.all? { |bus, offset| (index + offset) % bus == 0 }
        index += step
      end
      step = step * next_bus[0]
    end
    index
  end

  private

  def busses
    @busses ||= input.split[1].split(',').map(&:to_i).each_with_index.reject { |x,i| x.zero? }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 295, PartOne.new(input).solution
    assert_equal 3966, PartOne.new.solution
  end

  def test_part_two
    assert_equal 1068781, PartTwo.new(input).solution
    assert_equal 3417, PartTwo.new(
      <<~INPUT
        939
        17,x,13,19
      INPUT
    ).solution
    assert_equal 754018, PartTwo.new(
      <<~INPUT
        939
        67,7,59,61
      INPUT
    ).solution
    assert_equal 779210, PartTwo.new(
      <<~INPUT
        939
        67,x,7,59,61
      INPUT
    ).solution
    assert_equal 1261476, PartTwo.new(
      <<~INPUT
        939
        67,7,x,59,61
      INPUT
    ).solution
    assert_equal 1202161486, PartTwo.new(
      <<~INPUT
        939
        1789,37,47,1889
      INPUT
    ).solution
    assert_equal 800177252346225, PartTwo.new.solution
  end

  def input
    <<~INPUT
      939
      7,13,x,x,59,x,31,19
    INPUT
  end
end
