# frozen_string_literal: true

class Curlify
  attr_reader :request, :verify, :compressed

  def initialize(request, compressed: false, verify: true)
    @request = request
    @compressed = compressed
    @verify = verify
  end

  def to_curl
    return curl_request << ' --compressed' if compressed
    return curl_request << ' --insecure' unless verify

    curl_request
  end

  private

  def curl_request
    "curl -X #{request.method} #{headers} #{body} #{request.uri}"
  end

  def headers
    request.each_header.map { |key, value| "-H '#{key}: #{value}'" }.join(' ')
  end

  def body
    "-d '#{request.body}'" unless request.body.nil?
  end
end
