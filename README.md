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

## Usage

Import 'curlify', 'uri' and 'net/http' gems and execute curlify, see:

```python
require 'uri'
require 'net/http'
require 'curlify'

uri = URI('https://run.mocky.io/v3/b0f4ffd8-6696-4f90-8bab-4a3bcad9ef3f')
request = Net::HTTP::Get.new(uri, { 'content-type': 'application/json' })
curlify = Curlify.new(request)

puts curlify.to_curl # curl -X GET -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: run.mocky.io'  https://run.mocky.io/v3/b0f4ffd8-6696-4f90-8bab-4a3bcad9ef3f
```
