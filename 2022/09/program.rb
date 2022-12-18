require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/09/input.txt'), total_knots: 2)
    @input = input
    @knots = (0..total_knots-1).to_a
    @knot_positions = @knots.map do |k|
      [k, [0,0]]
    end.to_h
    @visited = [[0,0]]
  end

  def solution
    input.lines.map(&:chomp).each do |round|
      dir, length = round.split(" ")

      length.to_i.times do |i|
        move_head(dir)

        if !touching?(0, 1)
          move_next_knot(dir, 1)
        else
          @visited << knot_positions[knot_positions.keys.last]
        end
      end
    end

    @visited.uniq.size
  end

  private

  attr_reader :input, :knot_positions

  def move_head(dir)
    hx, hy = knot_positions[0]

    case dir
    when "U"
      knot_positions[0] = [hx, hy + 1]
    when "R"
      knot_positions[0] = [hx + 1, hy]
    when "D"
      knot_positions[0] = [hx, hy - 1]
    when "L"
      knot_positions[0] = [hx - 1, hy]
    end
  end

  def touching?(k1, k2)
    x2, y2 = knot_positions[k2]

    (x2-1..x2+1).to_a.any? do |x|
      (y2-1..y2+1).to_a.any? do |y|
        [x,y] == knot_positions[k1]
      end
    end
  end

  def move_next_knot(dir, knot)
    previous_knot = knot_positions[knot - 1]
    current_knot = knot_positions[knot]

    hx, hy = previous_knot
    tx, ty = current_knot

    x_modifier = hx > tx ? 1 : -1
    y_modifier = hy > ty ? 1 : -1

    if hy == ty
      knot_positions[knot] = [tx + x_modifier, ty]
    elsif hx == tx
      knot_positions[knot] = [tx, ty + y_modifier]
    else
      knot_positions[knot] = [tx + x_modifier, ty + y_modifier]
    end

    if knot == knot_positions.keys.last
      @visited << knot_positions[knot]
    else
      move_next_knot(dir, knot + 1) unless touching?(knot, knot + 1)
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 13, PartOne.new(input_simple).solution
    assert_equal 6023, PartOne.new.solution
  end

  def test_part_two
    assert_equal 36, PartOne.new(input_long, total_knots: 10).solution
    assert_equal 2533, PartOne.new(total_knots: 10).solution
  end

  def input_simple
    <<~INPUT
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    INPUT
  end

  def input_long
    <<~INPUT
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    INPUT
  end
end
