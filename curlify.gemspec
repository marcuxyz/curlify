Gem::Specification.new do |s|
  s.name        = 'curlify'
  s.version     = '1.0.0'
  s.summary     = 'Hola!'
  s.description = 'The gem convert python requests object in curl command.'
  s.authors     = ['Marcus Almeida']
  s.email       = 'mpereirassa@gmail.com'
  s.files       = ['lib/curlify.rb']
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

  s.required_ruby_version = '>= 3.2.0'
end
