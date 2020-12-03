require 'pry'
require 'minitest/autorun'
require 'pathname'

class Base
  def self.file_input(filename)
    @file_input ||=
      begin
        path = File.expand_path(File.dirname(__FILE__))
        File.read(Pathname.new(path).join(filename)).chomp.lines.map(&:chomp)
      end
  end
end
