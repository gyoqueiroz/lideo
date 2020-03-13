require 'cli'
require 'lideo_controller'
require 'headline'

describe Cli do
  let(:controller_double) { double(LideoController) }
  let(:valid_url) { 'http://avalidurl.com' }

  before do
    allow(LideoController).to receive(:new).and_return(controller_double)
  end

  context 'when #add is called' do
    context 'with a valid URL' do
      context 'and a given group' do
        before do
          allow(subject).to receive(:options) { { 'g': 'group' } }
        end

        it 'calls the controller to save the new URL' do
          allow(controller_double).to receive(:add).with(valid_url, 'group')

          expect { subject.add(valid_url) }.not_to raise_error
        end
      end

      context 'and no group' do
        it 'sets group \'default\' then calls controller to save the new URL' do
          allow(controller_double).to receive(:add).with(valid_url, 'default')

          expect { subject.add(valid_url) }.not_to raise_error
        end
      end

      context 'and the feed is broken' do
        it 'prints out an errors message and does not add the feed' do
          output_str = 'A test fetch failed for the feed and as such it won\'t be added.'
          expect { subject.add(valid_url) }
            .to output(/#{output_regex(output_str)}/).to_stdout
        end
      end
    end

    context 'with an invalid URL' do
      it 'prints out an error message' do
        expect { subject.add('invalid_url') }
          .to output("Invalid URL\n").to_stdout
      end
    end
  end

  context 'when #fetch is called' do
    let(:headlines) { [Headline.new('title', 'url', 'channel')].freeze }
    let(:headlines_grouped_by_channel) { headlines.group_by(&:channel) }
    let(:headline_str) { "#{headlines.first.channel}\n  > #{headlines.first}" }

    context 'and there is at least one URL in the DB' do
      context 'and no group is passed' do
        before do
          allow(subject).to receive(:options) { {} }
        end

        it 'calls controller with \'default\' group and prints the headlines' do
          allow(controller_double).to receive(:fetch).with('default')
                                                     .and_return(headlines_grouped_by_channel)

          expect { subject.fetch }.to output(/#{output_regex(headline_str)}/).to_stdout
        end
      end

      context 'and a group is passed' do
        before do
          allow(subject).to receive(:options) { { 'g': 'group' } }
        end

        it 'calls the controller with given group and prints the headlines' do
          allow(controller_double).to receive(:fetch).with('group').and_return(headlines_grouped_by_channel)

          expect { subject.fetch }.to output(/#{output_regex(headline_str)}/).to_stdout
        end
      end
    end

    context 'and the DB is empty' do
      it 'prints out no records info message' do
        allow(controller_double).to receive(:fetch).and_return([])

        output_str = "No news for you this time\n"
        expect { subject.fetch }.to output(/#{output_regex(output_str)}/).to_stdout
      end
    end
  end

  context 'when #feeds is called' do
    context 'and there is one or more feeds in the DB' do
      let(:feeds) { [Feed.new('url', 'group')] }
      it 'prints out the list of feeds in the console' do
        allow(controller_double).to receive(:feeds).and_return(feeds)

        expect { subject.feeds }.to output(/#{output_regex(feeds.first.to_s)}/).to_stdout
      end
    end

    context 'and the DB is empty' do
      it 'prints out no records info message' do
        allow(controller_double).to receive(:feeds).and_return([])
        msg = 'You have not added any feeds yet'

        expect { subject.feeds }.to output(/#{output_regex(msg)}/).to_stdout
      end
    end

    context 'with -r flag' do
      context 'and there is a matching feed in the DB' do
        before do
          allow(subject).to receive(:options) { { 'r': 'url' } }
        end

        it 'it calls the controller to remove the feed' do
          allow(controller_double).to receive(:remove_feed).with('url')

          expect { subject.feeds }.not_to raise_error
        end
      end
    end
  end

  def output_regex(value)
    Regexp.quote(value)
  end
end
