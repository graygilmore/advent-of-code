require './base'

class PartOne
  attr_reader :passphrases, :strict
  alias :strict? :strict

  def initialize(input = Base.raw_input('2017/04/input.txt'), strict: false)
    @passphrases = input.split(/\n/)
    @strict = strict
  end

  def solution
    valid_passwords_size
  end

  private

  attr_reader :input

  def valid_passwords_size
    passphrases.select do |passphrase|
      validate_passphrase(passphrase)
    end.size
  end

  def validate_passphrase(passphrase)
    words = passphrase.split(" ").map do |word|
      strict? ? word.chars.sort.join("") : word
    end
    words.detect{ |e| words.count(e) > 1 }.nil?
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 386, PartOne.new.solution
  end

  def test_part_two
    assert_equal 208, PartOne.new(strict: true).solution
  end

  def input
    <<~INPUT
    INPUT
  end
end
