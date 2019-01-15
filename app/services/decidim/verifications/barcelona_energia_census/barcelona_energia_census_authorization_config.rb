# frozen_string_literal: true

module Decidim
  module Verifications
    module BarcelonaEnergiaCensus
      # This is a handler for BarcelonaEnergiaCensus config values.
      # By now it only search for secret ones, but in future it could
      # be filled by a config record
      class BarcelonaEnergiaCensusAuthorizationConfig
        class << self
          # Access URL for Barcelona Energia Census
          def url
            Rails.application.secrets.barcelona_energia_census[:barcelona_energia_census_url]
          end

          # interest value for Barcelona Energia Census
          def interest
            Rails.application.secrets.barcelona_energia_census[:barcelona_energia_census_interest]
          end

          # secret value for Barcelona Energia Census to encrypt an unique_id
          def secret
            Rails.application.secrets.barcelona_energia_census[:barcelona_energia_census_secret]
          end
        end
      end
    end
  end
end
