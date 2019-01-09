# frozen_string_literal: true

module Decidim
  module Verifications
    module BarcelonaEnergiaCensus
      # This is the engine that runs on the public interface of
      # `Decidim::Verifications::BarcelonaEnergiaCensus`.
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::BarcelonaEnergiaCensus::Admin

        paths['db/migrate'] = nil
        paths['lib/tasks'] = nil

        def load_seed
          nil
        end
      end
    end
  end
end
