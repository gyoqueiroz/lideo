require 'thor'
require 'rubygems'
require 'lideo_controller'

class Cli < Thor
  map %w[--version -v] => :__print_version

  desc '--version -v', 'Prints the current version'

  def __print_version
    spec = Gem::Specification.load('lideo.gemspec')
    puts spec.version
  end

  desc 'add [URL]', 'Adds an RSS feed url. Use -g flag to specify a group.'
  options g: :string
  def add(url)
    unless valid_url?(url)
      puts 'Invalid URL'
      return
    end

    LideoController.new.add(url, group(options))
  end

  options g: :string
  def fetch
    headlines = LideoController.new.fetch(group(options))
    puts headlines.empty? ? "No RSS URL's found" : headlines
  end

  private

  def group(options)
    options[:g].nil? || options[:g].empty? ? 'default' : options[:g]
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
    false
  end
end
