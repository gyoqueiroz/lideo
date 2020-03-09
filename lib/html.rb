require 'mustache'
require 'channel'

class Html
  HOME_FOLDER = File.expand_path('~')

  def export(headlines)
    Mustache.template_file = File.dirname(__FILE__) + '/templates/news_feed.mustache'
    view = Mustache.new
    view[:channels] = to_channel_array(headlines)
    puts view[:channels].to_s
    view[:generated_at] = Time.now.strftime('%d/%m/%Y %H:%M')

    file_name = "#{HOME_FOLDER}/lideo_news_feed.html"
    open(file_name, 'w') { |f|
      f.write(view.render)
    }

    file_name
  end

  def to_channel_array(headlines)
    headlines.collect { |key, value| Channel.new(key, value) }
  end
end
