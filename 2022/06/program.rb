require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/06/input.txt'), count: 4)
    @input = input
    @count = count
  end

  def solution
    input.index(marker) + count
  end

  private

  attr_reader :input, :count

  def marker
    input.chars.each_cons(count).detect do |x|
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
    assert_equal 19, PartOne.new("mjqjpqmgbljsphdztnvjfqwrcgsmlb", count: 14).solution
    assert_equal 23, PartOne.new("bvwbjplbgvbhsrlpgdmjqwftvncz", count: 14).solution
    assert_equal 23, PartOne.new("nppdvjthqldpwncqszvftbrmjlhg", count: 14).solution
    assert_equal 29, PartOne.new("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", count: 14).solution
    assert_equal 26, PartOne.new("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", count: 14).solution
    assert_equal 3380, PartOne.new(count: 14).solution
  end
end
