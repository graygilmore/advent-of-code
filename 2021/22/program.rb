require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/22/input.txt'), scoped = true)
    @input = input
    @scoped = scoped
    @grid = Hash.new("off")
  end

  def solution
    steps.size.times do |i|
      flip_switches(steps["step #{i}"])
    end
    @grid.count { |k, v| v == "on" }
  end

  private

  attr_reader :input

  def steps
    @steps ||= begin
      obj = {}
      input.lines.map(&:chomp).each.with_index do |line, i|
        dir = line.match(/off |on /)[0].strip

        x_match, y_match, z_match = %w(x y z).map do |v|
          parse_range(line, v)
        end
        next if [x_match, y_match, z_match].any? { outside_scope?(_1) } && @scoped

        xs = (x_match[1].to_i..x_match[2].to_i).to_a
        ys = (y_match[1].to_i..y_match[2].to_i).to_a
        zs = (z_match[1].to_i..z_match[2].to_i).to_a

        coords = xs.map { |x| ys.map { |y| zs.map { |z| [x, y, z] } } }.flatten(2)

        obj["step #{i}"] = {
          dir: dir,
          coords: coords,
        }
      end
      obj
    end
  end

  def parse_range(line, v)
    line.match(/#{v}=(-?\d*)..(-?\d*)/)
  end

  def outside_scope?(d)
    start = d[1].to_i
    finish = d[2].to_i

    return true if [start, finish].any? { _1 < -50 || _1 > 50 }
  end

  def flip_switches(s)
    s[:coords].each do |coord|
      @grid[coord] = s[:dir]
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
    assert_equal 39, PartOne.new(input).solution
    assert_equal 590784, PartOne.new(large_input).solution
    assert_equal 623748, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      on x=10..12,y=10..12,z=10..12
      on x=11..13,y=11..13,z=11..13
      off x=9..11,y=9..11,z=9..11
      on x=10..10,y=10..10,z=10..10
    INPUT
  end

  def large_input
    <<~INPUT
      on x=-20..26,y=-36..17,z=-47..7
      on x=-20..33,y=-21..23,z=-26..28
      on x=-22..28,y=-29..23,z=-38..16
      on x=-46..7,y=-6..46,z=-50..-1
      on x=-49..1,y=-3..46,z=-24..28
      on x=2..47,y=-22..22,z=-23..27
      on x=-27..23,y=-28..26,z=-21..29
      on x=-39..5,y=-6..47,z=-3..44
      on x=-30..21,y=-8..43,z=-13..34
      on x=-22..26,y=-27..20,z=-29..19
      off x=-48..-32,y=26..41,z=-47..-37
      on x=-12..35,y=6..50,z=-50..-2
      off x=-48..-32,y=-32..-16,z=-15..-5
      on x=-18..26,y=-33..15,z=-7..46
      off x=-40..-22,y=-38..-28,z=23..41
      on x=-16..35,y=-41..10,z=-47..6
      off x=-32..-23,y=11..30,z=-14..3
      on x=-49..-5,y=-3..45,z=-29..18
      off x=18..30,y=-20..-8,z=-3..13
      on x=-41..9,y=-7..43,z=-33..15
      on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
      on x=967..23432,y=45373..81175,z=27513..53682
    INPUT
  end
end
