require 'pry'
require "minitest/autorun"
require 'pathname'

class PartOne
  def initialize(map = input)
    @map = map
    @orbits = {}
    @orbit_count = 0
  end

  def solution
    format_orbits
    @orbits.each do |inner, outers|
      outers.each { track_back(inner) }
    end

    @orbit_count
  end

  private

  def format_orbits
    @map.each do |foo|
      bar = foo.split(")")

      if @orbits[bar[0]]
        @orbits[bar[0]].push(bar[1])
      else
        @orbits[bar[0]] = [bar[1]]
      end
    end
  end

  def track_back(value)
    @orbit_count += 1
    more = @orbits.find { |inner, outers| outers.include?(value) }
    track_back(more[0]) if more&[0]
  end

  def input
    @input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join("input.txt")).chomp.lines.map(&:chomp)
      end
  end
end

class PartTwo < PartOne
  def solution
    format_orbits

    my_path = build_path(inner_node("YOU"))
    santas_path = build_path(inner_node("SAN"))

    common_node = (my_path & santas_path).first
    my_path.index(common_node) + santas_path.index(common_node)
  end

  private

  def inner_node(outer)
    @orbits.find { |_inner, outers| outers.include?(outer) }&.first
  end

  def build_path(value, path = [])
    path << value
    next_node = inner_node(value)

    if next_node
      build_path(next_node, path)
    else
      path
    end
  end
end

class TestFuel < Minitest::Test
  def test_part_one
    assert_equal 42, PartOne.new(
      [
        'COM)B',
        'B)C',
        'C)D',
        'D)E',
        'E)F',
        'B)G',
        'G)H',
        'D)I',
        'E)J',
        'J)K',
        'K)L'
      ]
    ).solution
  end

  def test_part_two
    assert_equal 4, PartTwo.new(
      [
        'COM)B',
        'B)C',
        'C)D',
        'D)E',
        'E)F',
        'B)G',
        'G)H',
        'D)I',
        'E)J',
        'J)K',
        'K)L',
        'K)YOU',
        'I)SAN'
      ]
    ).solution
  end
end

puts "Part One: #{::PartOne.new.solution}"
puts "Part One: #{::PartTwo.new.solution}"
