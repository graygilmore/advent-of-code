require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/09/input.txt'))
    @stream = input
  end

  def solution
    remove_bangs
    remove_garbage
    group_scores
  end

  private

  attr_reader :stream

  def remove_bangs
    stream.gsub!(/!.{1}/, "")
  end

  def count_garbage
    character_count = 0
    stream.scan(/<([^>]*)>/).each do |match|
      character_count += match[0].size
    end
    character_count
  end

  def remove_garbage
    stream.gsub!(/<[^>]*>/, "")
  end

  def group_scores
    score = 0
    openings = []
    stream.chars.each do |char|
      case char
      when "{"
        openings << char
      when "}"
        score += openings.size
        openings.pop
      else
        next
      end
    end

    score
  end
end

class PartTwo < PartOne
  def solution
    remove_bangs
    count_garbage
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 16, PartOne.new('{{{},{},{{}}}}').solution
    assert_equal 11347, PartOne.new.solution
  end

  def test_part_two
    assert_equal 10, PartTwo.new('<{o"i!a,<{i<a>').solution
    assert_equal 5404, PartTwo.new.solution
  end
end
