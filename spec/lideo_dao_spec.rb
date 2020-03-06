require 'lideo_dao'
require 'pstore'
require 'feed'

describe LideoDao do
  let(:pstore_double) { double(PStore) }
  let(:feed) { Feed.new('url', 'group') }

  before do
    expect(pstore_double).to receive(:transaction)
    allow(PStore).to receive(:new).with(LideoDao::FULL_DB_FILE_PATH)
      .and_return(pstore_double)
  end

  context 'when #save is called' do
    before do
      allow(pstore_double).to receive(:[]=).with('url', feed).and_return(nil)
      allow(pstore_double).to receive(:transaction).and_yield(pstore_double)
    end

    it 'persists the feed in the DB' do
      expect { subject.save(feed) }.not_to raise_error
    end
  end

  context 'given #find is called' do
    before do
      allow(pstore_double).to receive(:transaction).with(true).and_yield
      allow(pstore_double).to receive(:roots)
        .and_return(['url'])
      allow(pstore_double).to receive(:[]).with('url')
        .and_return(feed)
    end

    it 'returns feeds for the given group' do
      expect(subject.find('group')).to eq([feed])
    end

    it 'returns empty array when no work logs found for the given date' do
      expect(subject.find('empty_group')).to eq([])
    end
  end
end
