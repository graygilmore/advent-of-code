require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/20/input.txt'), n: 2)
    @input = input
    @n = n
    @image = initial_image
    @infinity_value = "."
  end

  def solution
    @n.times do
      enhance_image
    end

    @image.count { _2 == "#" }
  end

  private

  attr_reader :input

  def enhance_image
    @image.keys.each do |coord|
      neighbors(coord).each do |n_c|
        @image[n_c] = @infinity_value if @image[n_c].nil?
      end
    end

    new_image = @image.dup

    @image.keys.each do |coord|
      new_image[coord] = decode_pixel(coord, new_image)
    end

    calculate_new_infinity_value

    @image = new_image
  end

  def calculate_new_infinity_value
    num = @infinity_value == "." ? "0" : "1"
    @infinity_value = algorithm[(num * 9).to_i(2)]
  end

  def decode_pixel(coord, new_image)
    code = neighbors(coord).map do |n_c|
      value = @image[n_c].nil? ? @infinity_value : @image[n_c]

      value == "." ? 0 : 1
    end.join

    algorithm[code.to_i(2)]
  end

  def neighbors(coord)
    x, y = coord
    [
      [x-1, y-1],
      [x, y-1],
      [x+1, y-1],

      [x-1, y],
      [x, y],
      [x+1, y],

      [x-1, y+1],
      [x, y+1],
      [x+1, y+1],
    ]
  end

  def algorithm
    @algorithm ||= input.lines.first.chomp
  end

  def initial_image
    @initial_image ||= begin
      obj = {}
      input.split("\n\n")[1].lines.map(&:chomp).each.with_index do |line, y|
        line.chars.each.with_index do |value, x|
          obj[[x,y]] = value
        end
      end
      obj
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 24, PartOne.new(input, n: 1).solution
    assert_equal 35, PartOne.new(input).solution
    assert_equal 5489, PartOne.new.solution
  end

  def test_part_two
    assert_equal 3351, PartOne.new(input, n: 50).solution
    assert_equal 19066, PartOne.new(n: 50).solution
  end

  def input
    <<~INPUT
      ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

      #..#.
      #....
      ##..#
      ..#..
      ..###
    INPUT
  end
end
