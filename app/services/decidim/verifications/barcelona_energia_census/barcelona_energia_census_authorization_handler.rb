# frozen_string_literal: true

require 'digest'
module Decidim
  module Verifications
    module BarcelonaEnergiaCensus
      # Checks the authorization against the client census of Barcelona Energia to create authorizations.
      # This AuthorizationHandler uses the Barcelona Energia census WS to VALIDATE
      # if user is client or not.
      #
      # To send a request you MUST provide:
      # - email: A String with the user email.
      # - password: a String encrypted with SHA1
      class BarcelonaEnergiaCensusAuthorizationHandler < Decidim::AuthorizationHandler
        attribute :email, String
        attribute :password, String

        validates :email, presence: true, 'valid_email_2/email': { disposable: true }
        validates :password, presence: true

        validate :email_equal_to_user_email
        validate :valid_user

        # The only method that needs to be implemented for an authorization handler.
        # Here you can add your business logic to check if the authorization should
        # be created or not, you should return a Boolean value.
        #
        # Note that if you set some validations and overwrite this method, then the
        # validations will not run, so it's easier to just remove this method and reite
        # your logic using ActiveModel validations.
        # def valid?
        #   raise NotImplementedError
        # end

        def unique_id
          Digest::SHA512.hexdigest(
            "#{email}-#{Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationConfig.secret}"
          )
        end

        # If you need to store any of the defined attributes in the authorization you
        # can do it here.
        #
        # You must return a Hash that will be serialized to the authorization when
        # it's created, and available though authorization.metadata
        #
        def metadata
          super.merge(token: response_token)
        end

        private

        def email_equal_to_user_email
          unless email == user.email
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.not_same_email'))
            errors.add(:email, '')
          else
            true
          end
        end

        def valid_user
          return nil if response.blank?
          case response_code
          when 200
            true
          when 422
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.not_valid_email_or_password'))
            false
          when 403
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.cannot_validate'))
            false
          when 409
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.not_valid'))
            false
          else
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.unexpected_error'))
            false
          end
        end

        def uncomplete_credentials?
          email.blank? || password.blank?
        end

        def already_processed?
          defined?(@response)
        end

        def response_code
          return nil if response.blank?
          response[:body]['error']['code']
        end

        def response_token
          return nil if response.blank?
          response[:body]['token']
        end

        def response
          return nil if uncomplete_credentials?

          return @response if already_processed?
          begin
            rs = Faraday.post do |request|
              request.url Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationConfig.url
              request.body = request_body
            end
            @response = {
              body: JSON.parse(rs.body),
              status: rs.status
            }
          rescue Faraday::ConnectionFailed
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.connection_failed'))
            return nil
          rescue Faraday::TimeoutError
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.connection_timeout'))
            return nil
          end
        end

        def request_body
          @request_body ||= {
            class: 'Session',
            action: 'loginExtraParams',
            data: {
              email: email.to_s,
              password: password_encrypted.to_s,
              EnergyAdvicesInterest: Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationConfig.interest.to_s
            }
          }
        end

        ## We encrypt with SHA1 for Barcelona Energía requirements
        def password_encrypted
          return if password.nil?
          Digest::SHA1.hexdigest(password.to_s)
        end
      end
    end
  end
end
