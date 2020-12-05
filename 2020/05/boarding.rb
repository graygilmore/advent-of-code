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
        rows = row ? row : plane_rows
        columns = column ? column : plane_columns

        case char
        when 'F'
          row = rows.each_slice(rows.size/2).to_a[0]
        when 'B'
          row = rows.each_slice(rows.size/2).to_a[1]
        when 'R'
          column = columns.each_slice(columns.size/2).to_a[1]
        when 'L'
          column = columns.each_slice(columns.size/2).to_a[0]
        end
      end

      row.sum * 8 + column.sum
    end
  end

  def plane_rows
    (0..127).to_a
  end

  def plane_columns
    (0..7).to_a
  end

  attr_reader :input
end

class PartTwo < PartOne
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
  end
end
