require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/03/input.txt'))
    @input = input
  end

  def solution
    gamma = ''
    epsilon = ''

    b_length = binaries.first.length - 1

    (0..b_length).each do |i|
      b = binaries.map { _1[i] }.tally
      if b['0'] > b['1']
        gamma += '0'
        epsilon += '1'
      else
        gamma += '1'
        epsilon += '0'
      end
    end

    gamma.to_i(2) * epsilon.to_i(2)
  end

  private

  attr_reader :input

  def binaries
    @binaries ||= input.chomp.lines.map(&:chomp)
  end
end

class PartTwo < PartOne
  def solution
    oxygen = filter_binaries(binaries)
    c02 = filter_binaries(binaries, 0, false)

    oxygen.to_i(2) * c02.to_i(2)
  end

  def filter_binaries(bins, index = 0, max = true)
    if bins.size == 1
      return bins.first
    end

    filtered = bins.select do |b|
      tallied = bins.map { _1[index] }.tally

      if tallied['0'] > tallied['1']
        max ? b[index] == '0' : b[index] == '1'
      else
        max ? b[index] == '1' : b[index] == '0'
      end
    end

    filter_binaries(filtered, index + 1, max)
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 198, PartOne.new(input).solution
    assert_equal 3242606, PartOne.new.solution
  end

  def test_part_two
    assert_equal 230, PartTwo.new(input).solution
    assert_equal 4856080, PartTwo.new.solution
  end

  def input
    <<~INPUT
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    INPUT
  end
end
