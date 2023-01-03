require './base'

class Monkey
  def initialize(items:)
    @items = items
    @inspections = 0
  end
  attr_accessor :items, :inspections

  def create_method(name, &block)
    define_singleton_method(name, &block)
  end
end

class PartOne
  def initialize(input = Base.raw_input('2022/11/input.txt'), rounds: 20)
    @input = input
    @rounds = rounds
    @monkeys = []
    format_monkeys
  end

  def solution
    @rounds.times do |round|
      @monkeys.each do |monkey|
        item_count = monkey.items.size
        item_count.times do
          monkey.inspect_item
          removed_item, next_monkey = monkey.test_item
          @monkeys[next_monkey].items << removed_item
        end
      end
    end

    @monkeys.map(&:inspections).max(2).inject(:*)
  end

  private

  attr_reader :input

  def format_monkeys
    input.split("\n\n").map(&:lines).map.with_index do |info, index|
      initial_items = info[1].scan(/(\d+)/).flatten.map(&:to_i)
      operation, value = info[2].strip.split("Operation: ")[1].scan(/new = old (\+|\*) (\d+|old)/).flatten
      division_check = info[3].strip.match(/\d+/)[0].to_i
      true_monkey = info[4].strip.match(/\d+/)[0].to_i
      false_monkey = info[5].strip.match(/\d+/)[0].to_i

      monkey = Monkey.new(items: initial_items)
      if operation == "+"
        monkey.create_method("inspect_item") do
          monkey.inspections += 1
          items[0] += value == "old" ? items[0] : value.to_i
          items[0] = items[0] / 3
        end
      else
        monkey.create_method("inspect_item") do
          monkey.inspections += 1
          items[0] *= value == "old" ? items[0] : value.to_i
          items[0] = items[0] / 3
        end
      end

      monkey.create_method("test_item") do
        item = monkey.items.shift
        next_monkey = item % division_check == 0 ? true_monkey : false_monkey
        [item, next_monkey]
      end

      @monkeys << monkey
    end
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 10605, PartOne.new(input).solution
    assert_equal 62491, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3

      Monkey 1:
        Starting items: 54, 65, 75, 74
        Operation: new = old + 6
        Test: divisible by 19
          If true: throw to monkey 2
          If false: throw to monkey 0

      Monkey 2:
        Starting items: 79, 60, 97
        Operation: new = old * old
        Test: divisible by 13
          If true: throw to monkey 1
          If false: throw to monkey 3

      Monkey 3:
        Starting items: 74
        Operation: new = old + 3
        Test: divisible by 17
          If true: throw to monkey 0
          If false: throw to monkey 1
    INPUT
  end
end
