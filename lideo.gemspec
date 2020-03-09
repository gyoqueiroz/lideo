# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'lideo'
  s.version   = '1.0.6'
  s.platform  = Gem::Platform::RUBY
  s.summary   = 'Lideo RSS Aggregator'
  s.description = 'A simple RSS aggregator CLI where you can read the headlines from your terminal'
  s.authors   = ['Gyowanny Queiroz']
  s.email     = ['gyowanny@gmail.com']
  s.homepage  = 'http://rubygems.org/gems/lideo'
  s.license   = 'MIT'
  s.files     = Dir.glob('{lib,bin}/**/*')
  s.require_path = 'lib'
  s.executables = ['lideo']
  s.metadata    = { 'source_code_uri' => 'https://github.com/gyoqueiroz/lideo' }
end
