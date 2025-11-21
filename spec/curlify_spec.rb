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

  describe 'must transform request into curl command' do
    before { request.body = payload }
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

  describe '#copy_to_clipboard' do
    let(:request) { Net::HTTP::Get.new(uri, headers) }
    let(:payload) { nil }

    before { request.body = payload }

    context 'when clipboard is disabled' do
      let(:context) { described_class.new(request, clipboard: false) }

      it 'does not copy to clipboard' do
        expect(IO).not_to receive(:popen)
        context.to_curl
      end
    end

    context 'when clipboard is enabled' do
      let(:context) { described_class.new(request, clipboard: true) }

      context 'on macOS' do
        before { stub_const('RUBY_PLATFORM', 'darwin') }

        it 'uses pbcopy command' do
          mock_io = double
          allow(mock_io).to receive(:<<)
          allow(IO).to receive(:popen).and_yield(mock_io)
          context.to_curl
          expect(IO).to have_received(:popen).with('pbcopy', 'w')
        end
      end

      context 'on Windows' do
        before { stub_const('RUBY_PLATFORM', 'mingw') }

        it 'uses clip command' do
          mock_io = double
          allow(mock_io).to receive(:<<)
          allow(IO).to receive(:popen).and_yield(mock_io)
          context.to_curl
          expect(IO).to have_received(:popen).with('clip', 'w')
        end
      end

      context 'on Linux' do
        before { stub_const('RUBY_PLATFORM', 'linux') }

        context 'when xclip is available' do
          before { allow_any_instance_of(Curlify).to receive(:system).and_return(true) }

          it 'uses xclip command' do
            mock_io = double
            allow(mock_io).to receive(:<<)
            allow(IO).to receive(:popen).and_yield(mock_io)
            context.to_curl
            expect(IO).to have_received(:popen).with('xclip -selection clipboard', 'w')
          end
        end

        context 'when xclip is not available' do
          before { allow_any_instance_of(Curlify).to receive(:system).and_return(false) }

          it 'displays warning message' do
            expect_any_instance_of(Curlify).to receive(:warn).with("Curlify Warning: 'xclip' is required for clipboard support on Linux.")
            context.to_curl
          end
        end
      end
    end
  end

  describe '#build_curl_command' do
    let(:request) { Net::HTTP::Get.new(uri, headers) }
    let(:context) { described_class.new(request, compressed: compressed, verify: verify) }

    context 'when verify is true and compressed is false' do
      let(:verify) { true }
      let(:compressed) { false }

      it 'does not include --insecure or --compressed' do
        result = context.to_curl
        expect(result).not_to include('--insecure')
        expect(result).not_to include('--compressed')
      end
    end

    context 'when verify is false' do
      let(:verify) { false }
      let(:compressed) { false }

      it 'includes --insecure flag' do
        result = context.to_curl
        expect(result).to include('--insecure')
      end
    end

    context 'when compressed is true' do
      let(:verify) { true }
      let(:compressed) { true }

      it 'includes --compressed flag' do
        result = context.to_curl
        expect(result).to include('--compressed')
      end
    end

    context 'when both verify is false and compressed is true' do
      let(:verify) { false }
      let(:compressed) { true }

      it 'includes both --insecure and --compressed flags' do
        result = context.to_curl
        expect(result).to include('--insecure')
        expect(result).to include('--compressed')
      end
    end
  end
end
