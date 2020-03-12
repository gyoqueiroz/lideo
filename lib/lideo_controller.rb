# frozen_string_literal: true
require 'feed'
require 'lideo_dao'
require 'fetcher'

class LideoController
  def add(url, group)
    LideoDao.new.save(Feed.new(url, group))
  end

  def fetch(group)
    feeds = group.downcase == 'all' ? LideoDao.new.all : LideoDao.new.find(group)
    feeds.map { |feed| fetcher.fetch(feed) }
         .flatten
         .group_by(&:channel)
  end

  def feeds
    LideoDao.new.all
  end

  def remove_feed(url)
    LideoDao.new.delete_feed(url)
  end

  private

  def fetcher
    @fetcher ||= Fetcher.new
  end

  def save_to_file(headlines)
    nil
  end
end
