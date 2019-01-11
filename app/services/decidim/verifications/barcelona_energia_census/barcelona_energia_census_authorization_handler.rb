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
        include ActionView::Helpers::SanitizeHelper
        attribute :email, String
        attribute :password, String

        validates :email, presence: true, 'valid_email_2/email': { disposable: true }
        validates :password, presence: true

        validate :email_equal_to_user_email
        validate :barcelona_energia_census_valid?

        def unique_id
          Digest::SHA512.hexdigest(
            "#{email}-#{Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationConfig.secret}"
          )
        end

        private

        # Validate the email is the same than user email
        #
        # Returns a boolean
        def email_equal_to_user_email
          errors.add(:email, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.not_same_email')) unless email == user.email
        end

        # Checks the response of BarcelonaEnergiaCensus WS, and add errors in bad cases
        #
        # Returns a boolean
        def barcelona_energia_census_valid?
          return false if errors.any? || response.blank?
          if success_response?
            unless response_code == 200
              case response_code
              when 422
                errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.not_valid_email_or_password'))
              when 403
                errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.cannot_validate'))
              when 409
                errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.not_valid'))
              else
                errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.unexpected_error'))
              end
            end
          else
            errors.add(:base, I18n.t('errors.messages.barcelona_energia_census_authorization_handler.cannot_validate'))
          end
          errors.empty?
        end

        # Check for WS needed values
        #
        # Returns a boolean
        def uncomplete_credentials?
          email.blank? && password.blank?
        end

        # Check the error code of body response
        #
        # Returns an Integer
        def response_code
          return nil if response.blank?
          response[:body]['error']['code']
        end

        # Check if request had been correctly performed
        #
        # Returns a boolean
        def success_response?
          # Status code 200, success request. Otherwise, error
          response[:status] == 200
        end

        # Prepares and perform WS request.
        # It rescue failed connections to SalouCensus
        #
        # Returns an stringified XML
        def response
          return nil if uncomplete_credentials?

          return @response if already_processed?

          rs = request_ws
          return nil unless rs

          @response ||= { body: JSON.parse(rs.body), status: rs.status }
        end

        def request_ws
          begin
            ws_response = Faraday.post do |request|
              request.url Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationConfig.url
              request.body = request_body
            end
            return ws_response
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

        # Check if request had benn already been processed and saved
        #
        # Returns a boolean
        def already_processed?
          defined?(@response)
        end

        # Check if request had been correctly performed
        #
        # Returns a boolean
        def success_response?
          # Status code 200, success request. Otherwise, error
          response[:status] == 200
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
