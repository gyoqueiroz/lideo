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
    context 'and a group is passed' do
      let(:feeds) { [feed_1, feed_2].freeze }
      let(:headline) { Headline.new('Title', 'url', 'channel1') }
      let(:headline1) { Headline.new('Title1', 'url1', 'channel2') }
      let(:headlines) { [headline, headline1].freeze }
      let(:headlines_grouped_by_channel) { headlines.group_by(&:channel) }

      it 'get the list of feeds and fetches the headlines grouped by channel' do
        allow(dao_double).to receive(:find).with('group').and_return(feeds)
        allow(fetcher_double).to receive(:fetch).with(feed_1).and_return([headline])
        allow(fetcher_double).to receive(:fetch).with(feed_2).and_return([headline1])

        expect(subject.fetch('group')).to eq(headlines_grouped_by_channel)
      end
    end

    context 'and there are no feeds in the DB' do
      it 'returns an empty array' do
        allow(dao_double).to receive(:find).with('group').and_return([])

        expect(subject.fetch('group')).to eq({})
      end
    end
  end
end
