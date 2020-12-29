require './base'

class PartOne
  def initialize(input = Base.raw_input('2017/06/input.txt'))
    @input = input
    @redistributions = []
    @redistribution = blocks
  end

  def solution
    redistribute
    @redistributions.size
  end

  private

  attr_reader :input

  def blocks
    @blocks ||= input.split.map(&:to_i)
  end

  def redistribute
    until @redistributions.include? @redistribution
      @redistributions << @redistribution
      @redistribution = Redistribution.new(blocks: @redistribution).()
    end
  end
end

class PartTwo < PartOne
  def solution
    redistribute
    @redistributions = []
    redistribute
    @redistributions.size
  end
end

class Redistribution
  attr_reader :blocks

  def initialize(blocks:)
    @blocks = blocks

    @remainder_to_distribute = blocks.max
    @distribution = blocks.max / (blocks.size - 1)
    @distribution = @distribution == 0 ? 1 : @distribution

    @rotation = blocks.index(blocks.max) + 1

    @rotated_blocks = blocks.rotate(@rotation)
  end

  def call
    @rotated_blocks.each_with_index.map do |block, i|
      if i + 1 == blocks.size
        @remainder_to_distribute
      else
        if @remainder_to_distribute > 0
          @remainder_to_distribute -= @distribution
          block + @distribution
        else
          block
        end
      end
    end.rotate(-@rotation)
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 5, PartOne.new(input).solution
    assert_equal 11137, PartOne.new.solution
  end

  def test_part_two
    assert_equal 4, PartTwo.new(input).solution
    assert_equal 1037, PartTwo.new.solution
  end

  def input
    <<~INPUT
      0 2 7 0
    INPUT
  end
end
