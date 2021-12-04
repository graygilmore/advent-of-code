require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/04/input.txt'))
    @input = input
    @computed_boards = {}
  end

  def solution
    play
    @computed_boards[@computed_boards.keys.first]
  end

  def play
    numbers.each.with_index do |n, i|
      next if i < boards.first.first.size - 1

      winning_boards = boards.select do |board|
        board.any? { |t| (numbers[0..i] & t).size == t.size }
      end

      winning_boards.each do |board|
        board_index = boards.find_index(board)

        unless @computed_boards.key?(board_index)
          @computed_boards[board_index] =
            (board.flatten.uniq - numbers[0..i]).sum * n
        end
      end

      if @computed_boards.size == boards.size
        break
      end
    end
  end

  private

  attr_reader :input

  def boards
    @boards ||= begin
      input.split("\n\n").drop(1).map { _1.lines.map(&:chomp) }.map do |board|
        rows = board.map { _1.split(' ').map(&:to_i) }
        columns = rows.transpose

        [rows, columns].flatten(1)
      end
    end
  end

  def numbers
    @numbers ||= input.lines.first.chomp.split(",").map(&:to_i)
  end
end

class PartTwo < PartOne
  def solution
    play
    @computed_boards[@computed_boards.keys.last]
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
