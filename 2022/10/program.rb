require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/10/input.txt'))
    @input = input
  end

  def solution
    register = 1
    cycles = 0
    signal_strength = 0

    input.lines.map(&:chomp).each do |ins|
      command, value = ins.split(" ")

      cycles_to_run = command == "noop" ? 1 : 2

      cycles_to_run.times do
        cycles += 1

        if [20, 60, 100, 140, 180, 220].include?(cycles)
          signal_strength += cycles * register
        end
      end

      if command == "addx"
        register += value.to_i
      end
    end

    signal_strength
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
  def solution
    sprite_position = 1
    cycles = 0
    crt = ""

    input.lines.map(&:chomp).each do |ins|
      command, value = ins.split(" ")
      cycles_to_run = command == "noop" ? 1 : 2

      cycles_to_run.times do
        crt += (sprite_position-1..sprite_position+1).include?(cycles % 40) ? "#" : "."
        cycles += 1
      end

      if command == "addx"
        sprite_position += value.to_i
      end
    end

    crt.chars.each_slice(40).map(&:join).join("\n")
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 13140, PartOne.new(input).solution
    assert_equal 15360, PartOne.new.solution
  end

  def test_part_two
    assert_equal part_two_test_image.chomp, PartTwo.new(input).solution
    assert_equal part_two_real_image.chomp, PartTwo.new.solution
  end

  def part_two_test_image
    <<~IMAGE
      ##..##..##..##..##..##..##..##..##..##..
      ###...###...###...###...###...###...###.
      ####....####....####....####....####....
      #####.....#####.....#####.....#####.....
      ######......######......######......####
      #######.......#######.......#######.....
    IMAGE
  end

  def part_two_real_image
    <<~IMAGE
      ###..#..#.#....#..#...##..##..####..##..
      #..#.#..#.#....#..#....#.#..#....#.#..#.
      #..#.####.#....####....#.#......#..#..#.
      ###..#..#.#....#..#....#.#.##..#...####.
      #....#..#.#....#..#.#..#.#..#.#....#..#.
      #....#..#.####.#..#..##...###.####.#..#.
    IMAGE
  end

  def input
    <<~INPUT
      addx 15
      addx -11
      addx 6
      addx -3
      addx 5
      addx -1
      addx -8
      addx 13
      addx 4
      noop
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx -35
      addx 1
      addx 24
      addx -19
      addx 1
      addx 16
      addx -11
      noop
      noop
      addx 21
      addx -15
      noop
      noop
      addx -3
      addx 9
      addx 1
      addx -3
      addx 8
      addx 1
      addx 5
      noop
      noop
      noop
      noop
      noop
      addx -36
      noop
      addx 1
      addx 7
      noop
      noop
      noop
      addx 2
      addx 6
      noop
      noop
      noop
      noop
      noop
      addx 1
      noop
      noop
      addx 7
      addx 1
      noop
      addx -13
      addx 13
      addx 7
      noop
      addx 1
      addx -33
      noop
      noop
      noop
      addx 2
      noop
      noop
      noop
      addx 8
      noop
      addx -1
      addx 2
      addx 1
      noop
      addx 17
      addx -9
      addx 1
      addx 1
      addx -3
      addx 11
      noop
      noop
      addx 1
      noop
      addx 1
      noop
      noop
      addx -13
      addx -19
      addx 1
      addx 3
      addx 26
      addx -30
      addx 12
      addx -1
      addx 3
      addx 1
      noop
      noop
      noop
      addx -9
      addx 18
      addx 1
      addx 2
      noop
      noop
      addx 9
      noop
      noop
      noop
      addx -1
      addx 2
      addx -37
      addx 1
      addx 3
      noop
      addx 15
      addx -21
      addx 22
      addx -6
      addx 1
      noop
      addx 2
      addx 1
      noop
      addx -10
      noop
      noop
      addx 20
      addx 1
      addx 2
      addx 2
      addx -6
      addx -11
      noop
      noop
      noop
    INPUT
  end
end
