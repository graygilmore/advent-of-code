require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/24/input.txt'))
    @input = input
  end

  def solution
    @grid = {}

    place_tiles

    @grid.count { |_, v| v == "black" }
  end

  private

  attr_reader :input

  def place_tiles
    tiles.each do |tile|
      x, y, z = [0,0,0]

      tile.each do |direction|
        case direction
        when "se"
          z += 1
          y += -1
        when "sw"
          z += 1
          x += -1
        when "ne"
          z += -1
          x += 1
        when "nw"
          z += -1
          y += 1
        when "e"
          x += 1
          y += -1
        when "w"
          x += -1
          y += 1
        end

        @grid[[x,y,z]]
      end

      @grid[[x,y,z]] = @grid[[x,y,z]] == 'black' ? 'white' : 'black'
    end
  end

  def tiles
    @tiles ||= begin
      input.split(/\n/).map { |t| t.split(/(se|sw|nw|ne|e|w)/).reject(&:empty?) }
    end
  end
end

class PartTwo < PartOne
  def solution
    @grid = {}
    @adjacent = {}
    place_tiles
    100.times do
      flip_tiles
    end
    @grid.count { |_, v| v == "black" }
  end

  private

  def adjacent_coordinates(coordinate)
    @adjacent[coordinate] ||= begin
      ox, oy, oz = coordinate

      [0, 1, -1].permutation.map do |x,y,z|
        [ox + x, oy + y, oz + z]
      end
    end
  end

  def black_adjacent_tiles(coordinate)
    adjacent_coordinates(coordinate).count { |x|
      @grid[x] == 'black'
    }
  end

  def flip_tiles
    add_tiles_to_grid
    new_grid = @grid.dup
    @grid.each do |coordinate, value|
      if value == 'black' && [0, 3, 4, 5, 6].include?(black_adjacent_tiles(coordinate))
        new_grid[coordinate] = 'white'
      elsif value == 'white' && black_adjacent_tiles(coordinate) == 2
        new_grid[coordinate] = 'black'
      end
    end
    @grid = new_grid
  end

  def add_tiles_to_grid
    @grid.keys.each do |coordinate|
      adjacent_coordinates(coordinate).each { |x|
        @grid[x] = @grid[x] ? @grid[x] : 'white'
      }
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 10, PartOne.new(input).solution
    assert_equal 244, PartOne.new.solution
  end

  def test_part_two
    assert_equal 2208, PartTwo.new(input).solution
    assert_equal 3665, PartTwo.new.solution
  end

  def input
    <<~INPUT
      sesenwnenenewseeswwswswwnenewsewsw
      neeenesenwnwwswnenewnwwsewnenwseswesw
      seswneswswsenwwnwse
      nwnwneseeswswnenewneswwnewseswneseene
      swweswneswnenwsewnwneneseenw
      eesenwseswswnenwswnwnwsewwnwsene
      sewnenenenesenwsewnenwwwse
      wenwwweseeeweswwwnwwe
      wsweesenenewnwwnwsenewsenwwsesesenwne
      neeswseenwwswnwswswnw
      nenwswwsewswnenenewsenwsenwnesesenew
      enewnwewneswsewnwswenweswnenwsenwsw
      sweneswneswneneenwnewenewwneswswnese
      swwesenesewenwneswnwwneseswwne
      enesenwswwswneneswsenwnewswseenwsese
      wnwnesenesenenwwnenwsewesewsesesew
      nenewswnwewswnenesenwnesewesw
      eneswnwswnwsenenwnwnwwseeswneewsenese
      neswnwewnwnwseenwseesewsenwsweewe
      wseweeenwnesenwwwswnew
    INPUT
  end
end
