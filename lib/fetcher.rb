require 'headline'
require 'rss'
require 'open-uri'
require 'rss/atom'

class Fetcher
  def fetch(feed)
    open(feed.url) do |rss|
      fetched = RSS::Parser.parse(rss)
      fetched.items.map do |item|
        title = fetched.is_a?(RSS::Atom::Feed) ? item.title.content : item.title
        link = fetched.is_a?(RSS::Atom::Feed) ? item.link.href : item.link
        channel = fetched.is_a?(RSS::Atom::Feed) ? fetched.author.name.content : fetched.channel.title

        Headline.new(title, link, channel)
      end
    end
  end
end
