require 'headline'
require 'rss'
require 'open-uri'

class Fetcher
  def fetch(feed)
    open(feed.url) do |rss|
      fetched = RSS::Parser.parse(rss)
      fetched.items.map do |item|
        Headline.new(item.title, item.link, fetched.channel.title)
      end
    end
  end
end
