require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/09/input.txt'))
    @input = input
    @head_position = [0,0]
    @tail_position = [0,0]
    @visited = {}
  end

  def solution
    input.lines.map(&:chomp).each do |round|
      dir, length = round.split(" ")

      length.to_i.times do |i|
        hx, hy = @head_position

        case dir
        when "U"
          @head_position = [hx, hy + 1]
        when "R"
          @head_position = [hx + 1, hy]
        when "D"
          @head_position = [hx, hy - 1]
        when "L"
          @head_position = [hx - 1, hy]
        end

        move_tail(dir) unless touching?

        if @visited[@tail_position]
          @visited[@tail_position] += 1
        else
          @visited[@tail_position] = 1
        end
      end
    end

    @visited.keys.size
  end

  private

  attr_reader :input

  def touching?
    tx, ty = @tail_position

    (tx-1..tx+1).to_a.any? do |x|
      (ty-1..ty+1).to_a.any? do |y|
        [x,y] == @head_position
      end
    end
  end

  def move_tail(dir)
    hx, hy = @head_position
    tx, ty = @tail_position

    if (@head_position.sum - @tail_position.sum).abs == 2
      case dir
      when "U"
        @tail_position = [tx, ty + 1]
      when "R"
        @tail_position = [tx + 1, ty]
      when "D"
        @tail_position = [tx, ty - 1]
      when "L"
        @tail_position = [tx - 1, ty]
      end
    else
      case dir
      when "U"
        @tail_position = hx > tx ? [tx + 1, ty + 1] : [tx - 1, ty + 1]
      when "R"
        @tail_position = hy > ty ? [tx + 1, ty + 1] : [tx + 1, ty - 1]
      when "D"
        @tail_position = hx > tx ? [tx + 1, ty - 1] : [tx - 1, ty - 1]
      when "L"
        @tail_position = hy > ty ? [tx - 1, ty + 1] : [tx - 1, ty - 1]
      end
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
    assert_equal 13, PartOne.new(input).solution
    assert_equal 6023, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
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
end
