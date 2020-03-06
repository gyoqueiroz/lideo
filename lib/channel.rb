class Channel
  attr_reader :name, :headlines

  def initialize(name, headlines)
    @name = name
    @headlines = headlines
  end

  def id
    @name.gsub(/[[:space:]]/, '')
  end
end
