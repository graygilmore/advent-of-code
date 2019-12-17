require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(program = input, sequence = nil)
    @program = program
    @sequence = sequence
  end

  def solution
    if !@sequence
      [0,1,2,3,4].permutation.map do |sequence|
        @second_input = 0
        sequence.map do |i|
          @second_input = intcode([i, @second_input])
        end.last
      end.max
    else
      @second_input = 0
      @sequence.map do |i|
        @second_input = intcode([i, @second_input])
      end.last
    end
  end

  private

  def intcode(inputs)
    @last_output = 0
    @instruction_pointer = 0

    loop do
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
        @program[parameter(1, 1)] = inputs.shift
        @instruction_pointer += 2
      when 4
        output = parameter(1)
        @last_output = output
        @instruction_pointer += 2
      when 5
        if parameter(1) != 0
          @instruction_pointer = parameter(2)
        else
          @instruction_pointer += 3
        end
      when 6
        if parameter(1) == 0
          @instruction_pointer = parameter(2)
        else
          @instruction_pointer += 3
        end
      when 7
        @program[parameter(3, 1)] = parameter(1) < parameter(2) ? 1 : 0
        @instruction_pointer += 4
      when 8
        @program[parameter(3, 1)] = parameter(1) == parameter(2) ? 1 : 0
        @instruction_pointer += 4
      when 99
        return @last_output
      else
        raise "bad opcode #{opcode}"
      end
    end
  end

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

class TestCircuit < Minitest::Test
  def test_part_one
    assert_equal 43210, PartOne.new([
      3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0
    ], [4,3,2,1,0]).solution
    assert_equal 54321, PartOne.new([
      3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0
    ], [0,1,2,3,4]).solution
    assert_equal 65210, PartOne.new([
      3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,
      31,1,32,31,31,4,31,99,0,0,
    ], [1,0,4,3,2]).solution
  end

  # def test_part_two
  #   assert_equal true, PartTwo.new().solution
  # end
end

puts "Part One: #{::PartOne.new.solution}"
# puts "Part One: #{::PartTwo.new.solution}"
