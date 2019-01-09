# frozen_string_literal: true

module BarcelonaEnergiaCensusAuthorizationHandlerStubs
  def stub_valid_response
    # .with(body: {"action"=>"loginExtraParams", "class"=>"Session", "data"=>{"EnergyAdvicesInterest"=>"1", "email"=>"test_unic_ok@nemon2ib.com", "password"=>"51db2dfa6203a2f5be58c895fac6baa8d599f276"}}, headers: { 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.15.4' })
    # .to_return(status: 200, body: "", headers: {})
    stub_request(:post, URI.parse(barcelona_energia_census_url))
      .with(headers: { "Content-Type": 'text/xml' })
      .to_return(status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/barcelona_energia_census_valid_response.json', 'rb').read)
  end

  def stub_invalid_response
    stub_request(:post, URI.parse(barcelona_energia_census_url))
      .with(headers: { "Content-Type": 'text/xml' })
      .to_return(status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/barcelona_energia_census_invalid_response.json', 'rb').read)
  end

  # def stub_error_response
  #   stub_request(:post, URI.parse(barcelona_energia_census_url))
  #     .with(headers: { "Content-Type": 'text/xml' })
  #     .to_return(status: 400)
  # end

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
  # config.before barcelona_energia_census_stub_type: :error do
  #   stub_error_response
  # end
end
