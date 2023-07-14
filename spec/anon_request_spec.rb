# frozen_string_literal: true

RSpec.describe AnonRequest do
  it { is_expected.to respond_to(:configuration) }
  it { is_expected.to respond_to(:configure) }

  it 'has a version number' do
    expect(AnonRequest::VERSION).not_to be nil
  end
end

RSpec.describe AnonRequest::Client do
  subject(:client) { described_class.new(base_url) }

  let(:base_url) { 'https://api.example.com' }

  before do
    stub_get_ip_api('1.1.1.1')
    stub_api_get_call
    stub_api_post_call
  end

  it { is_expected.to respond_to(:get) }
  it { is_expected.to respond_to(:post) }

  it 'returns an instance of anon request client' do
    expect(client).to be_an_instance_of(described_class)
  end

  context 'when rotation is set' do
    let(:client) { AnonRequest::Client.new(base_url) }
    let(:path) { '/resources' }

    before do
      allow(AnonRequest::Client).to receive(:new).with(base_url).and_return(client)
      allow(client).to receive(:rotate).and_call_original
      AnonRequest.configuration.rotation = 5
    end

    it 'calls get method and rotates client' do
      stub_get_ip_api('1.1.1.2')
      expect(client).to receive(:get).with(path).and_call_original.exactly(6).times

      6.times { client.get(path) }

      expect(client).to have_received(:rotate).once
    end

    it 'calls post method and rotates client' do
      stub_get_ip_api('1.1.1.2')
      expect(client).to receive(:post).with(path).and_call_original.exactly(6).times

      6.times { client.post(path) }

      expect(client).to have_received(:rotate).once
    end
  end

  context 'when rotation is not set' do
    let(:client) { AnonRequest::Client.new(base_url) }
    let(:path) { '/resources' }

    before do
      allow(AnonRequest::Client).to receive(:new).with(base_url).and_return(client)
      allow(client).to receive(:rotate).and_call_original
      AnonRequest.configuration.rotation = nil
    end

    it 'calls get method and not rotates client' do
      stub_get_ip_api('1.1.1.2')
      expect(client).to receive(:get).with(path).and_call_original.exactly(6).times

      6.times { client.get(path) }

      expect(client).not_to have_received(:rotate)
    end

    it 'calls post method and not rotates client' do
      stub_get_ip_api('1.1.1.2')
      expect(client).to receive(:post).with(path).and_call_original.exactly(6).times

      6.times { client.post(path) }

      expect(client).not_to have_received(:rotate)
    end
  end

  context 'when vpn is not connected' do
    let(:client) { AnonRequest::Client.new(base_url) }
    let(:path) { '/resources' }

    before { AnonRequest.configuration.anon_ip_delay = 1 }

    it { expect { client.get(path) }.to raise_error(Timeout::Error) }
  end
end
