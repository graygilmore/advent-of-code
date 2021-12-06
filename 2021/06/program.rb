require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/06/input.txt'), days: 80)
    @input = input.chomp.split(',').map(&:to_i)
    @days = days
  end

  def solution
    fish = input.tally

    days.times do
      new_fish = Hash.new(0)

      fish.each do |k, v|
        if k == 0
          new_fish[6] += v
          new_fish[8] += v
        else
          new_fish[k - 1] += v
        end
      end

      fish = new_fish
    end

    fish.values.sum
  end

  private

  attr_reader :input, :days
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 26, PartOne.new(input, days: 18).solution
    assert_equal 5934, PartOne.new(input).solution
    assert_equal 390923, PartOne.new.solution
  end

  def test_part_two
    assert_equal 26984457539, PartOne.new(input, days: 256).solution
    assert_equal 1749945484935, PartOne.new(days: 256).solution
  end

  def input
    <<~INPUT
      3,4,3,1,2
    INPUT
  end
end
