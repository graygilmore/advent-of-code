require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/22/input.txt'))
    @input = input
  end

  def solution
    winning_hand = play_cards(hands).reverse
    winning_hand.sum { |n| n * (winning_hand.index(n) + 1) }
  end

  private

  attr_reader :input

  def play_cards(hands)
    p1, p2 = hands

    p1_card = p1.shift
    p2_card = p2.shift

    if p1_card > p2_card
      p1 << p1_card << p2_card
    else
      p2 << p2_card << p1_card
    end

    if [p1, p2].any?(&:empty?)
      return [p1, p2].reject(&:empty?).flatten
    else
      play_cards([p1, p2])
    end
  end

  def hands
    @hands ||= begin
      _, p1, p2 = input.split(/Player [12]\:/)

      [
        p1.split.map(&:to_i),
        p2.split.map(&:to_i)
      ]
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
    assert_equal 306, PartOne.new(input).solution
    assert_equal 35370, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
    INPUT
  end
end
