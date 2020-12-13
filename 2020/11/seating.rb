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

  def fill_seats(seating_arrangement, move_requirement = 4)
    new_seats = seating_arrangement.dup

    seating_arrangement.each do |coordinate, data|
      seat_status, adjacent_seats = data

      next if seat_status == '.'

      occupied =
        adjacent_seats.count { |adj_seat| seating_arrangement[adj_seat][0] == '#' }

      if occupied >= move_requirement && seat_status == '#'
        new_seats[coordinate] = ['L', adjacent_seats]
      elsif occupied == 0 && seat_status == 'L'
        new_seats[coordinate] = ['#', adjacent_seats]
      end
    end

    if new_seats == seating_arrangement
      return filled_seats(new_seats)
    else
      fill_seats(new_seats, move_requirement)
    end
  end

  def initial_seats
    @initial_seats ||= begin
      seats = input.split.map.with_index do |row, y|
        row.chars.map.with_index do |seat_status, x|
          [
            [x,y],
            seat_status
          ]
        end
      end.flatten(1).to_h

      seats.each do |coordinate, seat_status|
        seats[coordinate] = [seat_status, adjacent_seats(coordinate, seats)]
      end

      seats
    end
  end

  def y_max
    @y_max ||= input.split.count
  end

  def x_max
    @x_max ||= input.split.first.chars.count
  end

  def adjacent_seats(seat, _)
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
    ].reject { |x,y| x.negative? || y.negative? || x >= x_max || y >= y_max }
  end

  def filled_seats(seating_arrangement)
    seating_arrangement.count { |_, seat| seat[0] == '#' }
  end
end

class PartTwo < PartOne
  def solution
    fill_seats(initial_seats, 5)
  end

  def adjacent_seats(seat, seating_arrangement)
    x,y = seat

    up = (1..y).map { |up| [x, y-up] }
    down = (y+1..y_max-1).map { |down| [x, down] }

    left = (0..x-1).map { |left| [left, y] }
    right = (x+1..x_max).map { |right| [right, y] }

    up_right = (1..x_max).collect { |i| [x+i, y-i] }
    down_right = (1..x_max).collect { |i| [x+i, y+i] }

    up_left = (1..x_max).collect { |i| [x-i, y-i] }
    down_left = (1..x_max).collect { |i| [x-i, y+i] }

    [
      up_left,
      up,
      up_right,
      right,
      down_right,
      down,
      down_left,
      left.reverse,
    ]
  end

  def occupied_adjacent_seats(seat, seating_arrangement)
    adjacent_seats(seat, seating_arrangement).count do |direction|
      first_seat = direction.detect { |coordinate| seating_arrangement[coordinate] != '.' }
      seating_arrangement[first_seat] == '#'
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 37, PartOne.new(input).solution
    assert_equal 2303, PartOne.new.solution
  end

  def test_part_two
    # assert_equal 26, PartTwo.new(input).solution
    # assert_equal 2057, PartTwo.new.solution
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
