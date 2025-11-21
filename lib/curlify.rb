# frozen_string_literal: true

require 'faraday'
require 'byebug'

class Curlify
  attr_reader :request, :verify, :compressed, :clipboard

  def initialize(request, compressed: false, verify: true, clipboard: false)
    @request = request
    @compressed = compressed
    @verify = verify
    @clipboard = clipboard
  end

  def to_curl
    command = build_curl_command
    copy_to_clipboard(command)
    command
  end

  private

  def build_curl_command
    [
      curl_request,
      verify ? nil : '--insecure',
      compressed ? '--compressed' : nil
    ].compact.join(' ')
  end

  def curl_request
    "curl -X #{http_method.upcase} #{headers} #{body} #{url}".strip
  end

  def headers
    if request.is_a?(Faraday::Request)
      context_headers(request.headers)
    else
      context_headers(request.each_header)
    end
  end

  def http_method
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

  def copy_to_clipboard(string)
    return unless clipboard

    command = clipboard_command
    return warn("Curlify Warning: 'xclip' is required for clipboard support on Linux.") unless command

    IO.popen(command, 'w') { |f| f << string }
  end

  def clipboard_command
    case RUBY_PLATFORM
    when /darwin/
      'pbcopy'
    when /mswin|mingw|cygwin/
      'clip'
    when /linux/
      'xclip -selection clipboard' if system('which xclip > /dev/null 2>&1')
    end
  end
end
