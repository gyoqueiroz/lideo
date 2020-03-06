class Headline
  attr_reader :title, :url, :channel

  def initialize(title, url, channel = '')
    @title = title
    @url = url
    @channel = channel
  end

  def ==(other)
    !other.nil? && @title == other.title && @url == other.url &&
      @channel == other.channel
  end

  def to_s
    "#{title} [#{url}]"
  end
end
