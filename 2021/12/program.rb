require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/12/input.txt'))
    @input = input
    @complete_paths = []
  end

  def solution
    build_paths("start", [], [])
    # binding.pry
    @complete_paths.size
  end

  private

  attr_reader :input

  def paths
    @paths ||= begin
      obj = Hash.new()
      input.lines.each { |line|
        f, b = line.chomp.split('-')

        obj[f] = obj[f] ? obj[f].push(b).uniq : [b]
        obj[b] = obj[b] ? obj[b].push(f).uniq : [f]
      }
      obj
    end
  end

  def build_paths(cave, path, visited_small_caves)
    new_path = path.dup
    new_visited_paths = visited_small_caves.dup
    new_path << cave
    # binding.pry

    if cave.downcase == cave && !["start", "end"].include?(cave)
      new_visited_paths << cave
    end

    # binding.pry

    paths[cave].each do |next_cave|
      next if next_cave == "start"
      # binding.pry
      if new_visited_paths.tally.any? { |k,v| v == 2 }
        next if new_visited_paths.tally[next_cave] == 2 || new_visited_paths.tally[next_cave] == 1
      end

      # binding.pry

      if next_cave == "end"
        new_path << next_cave
        @complete_paths << new_path
        next
      else
        # binding.pry
        build_paths(next_cave, new_path, new_visited_paths)
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    build_paths("start", [], [])
    # binding.pry
    @complete_paths.size
  end
end

class Test < Minitest::Test
  def test_part_one
    # assert_equal 10, PartOne.new(input).solution
    # assert_equal 19, PartOne.new(large_input).solution
    # assert_equal 226, PartOne.new(biggest_input).solution
    # assert_equal 5104, PartOne.new.solution
  end

  def test_part_two
    assert_equal 36, PartTwo.new(input).solution
    assert_equal 103, PartOne.new(large_input).solution
    assert_equal 3509, PartOne.new(biggest_input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
    INPUT
  end

  def large_input
    <<~INPUT
      dc-end
      HN-start
      start-kj
      dc-start
      dc-HN
      LN-dc
      HN-end
      kj-sa
      kj-HN
      kj-dc
    INPUT
  end

  def biggest_input
    <<~INPUT
      fs-end
      he-DX
      fs-he
      start-DX
      pj-DX
      end-zg
      zg-sl
      zg-pj
      pj-he
      RW-he
      fs-DX
      pj-RW
      zg-RW
      start-pj
      he-WI
      zg-he
      pj-fs
      start-RW
    INPUT
  end
end
