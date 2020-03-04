require 'thor'
require 'rubygems'

class Cli < Thor
  map %w[--version -v] => :__print_version

  desc '--version -v', 'Prints the current version'

  def __print_version
    spec = Gem::Specification.load('lideo.gemspec')
    puts spec.version
  end
end
