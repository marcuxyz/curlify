require 'json'
require 'uri'
require 'net/http'

require './lib/curlify'

describe Curlify do
  let(:context) { described_class.new(request) }
  let(:uri) { URI('http://127.0.0.1') }
  let(:response) do
    <<~CURL
      curl -X #{method} \
      -H 'content-type: application/json' \
      -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' \
      -H 'accept: */*' -H 'user-agent: Ruby' \
      -H 'host: 127.0.0.1' #{body} http://127.0.0.1
    CURL
  end

  describe 'must transform request into curl command' do
    context '#get' do
      let(:request) { Net::HTTP::Get.new(uri, { 'content-type': 'application/json' }) }
      let(:method)  { 'GET' }
      let(:body)    { nil }

      it { expect(context.to_curl).to eq response.strip }
    end

    context '#post' do
      let(:request) { Net::HTTP::Post.new(uri, { 'content-type': 'application/json' }) }
      let(:method)  { 'POST' }
      let(:body)    { "-d #{payload}" }
      let(:payload) { { name: 'John' }.to_json }

      before { request.body = payload }

      it { expect(context.to_curl).to eq response.strip }
    end

    context '#put' do
      let(:request) { Net::HTTP::Put.new(uri, { 'content-type': 'application/json' }) }
      let(:method) { 'PUT' }
      let(:body)   { "-d #{payload}" }
      let(:payload)         { { name: 'John', userId: 1 }.to_json }

      before { request.body = payload }

      it { expect(context.to_curl).to eq response.strip }
    end
    context '#delete' do
      let(:request) { Net::HTTP::Delete.new(uri, { 'content-type': 'application/json' }) }
      let(:method) { 'DELETE' }
      let(:body)   { "-d #{payload}" }
      let(:payload)         { { userId: 1 }.to_json }

      before { request.body = payload }

      it { expect(context.to_curl).to eq response.strip }
    end
  end
end
