# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'decidim/verifications/barcelona_energia_census/version'

Gem::Specification.new do |s|
  s.version = Decidim::Verifications::BarcelonaEnergiaCensus.version
  s.authors = ['Isaac Massot']
  s.email = ['isaac.mg@coditramuntana.com']
  s.license = 'AGPL-3.0'
  s.homepage = 'https://github.com/decidim/decidim-module-decidim-verifications-barcelona_energia_census'
  s.required_ruby_version = '>= 2.7.5'

  s.name = 'decidim-verifications-barcelona_energia_census'
  s.summary = 'A decidim verifications barcelona energia census module'
  s.description = 'Decidim Verification for Barcelona Energia Census.'

  s.files = Dir['{app,config,lib}/**/*', 'LICENSE-AGPLv3.txt', 'Rakefile', 'README.md']

  s.add_dependency 'decidim-core', Decidim::Verifications::BarcelonaEnergiaCensus.decidim_version
  s.add_dependency 'decidim-verifications', Decidim::Verifications::BarcelonaEnergiaCensus.decidim_version
  s.add_dependency 'rails', '>= 5.2'
  s.add_dependency 'virtus-multiparams'

  s.add_development_dependency 'decidim-dev', Decidim::Verifications::BarcelonaEnergiaCensus.decidim_version
end
