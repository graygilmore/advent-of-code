require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/08/input.txt'))
    @input = input
  end

  def solution
    @instructions_ran = Set[]
    @index = 0
    @accumulator = 0

    run_instruction(instructions[@index])
  end

  def run_instruction(instruction)
    name, value = instruction

    if @instructions_ran.add?(@index)
      case name
      when 'nop'
        @index += 1
        run_instruction(instructions[@index])
      when 'acc'
        @index += 1
        @accumulator += value.to_i
        run_instruction(instructions[@index])
      when 'jmp'
        @index += value.to_i
        run_instruction(instructions[@index])
      end
    else
      return @accumulator
    end
  end

  private

  attr_reader :input, :instructions

  def instructions
    @instructions ||= begin
      input.split(/\n/).map.with_index do |line, index|
        action, value = line.split(' ')

        [index, [action, value.to_i]]
      end.to_h
    end
  end
end

class PartTwo < PartOne
  def solution
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
  end
end
