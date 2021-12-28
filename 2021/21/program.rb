require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/21/input.txt'))
    @input = input
    @players = starting_positions
    @die = (1..100).to_a
    @rolls = 0
    @turn = "Player 1"
  end

  def solution
    while !scores_met? do
      roll = @die[0..2]

      player = @players[@turn]
      player[:position] = player[:position].rotate!(roll.sum)
      player[:score] += player[:position][0]

      @rolls += 3
      @die.rotate!(3)
      @turn = @turn == "Player 1" ? "Player 2" : "Player 1"
    end

    losing_score = @players.map { _1[1][:score] }.min
    @rolls * losing_score
  end

  private

  attr_reader :input

  def scores_met?
    @players.any? do |player|
      player[1][:score] >= 1000
    end
  end

  def starting_positions
    input.lines.map(&:chomp).map do |line|
      name, position = line.split(" starting position: ")
      positions = (1..10).to_a
      [name, { position: positions.rotate(position.to_i - 1), score: 0 }]
    end.to_h
  end
end

class PartTwo < PartOne
  def initialize(input = Base.raw_input('2021/21/input.txt'))
    @input = input
    @states = { starting_state => 1 }
    @p1_wins = 0
    @p2_wins = 0
  end

  def solution
    @state_count = 0
    while @states.size > 0 do
      play
    end
    @p1_wins
  end

  private

  def play
    last_states = @states.dup
    @states = Hash.new(0)
    last_states.each do |state, state_count|
      {3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1}.each do |roll|
        movement, roll_count = roll

        new_state = if state[:turn] == :p1
          new_pos = state[:p1_pos].rotate(movement)
          new_score = state[:p1_score] + new_pos[0]

          new_state = {
            p1_score: new_score,
            p1_pos: new_pos,
            p2_score: state[:p2_score],
            p2_pos: state[:p2_pos],
            turn: :p2,
          }
        else
          new_pos = state[:p2_pos].rotate(movement)
          new_score = state[:p2_score] + new_pos[0]

          new_state = {
            p1_score: state[:p1_score],
            p1_pos: state[:p1_pos],
            p2_score: new_score,
            p2_pos: new_pos,
            turn: :p1,
          }
        end

        new_universes = state_count * roll_count

        if new_score >= 21
          if state[:turn] == :p1
            @p1_wins += new_universes
          else
            @p2_wins += new_universes
          end
        else
          @states[new_state] += new_universes
        end
      end
    end
  end

  def starting_state
    obj = {}
    input.lines.map(&:chomp).map.with_index do |line, i|
      name, position = line.split(" starting position: ")
      positions = (1..10).to_a

      if i == 0
        obj[:p1_pos] = positions.rotate(position.to_i - 1)
        obj[:p1_score] = 0
        obj[:turn] = :p1
      else
        obj[:p2_pos] = positions.rotate(position.to_i - 1)
        obj[:p2_score] = 0
      end
    end
    obj
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 739785, PartOne.new(input).solution
    assert_equal 604998, PartOne.new.solution
  end

  def test_part_two
    assert_equal 444356092776315, PartTwo.new(input).solution
    assert_equal 157253621231420, PartTwo.new.solution
  end

  def input
    <<~INPUT
      Player 1 starting position: 4
      Player 2 starting position: 8
    INPUT
  end
end
