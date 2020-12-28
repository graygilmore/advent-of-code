require './base'

class PartOne
  def initialize(input, moves = 100)
    @input = input
    @moves = moves
  end

  def solution
    cups = play_cups(input.chars.map(&:to_i))    
    cups.rotate!(cups.find_index(1))
    cups.shift
    cups.join
  end

  private

  attr_reader :input, :moves

  def play_cups(cups)
    moves.times do
      current = cups[0]
      held_cups = cups.slice!(1, 3)
      cups.insert(find_destination_index(cups, current - 1), held_cups).flatten!
      cups.rotate!
    end
    cups
  end

  def find_destination_index(cups, target)
    if cups.index(target)
      cups.index(target) + 1
    else
      new_target = target - 1 > 0 ? target - 1 : cups.max
      find_destination_index(cups, new_target)
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
    assert_equal '92658374', PartOne.new(input, 10).solution
    assert_equal '67384529', PartOne.new(input).solution
    assert_equal '82934675', PartOne.new('327465189').solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new('327465189').solution
  end

  def input
    '389125467'
  end
end
