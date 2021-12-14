require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/14/input.txt'))
    @input = input
    @pair_counts = Hash.new(0)
    @counts = Hash.new(0)
  end

  def solution
    @counts.merge!(starter.tally)

    starter.each_cons(2) do |c|
      @pair_counts[c] += 1
    end

    10.times { add_pairs }

    min, max = @counts.values.minmax
    max - min
  end

  private

  attr_reader :input

  def starter
    input.split("\n\n")[0].chomp.chars
  end

  def add_pairs
    new_count = Hash.new(0)
    @pair_counts.each do |pair, value|
      pair_double[pair].each { |v| new_count[v] += value }
      @counts[pair_single[pair]] += value
    end
    @pair_counts = new_count
  end

  def pair_double
    @pair_double ||= begin
      obj = {}
      pair_single.keys.each do |v|
        obj[v] = [[v[0], pair_single[v]], [pair_single[v], v[1]]]
      end
      obj
    end
  end

  def pair_single
    @pair_map ||= begin
      obj = {}
      input.split("\n\n")[1].lines.map do |line|
        pair, result = line.chomp.split(' -> ')
        obj[pair.chars] = result
      end
      obj
    end
  end
end

class PartTwo < PartOne
  def solution
    @counts.merge!(starter.tally)

    starter.each_cons(2) do |c|
      @pair_counts[c] += 1
    end

    40.times { add_pairs }

    min, max = @counts.values.minmax
    max - min
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 1588, PartOne.new(input).solution
    assert_equal 2360, PartOne.new.solution
  end

  def test_part_two
    assert_equal 2188189693529, PartTwo.new(input).solution
    assert_equal 2967977072188, PartTwo.new.solution
  end

  def input
    <<~INPUT
      NNCB

      CH -> B
      HH -> N
      CB -> H
      NH -> C
      HB -> C
      HC -> B
      HN -> C
      NN -> C
      BH -> H
      NC -> B
      NB -> B
      BN -> B
      BB -> N
      BC -> B
      CC -> N
      CN -> C
    INPUT
  end
end
