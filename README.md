# Decidim::Verifications::BarcelonaEnergiaCensus

Decidim Verifications for Barcelona Energia Census.

## Usage

Decidim::Verifications::BarcelonaEnergiaCensus will be available as a Component for Verifications

## How it works
- The user must be registered as "normal" Decidim::User. with the same email as Barcelona Energia Platform.
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

1. Run `bundle exec rake test_app`. **Execution will fail in an specific migration.**

2. cd `spec/decidim_dummy_app/` and:

  2.1. Comment `up` execution in failing migration

  2.2. Execute...
  ```bash
  RAILS_ENV=test bundle exec rails db:drop
  RAILS_ENV=test bundle exec rails db:create
  RAILS_ENV=test bundle exec rails db:migrate
  ```
3. back to root folder `cd ../..`

4. run tests with `bundle exec rspec`

5. Remember to configure this new test App with configuration values.

## Versioning

`Decidim::Verifications::BarcelonaEnergiaCensus` depends directly on `Decidim::Verifications` in `0.15.2` version.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
