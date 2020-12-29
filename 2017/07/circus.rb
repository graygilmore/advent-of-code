require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/07/input.txt'))
    @input = input
  end

  def solution
    parent_programs = programs.select { |k, v| !v[:children].nil? }

    while parent_programs.size > 1 do
      new_parents = parent_programs.select do |program, attributes|
        attributes[:children].any? do |child|
          parent_programs[child]
        end
      end

      parent_programs = new_parents
    end

    parent_programs.keys.first
  end

  private

  attr_reader :input

  def programs
    @programs ||= begin
      input.split(/\n/).map { |p|
        p.gsub!(' (', ',')
        p.gsub!(')', '')

        current, children = p.split(' -> ')
        key, weight = current.split(',')

        data = {}
        data[:weight] = weight.to_i

        if children
          data[:children] = children.split(', ')
        end

        [key, data]
      }.to_h
    end
  end
end

class PartTwo < PartOne
  def solution
    program = programs[PartOne.new(input).solution]
    previous_program = nil
    fixed_weight = nil

    while fixed_weight == nil do
      weights = program[:children].map { |child| child_sum(programs[child]) }

      if weights.uniq.length == 1
        # This means that all of the children weight are the same and we've
        # found our trouble maker
        fixed_weight = program[:weight] - weight_difference(previous_program)
      else
        unique_weight = weights.detect { |weight| weights.count(weight) == 1 }
        previous_program = program
        program = programs[program[:children][weights.index(unique_weight)]]
      end
    end

    fixed_weight
  end

  private

  def weight_difference(program)
    weights = program[:children].map { |child| child_sum(programs[child]) }
    weights.uniq.max - weights.uniq.min
  end

  def child_sum(program)
    if program[:children].nil?
      program[:weight]
    else
      program[:weight] + program[:children].map { |child| child_sum(programs[child]) }.sum
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 'tknk', PartOne.new(input).solution
    assert_equal 'bsfpjtc', PartOne.new.solution
  end

  def test_part_two
    assert_equal 60, PartTwo.new(input).solution
    assert_equal 529, PartTwo.new.solution
  end

  def input
    <<~INPUT
      pbga (66)
      xhth (57)
      ebii (61)
      havc (66)
      ktlj (57)
      fwft (72) -> ktlj, cntj, xhth
      qoyq (66)
      padx (45) -> pbga, havc, qoyq
      tknk (41) -> ugml, padx, fwft
      jptl (61)
      ugml (68) -> gyxo, ebii, jptl
      gyxo (61)
      cntj (57)
    INPUT
  end
end
