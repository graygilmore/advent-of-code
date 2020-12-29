require './base'

class PartOne
  def initialize(input, moves = 100)
    @input = input
    @moves = moves
  end

  def solution
    setup_cups
    play_cups

    value = @cups[1]
    answer = [value]
    loop {
      value = @cups[value]
      break if value == 1
      answer << value
    }

    answer.join
  end

  private

  attr_reader :input, :moves

  def setup_cups
    @cups = {}
    input_cups = input.chars.map(&:to_i)
    @current = input_cups.first
    @min = input_cups.min
    @max = input_cups.max
    input_cups.each_with_index { |v, i|
      @cups[v] = input_cups[i+1] ? input_cups[i+1] : input_cups.first
    }
  end

  def play_cups
    moves.times do
      # find next three cups
      next1 = @cups[@current]
      next2 = @cups[next1]
      next3 = @cups[next2]

      # update current pointer to fourth cup
      @cups[@current] = @cups[next3]

      # find destination
      destination = @current
      loop do
        destination = destination - 1
        if destination < @min
          destination = @max
        end

        break unless [next1, next2, next3].include?(destination)
      end

      # place cups (update destination pointer and last held cup pointer)
      old_pointer = @cups[destination]
      @cups[destination] = next1
      @cups[next3] = old_pointer

      # select new current cup
      @current = @cups[@current]
    end
  end
end

class PartTwo < PartOne
  def solution
    setup_cups
    play_cups

    value1 = @cups[1]
    value2 = @cups[value1]

    value1 * value2
  end

  private

  def setup_cups
    @cups = {}
    input_cups = input.chars.map(&:to_i)
    @current = input_cups.first

    input_cups << (input_cups.max+1..1000000).to_a

    input_cups.flatten!

    @min = input_cups.min
    @max = input_cups.max

    input_cups.each_with_index { |v, i|
      @cups[v] = input_cups[i+1] ? input_cups[i+1] : input_cups.first
    }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal '92658374', PartOne.new(input, 10).solution
    assert_equal '67384529', PartOne.new(input).solution
    assert_equal '82934675', PartOne.new('327465189').solution
  end

  def test_part_two
    assert_equal 149245887792, PartTwo.new(input, 10000000).solution
    assert_equal 474600314018, PartTwo.new('327465189', 10000000).solution
  end

  def input
    '389125467'
  end
end
