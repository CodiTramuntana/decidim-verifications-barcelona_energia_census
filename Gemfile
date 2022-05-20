# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

gemspec

gem 'decidim', "~> 0.24.0"

gem 'doc2text' ,'>= 0.4.5'
gem 'image_processing', '>= 1.12.2'
# Remove this nokogiri forces version at any time but make sure that no __truncato_root__ text appears in the cards in general.
# More exactly in comments in the homepage and in processes cards in the processes listing
gem "nokogiri", "1.13.3"
gem 'puma','>= 5.6.4'

gem "actionview", ">= 5.2.7.1"
gem "actionpack", ">= 5.2.7.1"
gem "activestorage", ">= 5.2.6.3"
gem "rails", "= 5.2.7.1"

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
