require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/11/input.txt'))
    @input = input
  end

  def solution
    fill_seats(initial_seats)
  end

  private

  attr_reader :input

  def fill_seats(seating_arrangement)
    new_seats = seating_arrangement.dup

    seating_arrangement.each do |seat|
      next if seat[1] == '.'

      coordinate = seat[0]
      occupied = occupied_adjacent_seats(coordinate, seating_arrangement)

      if occupied >= 4 && seating_arrangement[coordinate] == '#'
        new_seats[coordinate] = 'L'
      elsif occupied == 0 && seating_arrangement[coordinate] == 'L'
        new_seats[coordinate] = '#'
      end
    end

    if new_seats == seating_arrangement
      return filled_seats(new_seats)
    else
      fill_seats(new_seats)
    end
  end

  def initial_seats
    @initial_seats ||= begin
      input.split.map.with_index do |row, y|
        row.chars.map.with_index do |seat, x|
          [
            [x,y],
            seat
          ]
        end
      end.flatten(1).to_h
    end
  end

  def adjacent_seats(seat)
    x,y = seat

    [
      [x-1, y-1],
      [x, y-1],
      [x+1, y-1],
      [x+1, y],
      [x+1, y+1],
      [x, y+1],
      [x-1, y+1],
      [x-1, y]
    ]
  end

  def occupied_adjacent_seats(seat, seating_arrangement)
    adjacent_seats(seat).count { |coordinate| seating_arrangement[coordinate] == '#' }
  end

  def filled_seats(seating_arrangement)
    seating_arrangement.count { |_, seat| seat == '#' }
  end
end

class PartTwo < PartOne
  def solution
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 37, PartOne.new(input).solution
    assert_equal 0, PartOne.new.solution
  end

  def test_part_two
  end

  def input
    <<~INPUT
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
    INPUT
  end
end
