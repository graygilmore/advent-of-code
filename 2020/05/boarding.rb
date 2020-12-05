require './base'

class PartOne
  def initialize(input = Base.file_input('2020/05/input.txt'))
    @input = input
  end

  def solution
    seat_ids.max
  end

  private

  def seat_ids
    input.map do |partition|
      row = nil
      column = nil

      partition.chars.each do |char|
        rows = row ? row : (0..127).to_a
        columns = column ? column : (0..7).to_a

        case char
        when 'F', 'B'
          row = rows.each_slice(rows.size/2).to_a[char == 'F' ? 0 : 1]
        when 'R', 'L'
          column = columns.each_slice(columns.size/2).to_a[char == 'R' ? 1 : 0]
        end
      end

      row.first * 8 + column.first
    end
  end

  attr_reader :input
end

class PartTwo < PartOne
  def solution
    ((seat_ids.min..seat_ids.max).to_a - seat_ids).first
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 357, PartOne.new(['FBFBBFFRLR']).solution
    assert_equal 567, PartOne.new(['BFFFBBFRRR']).solution
    assert_equal 119, PartOne.new(['FFFBBBFRRR']).solution
    assert_equal 820, PartOne.new(['BBFFBBFRLL']).solution
    assert_equal 978, PartOne.new().solution
  end

  def test_part_two
    assert_equal 727, PartTwo.new().solution
  end
end
