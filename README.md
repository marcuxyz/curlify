The gem converts ruby requests to curl

## Features

- **Multi-Framework Support**: Works with Faraday and Net::HTTP requests
- **Clipboard Integration**: Copy generated curl commands directly to clipboard (macOS, Windows, Linux)
- **Configuration Management**: YAML-based settings for customizing Curlify behavior
- **Simple API**: Easy-to-use interface with minimal configuration required

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

Curlify.new(request).to_curl # "curl -X POST -H 'User-Agent: Faraday v2.9.0'  http://127.0.0.1"
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

Curlify.new(request).to_curl # curl -X POST -H 'content-type: application/json' -H 'accept-encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3' -H 'accept: */*' -H 'user-agent: Ruby' -H 'host: httpbin.org' -d '{"title":"Ruby is great :)"}' https://httpbin.org/post
```

## Clipboard support

Curlify can copy the generated curl command directly to the operating system clipboard. To enable this behavior, pass `clipboard: true` when creating the `Curlify` instance. The method still returns the curl string.

Supported platforms:
- macOS: uses `pbcopy`
- Windows: uses `clip`
- Linux: uses `xclip` (must be installed and available in `PATH`)

If `xclip` is not available on Linux, Curlify will print a warning: `Curlify Warning: 'xclip' is required for clipboard support on Linux.`

## Configuration

Curlify supports configuration management through a YAML settings file. You can customize the default behavior by creating a `settings.yml` configuration file in your `config` directory.

### Creating Your Configuration File

#### Step 1: Create the config directory (if it doesn't exist)

```bash
mkdir -p config
```

#### Step 2: Create the settings.yml file

Create a file named `settings.yml` in the `config` directory:

```bash
touch config/settings.yml
```

#### Step 3: Configure your settings

Open `config/settings.yml` and add your Curlify configuration options:

```yaml
# config/settings.yml
clipboard: false
verify: true
compressed: false
```

### Available Configuration Options

- **clipboard** (boolean, default: `false`): Automatically copy generated curl commands to the clipboard
  - `true`: Copy curl command to clipboard
  - `false`: Only return the curl string

- **verify** (boolean, default: `true`): Verify SSL certificates when making requests
  - `true`: Verify SSL certificates
  - `false`: Skip SSL verification (use with caution)

- **compressed** (boolean, default: `false`): Add compression support to curl commands
  - `true`: Add `--compressed` flag to curl command
  - `false`: No compression flag

### Usage Examples

#### Example 1: Basic Configuration

```yaml
# config/settings.yml
clipboard: false
verify: true
compressed: false
```

Then use Curlify normally:

```ruby
require 'faraday'
require 'curlify'

request = Faraday.new.build_request(:post) do |req|
  req.url 'http://127.0.0.1'
end

# Uses settings from config/settings.yml
Curlify.new(request).to_curl
```

#### Example 2: Enable Clipboard Support

```yaml
# config/settings.yml
clipboard: true
verify: true
compressed: false
```

Now every curl command will be automatically copied to your clipboard:

```ruby
require 'faraday'
require 'curlify'

request = Faraday.new.build_request(:get) do |req|
  req.url 'https://api.example.com/data'
end

curl_command = Curlify.new(request).to_curl
# curl_command is now in your clipboard!
puts curl_command
```

#### Example 3: Production Configuration

```yaml
# config/settings.yml
clipboard: false
verify: true
compressed: true
```

This configuration is suitable for production environments where you want:
- No automatic clipboard operations
- SSL verification enabled for security
- Compressed curl commands

### Troubleshooting

- **Configuration file not found**: Make sure the `config/settings.yml` file exists in your project root directory
- **Settings not loading**: Verify the YAML syntax is correct (indentation matters in YAML)
- **Clipboard not working on Linux**: Ensure `xclip` is installed: `sudo apt-get install xclip`

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
