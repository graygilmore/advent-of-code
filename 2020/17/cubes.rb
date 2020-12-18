require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/17/input.txt'))
    @input = input
  end

  def solution
    @grid = initial_grid

    (1..6).each do |_|
      fill_neighbors
      cycle_grid = @grid.dup

      cycle_grid.each do |location, state|
        active_neighbors =
          neighbors(location).count { |n_location| cycle_grid[n_location] == '#' }

        if state == '.' && active_neighbors == 3
          @grid[location] = '#'
        end

        if state == '#' && ![2,3].include?(active_neighbors)
          @grid[location] = '.'
        end
      end
    end

    @grid.values.count { |v| v == "#" }
  end

  private

  attr_reader :input

  def initial_grid
    @initial_grid ||= begin
      initial_state = input.split(/\n/).join()
      length = input.split(/\n/).count

      (0..(length*length)-1).map { |i| [[i%length, i/length, 0], initial_state[i]] }.to_h
    end
  end

  def fill_neighbors
    @grid.keys.each do |location|
      neighbors(location).each { |n_location| @grid[n_location] ||= '.' }
    end
  end

  def neighbors(location)
    @neighbors ||= {}

    @neighbors[location] ||= begin
      ([-1, 0, 1].repeated_permutation(3).to_a - [[0,0,0]]).map do |xm, ym, zm|
        [location[0] + xm, location[1] + ym, location[2] + zm]
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
    assert_equal 112, PartOne.new(input).solution
    assert_equal 372, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      .#.
      ..#
      ###
    INPUT
  end
end
