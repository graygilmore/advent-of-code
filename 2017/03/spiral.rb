require './base'

class PartOne
  def initialize(input)
    @location = input.to_i
    @grid = {}

    @x_moving_streak = 0
    @x_moving_distance = 1
    @x_axis_direction = :positive

    @y_moving_streak = 0
    @y_moving_distance = 1
    @y_axis_direction = :positive
  end

  def solution
    location_coordinates.values.map(&:abs).sum
  end

  private

  attr_reader :input, :grid, :location

  def location_coordinates(method: :linear)
    coordinates = { x: 0, y: 0 }
    for i in 1..location do
      if i == 1
        grid[{x: coordinates[:x], y: coordinates[:y]}] = i
        next
      end

      case movement(coordinates, i)
      when :right
        coordinates[:x] += 1
      when :up
        coordinates[:y] += 1
      when :left
        coordinates[:x] -= 1
      when :down
        coordinates[:y] -= 1
      end

      if method == :linear
        grid[{x: coordinates[:x], y: coordinates[:y]}] = i
      else
        sum = sum_neighbours(coordinates)
        grid[{x: coordinates[:x], y: coordinates[:y]}] = sum
        return sum if sum > location
      end
    end

    coordinates
  end

  def sum_neighbours(current_coordinate)
    top_left     = { x: current_coordinate[:x] - 1, y: current_coordinate[:y] + 1 }
    top          = { x: current_coordinate[:x],     y: current_coordinate[:y] + 1 }
    top_right    = { x: current_coordinate[:x] + 1, y: current_coordinate[:y] + 1 }
    right        = { x: current_coordinate[:x] + 1, y: current_coordinate[:y] }
    bottom_right = { x: current_coordinate[:x] + 1, y: current_coordinate[:y] - 1 }
    bottom       = { x: current_coordinate[:x],     y: current_coordinate[:y] - 1 }
    bottom_left  = { x: current_coordinate[:x] - 1, y: current_coordinate[:y] - 1 }
    left         = { x: current_coordinate[:x] - 1, y: current_coordinate[:y] }

    sum = [
      grid[top_left],
      grid[top],
      grid[top_right],
      grid[right],
      grid[bottom_right],
      grid[bottom],
      grid[bottom_left],
      grid[left]
    ].compact.sum

    sum
  end

  def movement(coordinates, i)
    if @x_moving_distance == @y_moving_distance
      if @x_axis_direction == :positive
        movement = :right
      else
        movement = :left
      end

      @x_moving_streak += 1

      if @x_moving_streak == @x_moving_distance
        @x_moving_streak = 0
        @x_moving_distance += 1
        @x_axis_direction = @x_axis_direction == :positive ? :negative : :positive
      end
    else
      if @y_axis_direction == :positive
        movement = :up
      else
        movement = :down
      end

      @y_moving_streak += 1

      if @y_moving_streak == @y_moving_distance
        @y_moving_streak = 0
        @y_moving_distance += 1
        @y_axis_direction = @y_axis_direction == :positive ? :negative : :positive
      end
    end

    movement
  end
end

class PartTwo < PartOne
  def solution
    location_coordinates(method: :compounding)
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 31, PartOne.new('1024').solution
    assert_equal 475, PartOne.new('277678').solution
  end

  def test_part_two
    assert_equal 279138, PartTwo.new('277678').solution
  end

  def input
    <<~INPUT
    INPUT
  end
end
