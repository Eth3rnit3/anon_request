# frozen_string_literal: true

RSpec.describe AnonRequest do
  it { is_expected.to respond_to(:configuration) }
  it { is_expected.to respond_to(:configure) }

  it "has a version number" do
    expect(AnonRequest::VERSION).not_to be nil
  end
end

RSpec.describe AnonRequest::Client do
  subject { described_class.new(base_url) }

  let(:base_url) { 'https://example.com/api' }

  it { is_expected.to respond_to(:get) }
  it { is_expected.to respond_to(:post) }

  it "return anon request client" do
    expect(described_class.new(base_url)).to an_instance_of(described_class)
  end
end
