require 'thor'
require 'rubygems'
require 'lideo_controller'
require 'html'

BANNER = "+-+-+-+-+-+ +-+-+-+\n" +
  "|L|i|d|e|o| |R|S|S|\n" +
  "+-+-+-+-+-+ +-+-+-+\n"

class Cli < Thor
  map %w[--version -v] => :__print_version

  desc '--version -v', 'Prints the current version'

  def __print_version
    puts version
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

  desc 'fetch', 'Fetches and prints out the headlines of your feeds. Use -g flag to specify a group.'
  long_desc <<-LONGDESC
    Fetches and prints out the headlines of your feeds. Available flags:
    
    With -g            Fetches feeds for the specified group only

    With --to [OPTION] Fetches the feeds and outputs to the method specified in the option parameter. If omitted will output to the console.
                       Available options: 
                       
                       HTML
  LONGDESC
  options g: :string
  options to: :string

  def fetch
    headlines = LideoController.new.fetch(group(options))
    puts 'No news for you this time' if headlines.empty?

    export_html(headlines) && return if
      options[:to] && options[:to].downcase == 'html'

    puts "#{banner}#{format_headlines_output(headlines)}" unless headlines.empty? || !options[:to].nil?
  end

  desc 'feeds', 'Outputs a list of your feeds'

  def feeds
    s = StringIO.new
    LideoController.new.feeds.map { |feed| s << "#{feed.to_s}\n" }
    output = !s.string.empty? ? s.string : 'You have not added any feeds yet'
    puts output
  end

  private

  def export_html(headlines)
    puts Html.new.export(headlines)
  end

  def group(options)
    options[:g].nil? || options[:g].empty? ? 'default' : options[:g]
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def version
    @version ||= Gem::Specification.load('lideo.gemspec').version
  end

  def banner
    s = StringIO.new
    s << BANNER
    s << "#{version}\n"
    s.string
  end

  def format_headlines_output(headlines_grouped)
    s = StringIO.new
    headlines_grouped.each_key do |channel|
      s << "\n#{channel}\n"
      headlines_grouped[channel].each do |headline|
        s << "  > #{headline}\n"
      end
    end
    s.string
  end
end
