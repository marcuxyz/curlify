require 'json'
require 'uri'
require 'net/http'
require 'faraday'

require './lib/curlify'

describe Curlify do
  let(:context) { described_class.new(request) }
  let(:uri)     { URI('http://127.0.0.1') }
  let(:headers) { { 'content-type': 'application/json' } }
  let(:response) do
    <<~CURL
      curl -X #{method} \
      -H 'content-type: application/json' \
      -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' \
      -H 'accept: */*' \
      -H 'user-agent: Ruby' \
      -H 'host: 127.0.0.1' #{body} http://127.0.0.1
    CURL
  end

  before { request.body = payload }

  describe 'must transform request into curl command' do
    context 'when is a GET request' do
      let(:request) { Net::HTTP::Get.new(uri, { 'content-type': 'application/json' }) }
      let(:body)    { nil }
      let(:payload) { nil }
      let(:method)  { request.method }

      it { expect(context.to_curl).to eq response.strip }
    end

    context 'when is a POST request' do
      let(:request) { Net::HTTP::Post.new(uri, { 'content-type': 'application/json' }) }
      let(:payload) { { name: 'John' }.to_json }
      let(:body)    { "-d '#{payload}'" }
      let(:method)  { request.method }

      it { expect(context.to_curl).to eq response.strip }
    end

    context 'when is a PUT request' do
      let(:request)  { Net::HTTP::Put.new(uri, { 'content-type': 'application/json' }) }
      let(:payload)  { { name: 'John', userId: 1 }.to_json }
      let(:body)     { "-d '#{payload}'" }
      let(:method) { request.method }

      before { request.body = payload }

      it { expect(context.to_curl).to eq response.strip }
    end

    context 'when is a DELETE request' do
      let(:request) { Net::HTTP::Delete.new(uri, { 'content-type': 'application/json' }) }
      let(:body)    { "-d '#{payload}'" }
      let(:payload) { { userId: 1 }.to_json }
      let(:method)  { request.method }

      before { request.body = payload }

      it { expect(context.to_curl).to eq response.strip }
    end

    context 'when the curl command is gernerated with Faraday' do
      let(:payload)  { nil }
      let(:response) { "curl -X GET -H 'Content-type: application/json'  http://127.0.0.1" }
      let(:method)   { request.http_method }
      let(:request) do
        Faraday.new.build_request(:get) do |req|
          req.url 'http://127.0.0.1'
          req.headers = headers
        end
      end

      it { expect(context.to_curl).to eq response.strip }
    end

    context 'when the curl command is gernerated with Faraday' do
      let(:body)     { "-d '#{payload}'" }
      let(:payload)  { { userId: 1 }.to_json }
      let(:method)   { request.http_method }
      let(:response) { "curl -X POST -H 'Content-type: application/json' -d '{\"userId\":1}' http://127.0.0.1" }

      let(:request) do
        Faraday.new.build_request(:post) do |req|
          req.url 'http://127.0.0.1'
          req.headers = headers
        end
      end

      it { expect(context.to_curl).to eq response.strip }
    end
  end
end
