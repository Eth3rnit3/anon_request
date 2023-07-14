RSpec.describe AnonRequest::OpenVpn::Client do
  let(:sudo_passs) { 'my_pass' }
  let(:config_file) { 'my_pass' }
  let(:client) { described_class.instance }

  before do
    AnonRequest.configure do |config|
      config.sudo_password = sudo_passs
    end

    Singleton.__init__(described_class)
  end

  context 'when sudo pass is given' do
    it { expect { client.run(config_file) }.not_to raise_error(AnonRequest::OpenVpn::NoPasswodError) }
  end

  context 'when sudo pass is nil' do
    let(:sudo_passs) { nil }

    it { expect { client.run(config_file) }.to raise_error(AnonRequest::OpenVpn::NoPasswodError) }
  end

  context 'when config_file exists' do
    let(:config_file) { __FILE__ }

    it { expect { client.run(config_file) }.not_to raise_error(AnonRequest::OpenVpn::NoConfigFilerror) }
  end

  context 'when config_file is nil' do
    let(:config_file) { nil }

    it { expect { client.run(config_file) }.to raise_error(AnonRequest::OpenVpn::NoConfigFilerror) }
  end

  context 'when config_file not exists' do
    let(:config_file) { '/tmp/invalid-file-it-not-exist.ovpn' }

    it { expect { client.run(config_file) }.to raise_error(AnonRequest::OpenVpn::NoConfigFilerror) }
  end
end