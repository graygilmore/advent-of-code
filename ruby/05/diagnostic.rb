require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(program = input)
    @program = program
    @instruction_pointer = 0
  end

  def solution
    program_running = true
    input_instruction = 1 # for the ship's air conditioner unit

    while program_running
      opcode_instructions = @program[@instruction_pointer].digits
      opcode = opcode_instructions.take(2).reverse.join('').to_i

      case opcode
      when 1
        @program[parameter(3, 1)] = parameter(1) + parameter(2)
        @instruction_pointer += 4
      when 2
        @program[parameter(3, 1)] = parameter(1) * parameter(2)
        @instruction_pointer += 4
      when 3
        @program[parameter(1, 1)] = input_instruction
        @instruction_pointer += 2
      when 4
        puts parameter(1)
        @instruction_pointer += 2
      when 99
        program_running = false
      else
        raise "bad opcode #{opcode}"
      end
    end
  end

  private

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).chomp.split(',').map(&:chomp).map(&:to_i)
      end
  end

  def position_mode(n)
    @program[@instruction_pointer].digits[n + 1] || 0
  end

  def parameter(n, mode = false)
    pmode = mode || position_mode(n)

    parameter_value = @program[@instruction_pointer + n]
    pmode === 0 ? @program[parameter_value] : parameter_value
  end
end

class PartTwo < PartOne
  def solution
  end
end

class TestFuel < Minitest::Test
  def test_part_one
  end

  def test_part_two
  end
end

puts "Part One: #{::PartOne.new.solution}"
# puts "Part Two: #{::PartTwo.new.solution}"
