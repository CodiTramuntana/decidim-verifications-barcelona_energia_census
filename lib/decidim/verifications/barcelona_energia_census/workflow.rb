Decidim::Verifications.register_workflow(:barcelona_energia_census_authorization_handler) do |workflow|
  workflow.form = "Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationHandler"
  workflow.engine = Decidim::Verifications::BarcelonaEnergiaCensus::Engine
end
