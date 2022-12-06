require './base'

class PartOne
  GAMES = {
    "A": { # rock
      "X": 1 + 3,
      "Y": 2 + 6,
      "Z": 3,
    },
    "B": { # paper
      "X": 1,
      "Y": 2 + 3,
      "Z": 3 + 6,
    },
    "C": { # scissors
      "X": 1 + 6,
      "Y": 2,
      "Z": 3 + 3,
    },
  }

  def initialize(input = Base.raw_input('2022/02/input.txt'))
    @input = input
  end

  def solution
    rounds.sum
  end

  private

  attr_reader :input

  def rounds
    input.split("\n").map do |round|
      opponent, me = round.split(" ")

      GAMES[opponent.to_sym][me.to_sym]
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
    assert_equal 15, PartOne.new(input).solution
    assert_equal 12586, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      A Y
      B X
      C Z
    INPUT
  end
end
