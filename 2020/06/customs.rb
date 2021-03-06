require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/06/input.txt'))
    @input = input
  end

  def solution
    groups.sum { |group| group.inject(:|).count }
  end

  private

  attr_reader :input, :groups

  def groups
    @groups ||= begin
      input.split(/\n{2,}/).map(&:split).map { |g| g.map(&:chars) }
    end
  end
end

class PartTwo < PartOne
  def solution
    groups.sum { |group| group.inject(:&).count }
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 6, PartOne.new(
      <<~INPUT
        abcx
        abcy
        abcz
      INPUT
    ).solution
    assert_equal 11, PartOne.new(
      <<~INPUT
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
      INPUT
    ).solution
    assert_equal 6534, PartOne.new.solution
  end

  def test_part_two
    assert_equal 6, PartTwo.new(
      <<~INPUT
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
      INPUT
    ).solution
    assert_equal 3402, PartTwo.new.solution
  end
end
