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
          rows
        )
      end
    end
  end
end

Tile = Struct.new(:id, :data, :top, :right, :bottom, :left, :matches) do
  def top_border
    data.first
  end

  def right_border
    data.map { |d| d.chars.last }.join
  end

  def bottom_border
    data.last
  end

  def left_border
    data.map { |d| d[0] }.join
  end

  def flip_y!
    data.reverse!
  end

  def flip_x!
    self.data = data.map { |row| row.chars.reverse.join }
  end

  def add_match!(match)
    matches ? matches.add(match) : self.matches = Set[match]
  end

  def x_flipped_borders
    [top_border.reverse, left_border, bottom_border.reverse, right_border]
  end

  def y_flipped_borders
    [bottom_border, right_border.reverse, top_border, left_border.reverse]
  end

  def borders
    [
      top_border,
      right_border,
      bottom_border,
      left_border
    ]
  end

  def all_possible_borders
    [
      borders,
      borders.map(&:reverse)
    ].flatten
  end

  def rotate!
    self.data = data.map(&:chars).transpose.map { |r| r.reverse.join }
  end
end

class PartTwo < PartOne
  def solution
    @image = Image.new(Math.sqrt(tiles.count).to_i)

    tiles.combination(2).each do |tile1, tile2|
      if (tile1.borders & tile2.all_possible_borders).count > 0
        tile1.add_match!(tile2.id)
        tile2.add_match!(tile1.id)
      end
    end

    place_seed(tiles.detect { |t| t.matches.count == 2 })

    @image.rough_waters
  end

  private

  def place_seed(tile)
    @image.add_tile!([0,0], tile)

    matches = tiles.select { |t| tile.matches.include?(t.id) }
    matched_borders = matches.map(&:all_possible_borders).flatten

    until matched_borders.include?(tile.right_border) && 
      matched_borders.include?(tile.bottom_border)
      tile.rotate!
    end

    right_match = matches.detect { |m| m.all_possible_borders.include?(tile.right_border) }

    tile.right = right_match.id

    align_tiles(tile, right_match, :right, [1,0])
  end

  def align_tiles(source, tile, direction, coordinate)
    case direction
    when :right
      (0..7).each do |i|
        break if tile.left_border == source.right_border

        case i
        when 3
          tile.flip_x!
        else
          tile.rotate!
        end
      end

      tile.left = source.id
      @image.add_tile!(coordinate, tile)
    when :bottom
      (0..7).each do |i|
        break if tile.top_border == source.bottom_border

        case i
        when 3
          tile.flip_x!
        else
          tile.rotate!
        end
      end

      tile.top = source.id
      @image.add_tile!(coordinate, tile)
    end

    if next_right_tile = find_right_match(tile)
      align_tiles(tile, next_right_tile, :right, [coordinate[0] + 1, coordinate[1]])
    else
      # If there are no matching right tiles it means we need to start another row
      source_tile = @image.grid[[0, coordinate[1]]]
      bottom_match = find_bottom_match(source_tile)

      if bottom_match
        align_tiles(source_tile, bottom_match, :bottom, [0, coordinate[1] + 1])
      end
    end
  end

  def find_right_match(tile)
    # Ignore the match that we have already connected
    ids = tile.matches - [tile.top, tile.right, tile.bottom, tile.top]

    # Find matching left border
    tiles.detect { |t| 
      ids.include?(t.id) &&
        t.all_possible_borders.include?(tile.right_border)
    }
  end

  def find_bottom_match(tile)
    # Ignore the matches that we have already connected
    ids = tile.matches - [tile.top, tile.right, tile.bottom, tile.top]

    # Find matching top border
    tiles.detect { |t| 
      ids.include?(t.id) &&
        t.all_possible_borders.include?(tile.bottom_border)
    }
  end
end

Image = Struct.new(:length) do
  def grid
    @grid ||= (0..length-1).map do |y|
      (0..length-1).map do |x|
        [[x,y], nil]
      end
    end.flatten(1).to_h
  end

  def add_tile!(coordinate, tile)
    grid[coordinate] = tile
    grid
  end

  def rough_waters
    removed_borders = grid.map { |coordinate, tile|
      temp = tile.data.dup
      temp.shift
      temp.pop
      temp.map { |s| s[1..-2] }
    }

    processed = removed_borders.
      each_slice(length).
      map { |*a| [*a].flatten(1).transpose.map(&:join) }.
      flatten(1)

    (0..7).each do |i|
      break if monsters?(processed)
      case i
      when 3
        processed = processed.reverse
      else
        processed = processed.map(&:chars).transpose.map { |r| r.reverse.join }
      end
    end
 
    replace_monsters_bits(processed).join.count('#')
  end

  def replace_monsters_bits(image)
    (0..image.length-3).each do |index|
      (0..image[index].length-21).each do |i|
        if monster_found?(image, index, i)
          image[index][18 + i] = '0'
          second_row.each { |x| image[index+1][x+i] = '0' }
          third_row.each { |x| image[index+2][x+i] = '0' }
        end
      end
    end

    image
  end

  def monsters?(image)
    (0..image.length-3).any? do |index|
      (0..image[index].length-21).any? do |i|
        monster_found?(image, index, i)
      end
    end
  end

  def monster_found?(image, row_index, left_adjustment)
    image[row_index][18 + left_adjustment] == '#' && 
      second_row.all? { |x| image[row_index+1][x + left_adjustment] == '#' } && 
      third_row.all? { |x| image[row_index+2][x + left_adjustment] == '#' }
  end

  def second_row
    [0, 5, 6, 11, 12, 17, 18, 19]
  end

  def third_row
    [1, 4, 7, 10, 13, 16]
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 20899048083289, PartOne.new(input).solution
    assert_equal 18482479935793, PartOne.new.solution
  end

  def test_part_two
    assert_equal 273, PartTwo.new(input).solution
    assert_equal 2118, PartTwo.new.solution
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
