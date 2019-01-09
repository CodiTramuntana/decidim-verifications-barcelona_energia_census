# frozen_string_literal: true

require 'rails'
require 'decidim/core'
require 'decidim/verifications'
require 'virtus/multiparams'

module Decidim
  module Verifications
    module BarcelonaEnergiaCensus
      # This is the engine that runs on the public interface of decidim-verifications-barcelona_energia_census.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::BarcelonaEnergiaCensus

        initializer 'decidim-verifications-barcelona_energia_census.assets' do |app|
          app.config.assets.precompile += %w[decidim-verifications-barcelona_energia_census_manifest.js decidim-verifications-barcelona_energia_census_manifest.css]
        end
      end
    end
  end
end
