require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/20/input.txt'))
    @input = input
  end

  def solution
    tiles.map do |tile|
      comparable_borders = 
        all_possible_borders - [tile.borders] - [tile.borders.map(&:reverse)]

      if (tile.borders & comparable_borders.flatten).count == 2
        tile.id
      end
    end.compact.inject(:*)
  end

  private

  attr_reader :input

  def all_possible_borders
    @all_possible_borders ||= 
      ([tiles.map(&:borders)] + [tiles.map { |t| t.borders.map(&:reverse) }]).flatten(1)
  end

  def tiles
    @tiles ||= begin
      input.split(/\n\n/).map do |tile|
        id, data = tile.split(/Tile (\d+):/).reject(&:empty?)
        rows = data.split(/\n/).reject(&:empty?)

        Tile.new(
          id.to_i,
          [
            rows.first,
            rows.map { |row| row.chars.last }.join,
            rows.last,
            rows.map { |row| row[0] }.join
          ]
        )
      end
    end
  end
end

Tile = Struct.new(:id, :borders) do
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 20899048083289, PartOne.new(input).solution
    assert_equal 18482479935793, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      Tile 2311:
      ..##.#..#.
      ##..#.....
      #...##..#.
      ####.#...#
      ##.##.###.
      ##...#.###
      .#.#.#..##
      ..#....#..
      ###...#.#.
      ..###..###

      Tile 1951:
      #.##...##.
      #.####...#
      .....#..##
      #...######
      .##.#....#
      .###.#####
      ###.##.##.
      .###....#.
      ..#.#..#.#
      #...##.#..

      Tile 1171:
      ####...##.
      #..##.#..#
      ##.#..#.#.
      .###.####.
      ..###.####
      .##....##.
      .#...####.
      #.##.####.
      ####..#...
      .....##...

      Tile 1427:
      ###.##.#..
      .#..#.##..
      .#.##.#..#
      #.#.#.##.#
      ....#...##
      ...##..##.
      ...#.#####
      .#.####.#.
      ..#..###.#
      ..##.#..#.

      Tile 1489:
      ##.#.#....
      ..##...#..
      .##..##...
      ..#...#...
      #####...#.
      #..#.#.#.#
      ...#.#.#..
      ##.#...##.
      ..##.##.##
      ###.##.#..

      Tile 2473:
      #....####.
      #..#.##...
      #.##..#...
      ######.#.#
      .#...#.#.#
      .#########
      .###.#..#.
      ########.#
      ##...##.#.
      ..###.#.#.

      Tile 2971:
      ..#.#....#
      #...###...
      #.#.###...
      ##.##..#..
      .#####..##
      .#..####.#
      #..#.#..#.
      ..####.###
      ..#.#.###.
      ...#.#.#.#

      Tile 2729:
      ...#.#.#.#
      ####.#....
      ..#.#.....
      ....#..#.#
      .##..##.#.
      .#.####...
      ####.#.#..
      ##.####...
      ##..#.##..
      #.##...##.

      Tile 3079:
      #.#.#####.
      .#..######
      ..#.......
      ######....
      ####.#..#.
      .#...#.##.
      #.#####.##
      ..#.###...
      ..#.......
      ..#.###...
    INPUT
  end
end
