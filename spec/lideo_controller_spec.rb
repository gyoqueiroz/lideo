# frozen_string_literal: true

require 'lideo_controller'
require 'lideo_dao'
require 'feed'
require 'fetcher'

describe LideoController do
  let(:dao_double) { double(LideoDao) }
  let(:fetcher_double) { double(Fetcher) }
  let(:feed_1) { Feed.new('url', 'group') }
  let(:feed_2) { Feed.new('url1', 'group1') }
  let(:feeds) { [feed_1, feed_2].freeze }

  before do
    allow(LideoDao).to receive(:new).and_return(dao_double)
    allow(Fetcher).to receive(:new).and_return(fetcher_double)
  end

  context 'when #add is called' do
    context 'and a valid feed is passed' do
      it 'calls the dao to save the new feed' do
        allow(dao_double).to receive(:save).with(feed_1)

        subject.add('url', 'group')
      end
    end
  end

  context 'when #fetch is called' do
    let(:headline) { Headline.new('Title', 'url', 'channel1') }
    let(:headline1) { Headline.new('Title1', 'url1', 'channel2') }
    let(:headlines) { [headline, headline1].freeze }
    let(:headlines_grouped_by_channel) { headlines.group_by(&:channel) }

    before do
      allow(fetcher_double).to receive(:fetch).with(feed_1).and_return([headline])
      allow(fetcher_double).to receive(:fetch).with(feed_2).and_return([headline1])
    end

    context 'and a group is passed' do
      it 'get the list of feeds and fetches the headlines grouped by channel' do
        allow(dao_double).to receive(:find).with('group').and_return(feeds)

        expect(subject.fetch('group')).to eq(headlines_grouped_by_channel)
      end
    end

    context 'and all groups are requested' do
      it 'fetches all the existing feeds' do
        allow(dao_double).to receive(:all).and_return(feeds)

        expect(subject.fetch('all')).to eq(headlines_grouped_by_channel)
      end
    end

    context 'and there are no feeds in the DB' do
      it 'returns an empty array' do
        allow(dao_double).to receive(:find).with('group').and_return([])

        expect(subject.fetch('group')).to eq({})
      end
    end
  end

  context 'when #feeds is called' do
    context 'and there is one or more feeds in the DB' do
      it 'calls the dao and receives a list of feeds' do
        allow(dao_double).to receive(:all).and_return(feeds)

        expect(subject.feeds).to eq(feeds)
      end
    end

    context 'and the database is empty' do
      it 'calls the dao and returns an empty array' do
        allow(dao_double).to receive(:all).and_return([])

        expect(subject.feeds).to eq([])
      end
    end
  end

  context 'when #remove_feeds is called' do
    it 'calls the dao passing the url of the feed to be removed' do
      allow(dao_double).to receive(:delete_feed).with('url')

      expect { subject.remove_feed('url') }.not_to raise_error
    end
  end
end
