The gem convert ruby requests(net/http) into curl command.

## Installation

To install the gem use `bundle` or `gem`, see:

```bash
$ gem install curlify
```

or bundle:

```bash
$ bundle add curlify
```

## Usage with faraday

Import `curlify` and `faraday` and perform curlify, see:

```ruby
require 'faraday'
require 'curlify'

request = Faraday.new.build_request(:post) do |req|
  req.url 'http://127.0.0.1'
end

curlify = Curlify.new(request)

puts curlify

# "curl -X POST -H 'User-Agent: Faraday v2.9.0'  http://127.0.0.1"
```

## Usage with net/http

Import `curlify`, `uri` and `net/http` and perform curlify, see:

```ruby
require 'json'
require 'uri'
require 'net/http'
require 'curlify'

uri = URI('https://httpbin.org/post')
request = Net::HTTP::Post.new(uri, { 'content-type': 'application/json' })
request.body = { title: 'Ruby is great :)' }.to_json

curlify = Curlify.new(request)

puts curlify.to_curl

# curl -X POST -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: httpbin.org' -d '{"title":"Ruby is great :)"}' https://httpbin.org/post
```

Performing this curl command, we can see the following result:

```bash
{
  "args": {},
  "data": "{\"title\":\"Ruby is great :)\"}",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
    "Content-Length": "28",
    "Content-Type": "application/json",
    "Host": "httpbin.org",
    "User-Agent": "Ruby",
    "X-Amzn-Trace-Id": "Root=1-64f38ad0-444dbe403f03082e14ba1d62"
  },
  "json": {
    "title": "Ruby is great :)"
  },
  "origin": "xxx.xxx.xx.xx",
  "url": "https://httpbin.org/post"
}
```
