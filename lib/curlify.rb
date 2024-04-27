# frozen_string_literal: true

require 'faraday'

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
    "curl -X #{method.upcase} #{headers} #{body} #{url}"
  end

  def headers
    return context_headers(request.headers) if request.is_a?(Faraday::Request)

    context_headers(request.each_header)
  end

  def method
    request.is_a?(Faraday::Request) ? request.http_method : request.method
  end

  def url
    request.is_a?(Faraday::Request) ? request.path : request.uri
  end

  def body
    "-d '#{request.body}'" unless request.body.nil?
  end

  def context_headers(headers)
    headers.map { |k, v| "-H '#{k}: #{v}'" }.join(' ')
  end
end
