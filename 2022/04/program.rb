require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/04/input.txt'))
    @input = input
  end

  def solution
    redundant_pairs
  end

  private

  attr_reader :input

  def pairs
    input.lines.map(&:chomp).map do |line|
      line.split(",").map do |x|
        start, finish = x.split('-').map(&:to_i)
        (start..finish)
      end
    end
  end

  def redundant_pairs
    pairs.count do |pair|
      elf1, elf2 = pair

      if elf1.size > elf2.size
        pair_contains?(elf1, elf2)
      else
        pair_contains?(elf2, elf1)
      end
    end
  end

  def pair_contains?(big, small)
    small.first >= big.first && small.last <= big.last
  end
end

class PartTwo < PartOne
  def solution
    overlapping_pairs
  end

  private

  def overlapping_pairs
    pairs.count do |pair|
      elf1, elf2 = pair

      (elf1.to_a & elf2.to_a).any?
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new(input).solution
    assert_equal 530, PartOne.new.solution
  end

  def test_part_two
    assert_equal 4, PartTwo.new(input).solution
    assert_equal 903, PartTwo.new.solution
  end

  def input
    <<~INPUT
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
    INPUT
  end
end
