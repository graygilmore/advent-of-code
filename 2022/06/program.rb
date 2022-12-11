require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/06/input.txt'))
    @input = input
  end

  def solution
    input.index(marker) + 4
  end

  private

  attr_reader :input

  def marker
    input.chars.each_cons(4).detect do |x|
      x.uniq.size === x.size
    end.join("")
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 7, PartOne.new("mjqjpqmgbljsphdztnvjfqwrcgsmlb").solution
    assert_equal 5, PartOne.new("bvwbjplbgvbhsrlpgdmjqwftvncz").solution
    assert_equal 6, PartOne.new("nppdvjthqldpwncqszvftbrmjlhg").solution
    assert_equal 10, PartOne.new("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").solution
    assert_equal 11, PartOne.new("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").solution
    assert_equal 1909, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
  end
end
