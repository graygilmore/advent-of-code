require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/24/input.txt'))
    @input = input
  end

  def solution
    grid = {}

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
      end

      grid[[x,y,z]] = grid[[x,y,z]] ? 'white' : 'black'
    end

    grid.count { |_, v| v == "black" }
  end

  private

  attr_reader :input

  def tiles
    @tiles ||= begin
      input.split(/\n/).map { |t| t.split(/(se|sw|nw|ne|e|w)/).reject(&:empty?) }
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
    assert_equal 10, PartOne.new(input).solution
    assert_equal 244, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
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
