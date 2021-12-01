require './base'

class PartOne
  def initialize(input = Base.file_input('2021/01/input.txt'))
    @input = input
  end

  def solution
    input.map(&:to_i).each_cons(2).count do |a, b|
      a < b
    end
  end

  private

  attr_reader :input
end

class PartTwo < PartOne
  def solution
    input.map(&:to_i).each_cons(3).map(&:sum).each_cons(2).count do |a, b|
      a < b
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 7, PartOne.new(formatted_input).solution
    assert_equal 1162, PartOne.new.solution
  end

  def test_part_two
    assert_equal 5, PartTwo.new(formatted_input).solution
    assert_equal 1190, PartTwo.new.solution
  end

  def input
    <<~INPUT
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    INPUT
  end

  def formatted_input
    input.chomp.lines.map(&:to_i)
  end
end
