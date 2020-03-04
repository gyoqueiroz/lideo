require 'cli'
require 'lideo_controller'

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
end
