# frozen_string_literal: true
require 'feed'
require 'lideo_dao'
require 'fetcher'

class LideoController
  def add(url, group)
    LideoDao.new.save(Feed.new(url, group))
  end

  def fetch(group)
    LideoDao.new.find(group)
            .map { |feed| fetcher.fetch(feed) }
            .flatten
            .group_by(&:channel)
  end

  def feeds
    []
  end

  private

  def fetcher
    @fetcher ||= Fetcher.new
  end

  def save_to_file(headlines)
    nil
  end
end
