class LideoDao
  def save(feed)
    puts "Saved feed -> #{feed}"
  end

  def find(group)
    [
      Feed.new('http://feeds.bbci.co.uk/news/rss.xml', group),
      Feed.new('http://rss.slashdot.org/Slashdot/slashdot', group)
    ].freeze
  end
end
