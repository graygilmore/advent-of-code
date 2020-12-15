require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/14/input.txt'))
    @input = input
  end

  def solution
    memory = {}

    mask_groups.each do |masked_locations, values_to_write|
      values_to_write.each do |location, value|
        bits_value = '%0*b' % [36, value]
        masked_locations.each { |value, location| bits_value[location] = value.to_s }
        memory[location] = bits_value.to_i(2)
      end
    end

    memory.values.sum
  end

  private

  attr_reader :input

  def mask_groups
    @mask_groups ||= begin
      input.split("mask = ").drop(1).map do |group|
        mask, values = group.split(/\n/, 2)

        [
          mask.chars.each_with_index.reject { |v, i| v == 'X' }.map do |v,i|
            [v.to_i, i]
          end,
          values.split(/\n/).map do |value|
            location, value = value.split(' = ')
            [location.match(/\d+/)[0].to_i, value.to_i]
          end
        ]
      end
    end
  end
end

class PartTwo < PartOne
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 165, PartOne.new(input).solution
    assert_equal 14553106347726, PartOne.new.solution
  end

  def test_part_two
  end

  def input
    <<~INPUT
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
    INPUT
  end
end
