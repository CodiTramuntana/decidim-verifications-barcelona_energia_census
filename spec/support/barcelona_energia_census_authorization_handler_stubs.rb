# frozen_string_literal: true

module BarcelonaEnergiaCensusAuthorizationHandlerStubs
  def stub_valid_response
    stub_request(:post, URI.parse(barcelona_energia_census_url))
      .to_return(status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/barcelona_energia_census_valid_response.json', 'rb').read)
  end

  def stub_invalid_response
    stub_request(:post, URI.parse(barcelona_energia_census_url))
      .to_return(status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/barcelona_energia_census_invalid_response.json', 'rb').read)
  end

  private

  def barcelona_energia_census_url
    Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationConfig.url
  end
end

RSpec.configure do |config|
  config.before barcelona_energia_census_stub_type: :valid do
    stub_valid_response
  end
  config.before barcelona_energia_census_stub_type: :invalid do
    stub_invalid_response
  end
end
