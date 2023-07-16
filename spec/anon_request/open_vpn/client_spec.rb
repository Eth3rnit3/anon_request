# frozen_string_literal: true

RSpec.describe AnonRequest::OpenVpn::Client do
  let(:sudo_passs) { 'my_pass' }
  let(:config_file) { AnonRequest.configuration.open_vpn_config_files.first }
  let(:client) { described_class.instance }

  before do
    AnonRequest.configure do |config|
      config.sudo_password = sudo_passs
      config.open_vpn_config_file = 'config/open_vpn.test.yml'
    end

    Singleton.__init__(described_class)
  end

  describe '#run' do
    context 'when config_file exists' do
      it { expect { client.run(config_file) }.not_to raise_error(AnonRequest::OpenVpn::NoConfigFilerror) }
    end

    context 'when sudo pass is given' do
      it { expect { client.run(config_file) }.not_to raise_error(AnonRequest::OpenVpn::NoPasswodError) }
    end

    context 'when sudo pass is nil' do
      let(:sudo_passs) { nil }

      it { expect { client.run(config_file) }.not_to raise_error(AnonRequest::OpenVpn::NoPasswodError) }
    end

    context 'when config_file not exists' do
      let(:config_file) { nil }

      it { expect { client.run(config_file) }.to raise_error(AnonRequest::OpenVpn::NoConfigFilerror) }
    end
  end
end
