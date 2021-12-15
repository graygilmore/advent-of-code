require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/15/input.txt'))
    @input = input
    @unvisited_nodes = unvisited_set
    @path_values = {}
  end

  def solution
    find_path
  end

  private

  attr_reader :input

  def unvisited_set
    obj = {}
    grid.keys.each do |key|
      obj[key] = key == [0,0] ? 0 : Float::INFINITY
    end
    obj
  end

  def find_path
    current_node = [0,0]

    while true
      if current_node == grid.keys.last
        return @unvisited_nodes[current_node]
      end

      x, y = current_node
      top = [x, y - 1]
      right = [x + 1, y]
      bottom = [x, y + 1]
      left = [x - 1, y]

      [top, right, bottom, left].each do |coord|
        if @unvisited_nodes[coord]
          new_value = [@unvisited_nodes[coord], @unvisited_nodes[current_node] + grid[coord]].min
          @unvisited_nodes[coord] = new_value
        end
      end

      @unvisited_nodes.delete(current_node)

      current_node = @unvisited_nodes.min_by { |k,v| v }[0]
    end
  end

  def grid
    @grid ||= begin
      obj = {}
      input.lines.map(&:chomp).each.with_index do |line, y|
        line.chars.each.with_index do |char, x|
          obj[[x,y]] = char.to_i
        end
      end
      obj
    end
  end
end

class PartTwo < PartOne
  def solution
    find_path
  end

  private

  def grid
    @grid ||= begin
      obj = {}
      square_size = input.lines.map(&:chomp).size
      input.lines.map(&:chomp).each.with_index do |line, y|
        line.chars.each.with_index do |char, x|
          obj[[x,y]] = char.to_i
        end

        (1..4).each do |multiplier|
          square_size.times do |x|
            new_x_position = x + (square_size * multiplier)
            new_position = [new_x_position,y]
            old_value = obj[[new_x_position - square_size,y]]
            obj[new_position] = old_value == 9 ? 1 : old_value + 1
          end
        end
      end

      (square_size..(square_size * 5 - 1)).each do |y|
        (square_size * 5).times do |x|
          new_position = [x,y]
          old_value = obj[[x, y - square_size]]
          obj[new_position] = old_value == 9 ? 1 : old_value + 1
        end
      end

      obj
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 40, PartOne.new(input).solution
    assert_equal 652, PartOne.new.solution
  end

  def test_part_two
    assert_equal 315, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      1163751742
      1381373672
      2136511328
      3694931569
      7463417111
      1319128137
      1359912421
      3125421639
      1293138521
      2311944581
    INPUT
  end
end
