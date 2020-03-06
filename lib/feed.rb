class Feed
  attr_reader :url, :group

  def initialize(url, group)
    @url = url
    @group = group
  end

  def ==(other)
    !other.nil? && @url == other.url && @group == other.group
  end

end
