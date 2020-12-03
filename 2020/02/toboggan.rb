require './base'

class PartOne
  def initialize(input = Base.file_input('2020/02/password_list.txt'))
    @input = input
  end

  def solution
    passwords.count { |password| valid?(password) }
  end

  private

  attr_reader :input, :passwords

  def valid?(password)
    password[:value].count(password[:required_letter]) >= password[:range_begin] &&
      password[:value].count(password[:required_letter]) <= password[:range_end]
  end

  def passwords
    @passwords ||= begin
      input.map do |data|
        range, required_letter, value = data.split(' ')

        {
          range_begin: range.split('-')[0].to_i,
          range_end: range.split('-')[1].to_i,
          required_letter: required_letter.gsub(':', ''),
          value: value,
        }
      end
    end
  end
end

class PartTwo < PartOne
  private

  def valid?(password)
    [password[:range_begin], password[:range_end]].count do |position|
      password[:value][position - 1] == password[:required_letter]
    end == 1
  end
end

class TestToboggan < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new(['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']).solution
  end

  def test_part_two
    assert_equal 1, PartTwo.new(['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part Two: #{::PartTwo.new.solution}"
