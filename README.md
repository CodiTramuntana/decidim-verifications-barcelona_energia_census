# Decidim::Verifications::BarcelonaEnergiaCensus

Decidim Verifications for Barcelona Energia Census.

## Usage

Decidim::Verifications::BarcelonaEnergiaCensus will be available as a Verifier.

## How it works

- The user must be registered as a "normal" Decidim::User. Ideally with the same email as Barcelona Energia Platform.
- Then, User goes to the Authorizations path and fill the fields email and password to verifiy the user. This connects to a WS with params (barcelona_energia_census_url, barcelona_energia_census_secret, barcelona_energia_census_interest) added on secrets.yml.
- If the return is valid, the user is verified.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-verifications-barcelona_energia_census'
```

And then execute:

```bash
bundle
```

BarcelonaEnergiaCensus verificator needs 2 values to perform requests: url and interest

Take care to add environment values to the secrets.yml file with:

```ruby
barcelona_energia_census:
  barcelona_energia_census_url: <%= ENV["BARCELONA_ENERGIA_CENSUS_URL"] %>
  barcelona_energia_census_secret: <%= ENV["BARCELONA_ENERGIA_CENSUS_SECRET"] %>
  barcelona_energia_census_interest: <%= ENV["BARCELONA_ENERGIA_CENSUS_INTEREST"] %>
```
## Testing

1. Run `bundle exec rake test_app`.

2. Edit `spec/decidim_dummy_app/config/secrets.rb` and add the yaml portion in the Installation chapter of this document. No need to set all the ENV varialbes, just set the secrets keys in the `default` parent blok, and set the following value: `barcelona_energia_census_url: https://example.net/census`.

3. run tests with `bundle exec rspec`.


## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
