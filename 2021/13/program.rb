require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/13/input.txt'))
    @input = input
    @x_max = 0
    @y_max = 0
    @grid = initial_grid
  end

  def solution
    fold_paper(instructions.first)
    @grid.select { |coord, value| value > 0 }.size
  end

  private

  attr_reader :input

  def fold_paper(instruction)
    fold_direction, fold_line = instruction

    if fold_direction == "y"
      @grid.select { |coord, count| coord[1] > fold_line }.each do |coord, value|
        x, y = coord
        @grid.delete(coord)
        @grid[[x, y - ((y-fold_line) * 2 )]] += value
      end
    else
      @grid.select { |coord, count| coord[0] > fold_line }.each do |coord, value|
        x, y = coord
        @grid.delete(coord)
        @grid[[x - ((x-fold_line) * 2 ), y]] += value
      end
    end
  end

  def initial_grid
    obj = Hash.new(0)

    x_s, y_s = input.split("\n\n")[0].lines.map(&:chomp).map { _1.split(',') }.transpose
    @x_max = x_s.map(&:to_i).max
    @y_max = y_s.map(&:to_i).max

    (0..@x_max).each do |x|
      (0..@y_max).each do |y|
        obj[[x,y]] = 0
      end
    end

    coords = input.split("\n\n")[0].lines.map(&:chomp).each do |v|
      x,y = v.split(',').map(&:to_i)
      obj[[x,y]] += 1
    end

    obj
  end

  def display_grid
    x_s, y_s = @grid.keys.transpose
    x_max = x_s.map(&:to_i).max
    y_max = y_s.map(&:to_i).max

    output = ''

    (0..y_max).each do |y|
      (0..x_max).each do |x|
        coord = [x,y]
        value = @grid[coord] > 0 ? '#' : '.'

        if x == x_max
          output += "#{value}\n"
        else
          output += value
        end
      end
    end

    puts output
  end

  def instructions
    @instructions ||= begin
      instructions = input.split("\n\n")[1].lines.map do |line|
        dir, value = line.chomp.split('fold along ')[1].split('=')

        [dir, value.to_i]
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    instructions.each { fold_paper(_1) }
    display_grid
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 17, PartOne.new(input).solution
    assert_equal 743, PartOne.new.solution
  end

  def test_part_two
    # No tests, visual output
  end

  def input
    <<~INPUT
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
    INPUT
  end
end
