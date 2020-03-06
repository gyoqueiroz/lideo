require 'cli'
require 'lideo_controller'
require 'headline'

describe Cli do
  let(:controller_double) { double(LideoController) }

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
          valid_url = 'http://avalidurl.com'
          allow(controller_double).to receive(:add).with(valid_url, 'group')

          expect { subject.add(valid_url) }.not_to raise_error
        end
      end

      context 'and no group' do
        it 'sets group \'default\' then calls controller to save the new URL' do
          valid_url = 'http://avalidurl.com'
          allow(controller_double).to receive(:add).with(valid_url, 'default')

          expect { subject.add(valid_url) }.not_to raise_error
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
          allow(controller_double).to receive(:fetch).with('default').and_return(headlines_grouped_by_channel)

          expect { subject.fetch }.to output(/#{Regexp.quote(headline_str)}/).to_stdout
        end
      end

      context 'and a group is passed' do
        before do
          allow(subject).to receive(:options) { { 'g': 'group' } }
        end

        it 'calls the controller with given group and prints the headlines' do
          allow(controller_double).to receive(:fetch).with('group').and_return(headlines_grouped_by_channel)

          expect { subject.fetch }.to output(/#{Regexp.quote(headline_str)}/).to_stdout
        end
      end
    end

    context 'and the DB is empty' do
      it 'prints out no records info message' do
        allow(controller_double).to receive(:fetch).and_return([])

        output_str = "No news for you this time\n"
        expect { subject.fetch }.to output(/#{Regexp.quote(output_str)}/).to_stdout
      end
    end
  end
end
