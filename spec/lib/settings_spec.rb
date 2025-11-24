require './lib/settings'

RSpec.describe Settings do
  context 'when settings file exists' do
    let(:expected_settings) do
      {
        'compressed' => false,
        'verify' => true,
        'clipboard' => false
      }
    end

    before do
      allow_any_instance_of(Settings).to receive(:params).and_return(expected_settings)
    end

    it 'returns parsed settings as symbols' do
      expect(Settings.call).to eq(expected_settings)
    end
  end

  context 'when settings file does not exist' do
    before do
      allow_any_instance_of(Settings).to receive(:params).and_raise(Errno::ENOENT)
    end

    it 'raises Errno::ENOENT' do
      expect { Settings.call }.to raise_error(Errno::ENOENT)
    end
  end
end
