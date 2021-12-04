require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/04/input.txt'))
    @input = input
    @board_length = 0
  end

  def solution
    numbers.each do |n|
      flip_numbers(n)
      if foo = any_boards?(n)
        return foo
        break
      end
    end
  end

  private

  attr_reader :input

  def flip_numbers(n)
    boards.each.with_index do |board, index|
      if board.key?(n)
        board[n] = { checked: true, coord: board[n][:coord] }
      end
    end
  end

  def any_boards?(n)
    valid_board = boards.find do |board|
      checked_numbers = board.select { _2[:checked] }

      if checked_numbers.map { _2[:coord] }.transpose.map(&:tally).any? { |v| v.values.any? { _1 == @board_length } }
        return board.select { !_2[:checked] }.keys.sum * n
      else
        false
      end
    end
  end

  def numbers
    @numbers ||= input.lines.first.chomp.split(",").map(&:to_i)
  end

  def boards
    @boards ||= begin
      input.split("\n\n").drop(1).map(&:chomp).map { _1.lines.map(&:chomp) }.map do
        format_board(_1)
      end
    end
  end

  def format_board(board)
    board.reduce({}) do |b, n|
      rows = board.map { _1.split(' ') }

      rows.map.with_index do |row, y|
        row.map.with_index do |value, x|
          @board_length = [x + 1, y + 1, @board_length].max
          b[value.to_i] = { checked: false, coord: [x,y] }
        end
      end

      b
    end
  end
end

class PartTwo < PartOne
  def solution
    @total_boards = boards.size
    @winning_boards = []

    numbers.each do |n|
      flip_numbers(n)
      if foo = winning_board?(n)
        return foo
        break
      end
    end
  end

  def winning_board?(n)
    valid_board = boards.find.with_index do |board, index|
      checked_numbers = board.select { _2[:checked] }

      win = checked_numbers.map { _2[:coord] }.transpose.map(&:tally).any? { |v| v.values.any? { _1 == @board_length } }

      if win && @total_boards - 1 == @winning_boards.uniq.size && !@winning_boards.include?(index)
        return board.select { !_2[:checked] }.keys.sum * n
      elsif win
        @winning_boards << index
        false
      else
        false
      end
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 4512, PartOne.new(input).solution
    assert_equal 64084, PartOne.new.solution
  end

  def test_part_two
    assert_equal 1924, PartTwo.new(input).solution
    assert_equal 12833, PartTwo.new.solution
  end

  def input
    <<~INPUT
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
      8  2 23  4 24
      21  9 14 16  7
      6 10  3 18  5
      1 12 20 15 19

      3 15  0  2 22
      9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
      2  0 12  3  7
    INPUT
  end
end
