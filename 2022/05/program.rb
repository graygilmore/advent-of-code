require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/05/input.txt'))
    @input = input
  end

  def solution
    stackies = stacks

    moves.each do |move|
      amount, from, to = move

      take = stackies[from - 1].slice!(-amount, amount)

      stackies[to - 1] << take.reverse
      stackies[to - 1].flatten!
    end

    stackies.map(&:last).join('')
  end

  private

  attr_reader :input

  def stacks
    @stacks ||= begin
      s = []
      diagram = input.split("\n\n").map { |l| l.split("\n") }[0]

      stacks_count = diagram.pop.chars.max.to_i

      diagram.each do |d|
        d.chars.each_slice(4).to_a.each.with_index do |container, index|
          foo = container.join("").gsub(/[^A-Z]/, "").strip

          next if foo.empty?

          if s[index]
            s[index].unshift(foo)
          else
            s[index] = [foo]
          end
        end
      end

      s
    end
  end

  def moves
    @moves ||= begin
      input.split("\n\n").map { |l| l.split("\n") }[1].map do |move|
        move.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i)
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    stackies = stacks

    moves.each do |move|
      amount, from, to = move

      take = stackies[from - 1].slice!(-amount, amount)

      stackies[to - 1] << take
      stackies[to - 1].flatten!
    end

    stackies.map(&:last).join('')
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal "CMZ", PartOne.new(input).solution
    assert_equal "TPGVQPFDH", PartOne.new.solution
  end

  def test_part_two
    assert_equal "MCD", PartTwo.new(input).solution
    assert_equal "DMRDFRHHH", PartTwo.new.solution
  end

  def input
    <<~INPUT
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
    INPUT
  end
end
