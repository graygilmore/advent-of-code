require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/05/input.txt'))
    @input = input
  end

  def solution
    jumps_until_escape(warp_drive: true)
  end

  private

  attr_reader :input

  def instructions
    @instructions ||= input.split(/\n/).map(&:to_i)
  end

  def jumps_until_escape(warp_drive: false)
    @target_instruction = 0
    @jumps = 0

    while @target_instruction < instructions.size do
      current_instruction = instructions[@target_instruction].to_i
      increment = !warp_drive && current_instruction >= 3 ? -1 : 1
      instructions[@target_instruction] += increment

      @target_instruction += current_instruction
      @jumps += 1
    end

    @jumps
  end
end

class PartTwo < PartOne
  def solution
    jumps_until_escape
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 5, PartOne.new(input).solution
    assert_equal 343467, PartOne.new.solution
  end

  def test_part_two
    assert_equal 10, PartTwo.new(input).solution
    assert_equal 24774780, PartTwo.new.solution
  end

  def input
    <<~INPUT
      0
      3
      0
      1
      -3
    INPUT
  end
end
