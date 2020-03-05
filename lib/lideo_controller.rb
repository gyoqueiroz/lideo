# frozen_string_literal: true

class LideoController
  def add(url, group)
    puts "#{url} #{group}"
  end

  def fetch(group)
    ['Headline']
  end
end
