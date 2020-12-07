require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/07/input.txt'))
    @input = input
  end

  def solution
    bag_rules.count do |color, included_bag_colors|
      bag_contains_gold?(color)
    end
  end

  def bag_contains_gold?(color)
    bag_rules[color]&.keys&.include?('shiny gold') || bag_rules[color]&.any? do |name, count|
      bag_contains_gold?(name)
    end
  end

  private

  attr_reader :input, :bag_rules

  def bag_rules
    @bag_rules ||= begin
      input.split(/\n/).map do |rule|
        outer_bag, inner_bags = rule.split('bags contain').map(&:strip)

        inner_bags.tr!('.', '')
        inner_bags.gsub!(/ bags?/, '')

        [
          outer_bag,
          inner_bags == "no other" ? {} : inner_bags.split(', ').map do |bag|
            count, color = bag.split(' ', 2)

            [
              color,
              count.to_i
            ]
          end.to_h
        ]
      end.to_h
    end
  end
end

class PartTwo < PartOne
  def solution
    @total_bags = 0
    count_bags('shiny gold')
    @total_bags
  end

  def count_bags(color)
    if bag_rules[color]&.any?
      colors = bag_rules[color]

      @total_bags += colors.values.sum

      colors.each { |name, count| count.times { count_bags(name) } }
    end
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 4, PartOne.new(
      <<~INPUT
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
      INPUT
    ).solution
    assert_equal 268, PartOne.new.solution
  end

  def test_part_two
    assert_equal 32, PartTwo.new(
      <<~INPUT
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
      INPUT
    ).solution
    assert_equal 126, PartTwo.new(
      <<~INPUT
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.
      INPUT
    ).solution
    assert_equal 7867, PartTwo.new.solution
  end
end
