require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/10/input.txt'), rounds: 1)
    @lengths = input.split(',').map(&:to_i)
    @list = (0..255).to_a
    @current_position = 0
    @skip_size = 0
    @rounds = rounds
  end

  def solution
    hashy
    @list[0] * @list[1]
  end

  private

  attr_reader :lengths

  def hashy
    (1..@rounds).to_a.each do |round|
      lengths.each do |length|
        @list.rotate!(@current_position)
        rotated_numbers = @list.slice(0, length).reverse
        @list.slice!(0, length)
        @list.insert(0, rotated_numbers).flatten!
        @list.rotate!(-@current_position)

        @current_position += length + @skip_size
        @current_position -= @list.size if @current_position > @list.size

        @skip_size += 1
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    @lengths = @lengths.join(",").chars.map { |length| length.to_s.ord } + [17, 31, 73, 47, 23]
    hashy
    dense_hash = @list.each_slice(16).map do |slice|
      slice.inject(0) { |acc, num| acc ^ num }
    end

    dense_hash.map { |d| "%02x" % d }.join("")
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 11375, PartOne.new.solution
  end

  def test_part_two
    assert_equal 'e0387e2ad112b7c2ef344e44885fe4d8', PartTwo.new(rounds: 64).solution
  end
end
