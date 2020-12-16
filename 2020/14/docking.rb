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
        masked_locations.reject { |v, i| v == 'X' }.each { |value, location| bits_value[location] = value }
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
          mask.chars.each_with_index.map do |v,i|
            [v, i]
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
  def solution
    memory = {}

    mask_groups.each do |mask, values_to_write|
      values_to_write.each do |location, value|
        bits_location = '%0*b' % [36, location]
        mask.reject { |v, i| v == "0" }.each do |value, location|
          bits_location[location] = value == "1" ? "1" : "X"
        end

        floating_values = bits_location.count("X")
        (0..2**floating_values-1).map { |i| '%0*b' % [floating_values, i] }.each do |permutation|
          address = bits_location.dup
          permutation.chars.each { |p| address[address.chars.find_index('X')] = p }
          memory[address.to_i(2)] = value
        end
      end
    end

    memory.values.sum
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 165, PartOne.new(input).solution
    assert_equal 14553106347726, PartOne.new.solution
  end

  def test_part_two
    assert_equal 208, PartTwo.new(input_two).solution
    assert_equal 2737766154126, PartTwo.new.solution
  end

  def input
    <<~INPUT
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
    INPUT
  end

  def input_two
    <<~INPUT
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
    INPUT
  end
end
