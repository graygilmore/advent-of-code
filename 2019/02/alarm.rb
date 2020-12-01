require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(program = input)
    @program = program
  end

  def solution
    @program[1] = 12
    @program[2] = 2
    run_program(@program)
  end

  private

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).chomp.split(',').map(&:chomp).map(&:to_i)
      end
  end

  def run_program(modified_program)
    new_program = modified_program

    new_program.each_slice(4).each do |slice|
      opcode = slice[0]

      break if opcode == 99

      first_input_position = slice[1]
      second_input_position = slice[2]
      output_position = slice[3]

      if opcode == 1
        sum = new_program[first_input_position] + new_program[second_input_position]
        new_program[output_position] = sum
      elsif opcode == 2
        sum = new_program[first_input_position] * new_program[second_input_position]
        new_program[output_position] = sum
      end
    end

    new_program[0]
  end
end

class PartTwo < PartOne
  def solution
    foo = nil

    [*1..99].permutation(2).to_a.each do |noun, verb|
      modified_program = @program.dup
      modified_program[1] = noun
      modified_program[2] = verb

      result = run_program(modified_program)

      if result == 19690720
        puts 'HEY'
        foo =  100 * noun + verb
        break
      end
    end

    foo
  end
end

class TestFuel < Minitest::Test
  def test_part_one
    # assert_equal [3500,9,10,70,2,3,11,0,99,30,40,50], PartOne.new([1,9,10,3,2,3,11,0,99,30,40,50]).solution
    # assert_equal [2,0,0,0,99], PartOne.new([1,0,0,0,99]).solution
    # assert_equal [2,3,0,6,99], PartOne.new([2,3,0,3,99]).solution
    # assert_equal [2,4,4,5,99,9801], PartOne.new([2,4,4,5,99,0]).solution
    # assert_equal [30,1,1,4,2,5,6,0,99], PartOne.new([1,1,1,4,99,5,6,0,99]).solution
  end

  def test_part_two
    # assert_equal 2, PartTwo.new([12]).solution
    # assert_equal 966, PartTwo.new([1969]).solution
    # assert_equal 50346, PartTwo.new([100756]).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
