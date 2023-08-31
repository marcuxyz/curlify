require 'json'
require 'uri'
require 'net/http'
require './lib/curlify'

describe Curlify do
  let(:context) { described_class.new(request) }
  let(:uri) { URI('http://127.0.0.1') }

  describe 'must transform request into curl command' do
    context '#get' do
      let(:request) { Net::HTTP::Get.new(uri, { 'content-type': 'application/json' }) }

      it 'should return curl command to GET request' do
        expect(context.to_curl).to eq "curl -X GET -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: 127.0.0.1'  http://127.0.0.1"
      end
    end

    context '#post' do
      let(:request) do
        Net::HTTP::Post.new(uri, { 'content-type': 'application/json' })
      end

      before do
        request.body = { name: 'John' }.to_json
      end

      it 'should return curl command to Post request' do
        expect(context.to_curl).to eq "curl -X POST -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: 127.0.0.1' -d {\"name\":\"John\"} http://127.0.0.1"
      end
    end

    context '#put' do
      let(:request) { Net::HTTP::Put.new(uri, { 'content-type': 'application/json' }) }

      before do
        request.body = { name: 'John', userId: 1 }.to_json
      end

      it 'should return curl command to Put request' do
        expect(context.to_curl).to eq "curl -X PUT -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: 127.0.0.1' -d {\"name\":\"John\",\"userId\":1} http://127.0.0.1"
      end
    end
    context '#delete' do
      let(:request) { Net::HTTP::Delete.new(uri, { 'content-type': 'application/json' }) }

      before do
        request.body = { userId: 1 }.to_json
      end

      it 'should return curl command to Delete request' do
        expect(context.to_curl).to eq "curl -X DELETE -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: 127.0.0.1' -d {\"userId\":1} http://127.0.0.1"
      end
    end
  end
end
