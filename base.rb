require 'pry'
require 'minitest/autorun'
require "minitest/focus"
require 'pathname'

class Base
  def self.file_input(filename)
    @file_input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join(filename)).chomp.lines.map(&:chomp)
      end
  end

  def self.raw_input(filename)
    path = File.expand_path(File.dirname(__FILE__))
    File.read(Pathname.new(path).join(filename))
  end
end
