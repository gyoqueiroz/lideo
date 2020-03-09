require 'pstore'

class LideoDao
  DB_FILE_NAME = 'lideo.pstore'
  DB_FOLDER = '.lideo'
  HOME_FOLDER = File.expand_path('~')
  FULL_DB_FILE_PATH = "#{HOME_FOLDER}/#{DB_FOLDER}/#{DB_FILE_NAME}"

  def initialize
    db_folder_full_path = "#{HOME_FOLDER}/#{DB_FOLDER}"
    unless File.directory?(db_folder_full_path)
      FileUtils.mkdir_p(db_folder_full_path)
    end
  end

  def save(feed)
    PStore.new(FULL_DB_FILE_PATH).transaction { |store| store[feed.url] = feed }
  end

  def find(group)
    store = PStore.new(FULL_DB_FILE_PATH)
    list = []
    store.transaction(true) do
      store.roots
        .map { |root| list << store[root] if store[root].group == group }
    end
    list
  end

  def all
    store = PStore.new(FULL_DB_FILE_PATH)
    list = []
    store.transaction(true) do
      store.roots.map { |root| list << store[root] }
    end
    list
  end
end
