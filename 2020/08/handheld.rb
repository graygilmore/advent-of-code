require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/08/input.txt'))
    @input = input
  end

  def solution
    run_program(instructions)
  end

  def run_program(program)
    @instructions_ran = Set[]
    @index = 0
    @accumulator = 0

    run_instruction(program.first, program)
  end

  def run_instruction(instruction, program)
    name, value = instruction

    if @index == program.length
      return 'WE DID IT'
    end

    if @instructions_ran.add?(@index)
      case name
      when 'nop'
        @index += 1
        run_instruction(program[@index], program)
      when 'acc'
        @index += 1
        @accumulator += value
        run_instruction(program[@index], program)
      when 'jmp'
        @index += value
        run_instruction(program[@index], program)
      end
    else
      return @accumulator
    end
  end

  private

  attr_reader :input, :instructions

  def instructions
    @instructions ||= begin
      input.split(/\n/).map do |line|
        action, value = line.split(' ')

        [action, value.to_i]
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    (0..instructions.length-1).to_a.each do |index_change|
      if instructions[index_change][0] != 'acc' && test_run(index_change) == "WE DID IT"
        return @accumulator
      end
    end
  end

  def test_run(index_change)
    new_program = instructions.dup

    type = new_program[index_change][0]
    new_program[index_change] = [type == 'nop' ? 'jmp' : 'nop', new_program[index_change][1]]

    run_program(new_program)
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
