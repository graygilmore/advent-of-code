require './base'

class PartOne
  def initialize(input = Base.file_input('2018/03/input.txt'))
    @input = input
  end

  def solution
    fabric.values.count { |v| v.length > 1 }
  end

  private

  attr_reader :input

  def fabric
    fabric = {}

    input.each do |claim|
      raw_id, _, coordinates, size = claim.split(' ')

      id = raw_id.split('#')[1].to_i
      x_start, y_start = coordinates.gsub!(':', '').split(',').map(&:to_i)
      length, height = size.split('x').map(&:to_i)

      x_axis = (x_start..x_start+length-1).to_a
      y_axis = (y_start..y_start+height-1).to_a

      x_axis.map { |x| y_axis.map { |y| [x, y] } }.flatten(1).each do |coordinate|
        fabric[coordinate] = fabric[coordinate] ? fabric[coordinate] << id : [id]
      end
    end

    fabric
  end
end

class PartTwo < PartOne
  def solution
    bad_claims = Set[]
    fabric.each do |coordinate, ids|
      bad_claims.merge(ids) if ids.size > 1
    end

    fabric.select do |coordinate, ids|
      ids.size === 1 && !bad_claims.include?(ids.first)
    end.values.first.first
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 4, PartOne.new([
      '#1 @ 1,3: 4x4',
      '#2 @ 3,1: 4x4',
      '#3 @ 5,5: 2x2'
    ]).solution
    assert_equal 115348, PartOne.new().solution
  end

  def test_part_two
    assert_equal 3, PartTwo.new([
      '#1 @ 1,3: 4x4',
      '#2 @ 3,1: 4x4',
      '#3 @ 5,5: 2x2'
    ]).solution
    assert_equal 188, PartTwo.new().solution
  end
end
