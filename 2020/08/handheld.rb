require './base'
require './computer'

class PartOne
  def initialize(input = Base.raw_input('2020/08/input.txt'))
    @input = input
  end

  def solution
    Computer.new(input).run
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
  def solution
    Computer.new(input).run_fixed_program
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 5, PartOne.new(
      <<~INPUT
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
      INPUT
    ).solution
    assert_equal 1675, PartOne.new.solution
  end

  def test_part_two
    assert_equal 8, PartTwo.new(
      <<~INPUT
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
      INPUT
    ).solution
    assert_equal 1532, PartTwo.new.solution
  end
end
