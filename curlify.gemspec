Gem::Specification.new do |s|
  s.name        = 'curlify'
  s.version     = '2.0.0'
  s.summary     = 'Convert Ruby HTTP request objects into curl commands'
  s.description = 'Convert Ruby HTTP request and client objects into their equivalent curl command. Useful for debugging and sharing HTTP requests.'
  s.authors     = ['Marcus Almeida']
  s.email       = 'mpereirassa@gmail.com'
  s.files       = ['lib/curlify.rb', 'lib/settings.rb']
  s.homepage    =
    'https://rubygems.org/gems/curlify'
  s.license = 'MIT'
  s.metadata = {
    'source_code_uri' => 'https://github.com/marcuxyz/curlify',
    'bug_tracker_uri' => 'https://github.com/marcuxyz/curlify/issues',
    'changelog_uri' => 'https://github.com/marcuxyz/curlify/releases',
    'rubygems_mfa_required' => 'true'
  }

  s.rdoc_options     = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.required_ruby_version = '>= 2.7.8'

  s.add_dependency 'faraday', '>= 2.0'
end
