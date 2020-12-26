require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/22/input.txt'))
    @input = input
  end

  def solution
    winning_hand(play_cards(hands))
  end

  private

  attr_reader :input

  def winning_hand(hand)
    winner = hand.reverse
    winner.sum { |n| n * (winner.index(n) + 1) }
  end

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
    winning_hand(play_game(hands)[1])
  end

  private

  def play_game(hands)
    play_cards(hands, Set[])
  end

  def play_cards(hands, rounds)
    if new_rounds = rounds.add?(hands)
      p1, p2 = hands

      p1_card = p1.shift
      p2_card = p2.shift

      if p1.count >= p1_card && p2.count >= p2_card
        sub_game = play_game([p1[0..p1_card-1], p2[0..p2_card-1]])

        if sub_game[0] == :p1
          p1 << p1_card << p2_card
        else
          p2 << p2_card << p1_card
        end
      else
        if p1_card > p2_card
          p1 << p1_card << p2_card
        else
          p2 << p2_card << p1_card
        end
      end
  
      if [p1, p2].any?(&:empty?)
        return p1.empty? ? [:p2, p2] : [:p1, p1]
      else
        play_cards([p1, p2], new_rounds)
      end      
    else
      return [:p1, hands.first]
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 306, PartOne.new(input).solution
    assert_equal 35370, PartOne.new.solution
  end

  def test_part_two
    assert_equal 291, PartTwo.new(input).solution
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
