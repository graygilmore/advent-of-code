require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/08/input.txt'))
    @input = input
    @largest_running_value = 0
  end

  def solution
    run_instructions
    largest_value
  end

  private

  attr_reader :input

  def run_instructions
    instructions.each do |instruction|
      conditional = instruction.split("if ").last
      conditional_register = conditional.split(" ").first
      conditional_test = conditional.split(" ").drop(1).join(" ")

      action = instruction.include?("inc") ? "+=" : "-="
      value = /(inc|dec)\s(-?\d*)/.match(instruction)[2]

      if eval("registers[conditional_register] #{conditional_test}")
        new_value = eval("registers[instruction.split(" ").first] #{action} #{value}")
        @largest_running_value = largest_value > @largest_running_value ? largest_value : @largest_running_value
      end
    end
  end

  def instructions
    @instructions ||= begin
      input.split(/\n/)
    end
  end

  def largest_value
    registers.values.max
  end

  def registers
    @registers ||= instructions.map do |instruction|
      [
        instruction.split(" ").first,
        0
      ]
    end.to_h
  end
end

class PartTwo < PartOne
  def solution
    run_instructions
    @largest_running_value
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 1, PartOne.new(input).solution
    assert_equal 8022, PartOne.new.solution
  end

  def test_part_two
    assert_equal 10, PartTwo.new(input).solution
    assert_equal 9819, PartTwo.new.solution
  end

  def input
    <<~INPUT
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
    INPUT
  end
end
