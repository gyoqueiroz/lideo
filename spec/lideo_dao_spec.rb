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

  context 'given #all is called' do
    before do
      allow(pstore_double).to receive(:transaction).with(true).and_yield
      allow(pstore_double).to receive(:roots).and_return([feed])
      allow(pstore_double).to receive(:[]).with(feed)
        .and_return(feed)
    end

    context 'and there is one or more feed in the DB' do
      it 'returns a list of feeds' do
        expect(subject.all).to eq([feed])
      end
    end
  end

  context 'given #delete is called' do
    let(:feed) { Feed.new('url', 'group') }

    before do
      allow(pstore_double).to receive(:transaction).and_yield(pstore_double)
    end

    context 'when the feed exists' do
      it 'should call #PStore.delete' do
        allow(pstore_double).to receive(:delete).with('url')
        allow(pstore_double).to receive(:[]).with('url').and_return(feed)

        subject.delete_feed('url')
      end
    end

    context 'when the feed does not exist' do
      it 'raises an exception' do
        allow(pstore_double).to receive(:[]).with('url').and_return(nil)

        expect { subject.delete_feed('url') }.to raise_exception(Exception, 'Feed url not found')
      end
    end
  end
end
