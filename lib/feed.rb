class Feed
  attr_reader :url, :group

  def initialize(url, group)
    @url = url
    @group = group
  end

  def ==(other)
    !other.nil? && @url == other.url && @group == other.group
  end

  def to_s
    "[#{@group}] #{@url}"
  end

end
