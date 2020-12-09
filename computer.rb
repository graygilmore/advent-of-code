require './base'

class Computer
  def initialize(program)
    @program = formatted_program(program)
  end

  def run
    _, accumulator = Program.new(program).run
    accumulator
  end

  def run_fixed_program
    (0..program.length-1).to_a.each do |index_to_swap|
      # We can't swap acc actions to skip to the next one
      next if program[index_to_swap][0] == 'acc'

      modified_instructions = program.dup
      action, value = modified_instructions[index_to_swap]

      modified_instructions[index_to_swap] =
        [
          action == 'nop' ? 'jmp' : 'nop',
          value
        ]

      successful, accumulator = Program.new(modified_instructions).run

      if successful
        return accumulator
      end
    end
  end

  private

  attr_reader :program

  def formatted_program(raw_program)
    case raw_program
    when String
      raw_program.split(/\n/).map do |line|
        action, value = line.split(' ')
        [action, value.to_i]
      end
    else
      raw_program
    end
  end
end

class Program
  def initialize(instructions)
    @instructions = instructions
  end

  def run
    run_instruction(0, 0, Set[])
  end

  private

  attr_reader :instructions

  def run_instruction(index, accumulator, completed_instructions)
    action, value = instructions[index]

    if index == instructions.length
      # This means that there are no more instructions to run and we've
      # successfully completed the program
      return [true, accumulator]
    end

    if completed_instructions.add?(index)
      case action
      when 'nop'
        run_instruction(index + 1, accumulator, completed_instructions)
      when 'acc'
        run_instruction(index + 1, accumulator + value, completed_instructions)
      when 'jmp'
        run_instruction(index + value, accumulator, completed_instructions)
      end
    else
      # We've already hit this instruction so we're going to return the
      # accumulator instead of running an infinite loop
      return [false, accumulator]
    end
  end
end

class Test < Minitest::Test
  def test_run
    assert_equal 5, Computer.new(
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
    ).run
  end

  def test_run_fixed_program
    assert_equal 8, Computer.new(
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
    ).run_fixed_program
  end
end
