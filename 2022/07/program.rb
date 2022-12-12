require './base'

class PartOne
  def initialize(input = Base.raw_input('2022/07/input.txt'))
    @input = input
    @folders = {
      ["/"] => {
        files: [],
        folders: [],
      }
    }

    generate_folders
  end

  def solution
    folders.sum do |folder|
      f_sum = sum_folder(folder[0], folder[1])
      f_sum > 100000 ? 0 : f_sum
    end
  end

  private

  attr_reader :input, :folders

  def input_lines
    @input_lines ||= input.lines.map(&:chomp)
  end

  def sum_folder(pwd, contents)
    files_sum = contents[:files].sum
    sub_sum = contents[:folders].sum do |f|
      next_pwd = pwd + [f]
      sum_folder(next_pwd, folders[next_pwd])
    end
    sub_sum + files_sum
  end

  def populate_dir(pwd, index)
    line = input_lines[index]

    return if line.nil? || line.match?(/\$ (cd|ls)\s?(.*)/)

    if line.match?(/^dir/)
      new_dir = line.split("dir ")[1]
      folders[pwd + [new_dir]] = {
        files: [],
        folders: [],
      }
      folders[pwd][:folders].push(new_dir)
    else
      folders[pwd][:files].push(line.split(" ")[0].to_i)
    end

    populate_dir(pwd, index + 1)
  end

  def generate_folders
    pwd = []

    input_lines.each.with_index do |line, index|
      command_match = line.match(/\$ (cd|ls)\s?(.*)/)

      next unless command_match

      command, argument = command_match.captures

      if command == "cd"
        if argument == ".."
          pwd.pop
        else
          pwd.push(argument)
        end
      elsif command == "ls"
        populate_dir(pwd, index + 1)
      end
    end
  end
end

class PartTwo < PartOne
  def solution
    total_space = 70000000
    needed_space = 30000000
    root_dir_space = sum_folder(["/"], folders[["/"]])
    unused_space = total_space - root_dir_space
    amount_to_delete = 30000000 - unused_space
    sums = []

    folders.each do |folder|
      f_sum = sum_folder(folder[0], folder[1])
      if f_sum >= amount_to_delete
        sums.push(f_sum)
      end
    end

    sums.min
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 95437, PartOne.new(input).solution
    assert_equal 1348005, PartOne.new.solution
  end

  def test_part_two
    assert_equal 24933642, PartTwo.new(input).solution
    assert_equal 12785886, PartTwo.new.solution
  end

  def input
    <<~INPUT
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
    INPUT
  end
end
