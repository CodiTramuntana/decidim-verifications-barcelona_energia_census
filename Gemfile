# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

gemspec

gem 'decidim', "~> 0.24.0"

gem 'doc2text' ,'>= 0.4.5'
gem 'image_processing', '>= 1.12.2'
gem 'nokogiri', '>= 1.13.4'
gem 'puma','>= 5.6.4'

group :development, :test do
  gem 'byebug'
  gem "bootsnap", require: true
  gem 'faker', '~> 1.8'
  gem 'listen'
end

group :development do
  gem 'letter_opener_web', '~> 1.3.3'
  gem 'web-console', '~> 3.5'
end
