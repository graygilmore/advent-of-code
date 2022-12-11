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
    input.index(marker) + 14
  end

  private

  def marker
    input.chars.each_cons(14).detect do |x|
      x.uniq.size === x.size
    end.join("")
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
    assert_equal 19, PartTwo.new("mjqjpqmgbljsphdztnvjfqwrcgsmlb").solution
    assert_equal 23, PartTwo.new("bvwbjplbgvbhsrlpgdmjqwftvncz").solution
    assert_equal 23, PartTwo.new("nppdvjthqldpwncqszvftbrmjlhg").solution
    assert_equal 29, PartTwo.new("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").solution
    assert_equal 26, PartTwo.new("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").solution
    assert_equal 3380, PartTwo.new.solution
  end
end
