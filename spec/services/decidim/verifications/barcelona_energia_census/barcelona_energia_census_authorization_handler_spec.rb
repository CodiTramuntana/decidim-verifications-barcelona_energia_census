# frozen_string_literal: true
require "spec_helper"
require 'digest'
require "decidim/dev/test/authorization_shared_examples"

module Decidim
  module Verifications
    module BarcelonaEnergiaCensus
      describe BarcelonaEnergiaCensusAuthorizationHandler do
        let(:subject) { handler }
        let(:handler) { described_class.new(params.merge(extra_params)) }
        let(:extra_params) { {} }

        let!(:email) { "loremipsum@ipsum.com" }
        let!(:password) { "PasswordEncrypted" }
        let(:user) { create(:user, email: email) }

        let(:params) do
          {
            user: user,
            email: email,
            password: password
          }
        end

        it_behaves_like "an authorization handler"

        context "with a valid user" do
          before do
            allow(handler)
              .to receive(:in_barcelona_energia_census?)
          end

          describe "email" do
            let(:user) { create(:user) }
            context "when it isn't present" do
              let(:email) { nil }

              it { is_expected.not_to be_valid }
            end

            context "with an invalid format" do
              let(:email) { "aaaaaa" }

              it { is_expected.not_to be_valid }
            end
          end

          describe "password" do
            context "when it isn't present" do
              let(:password) { nil }

              it { is_expected.not_to be_valid }
            end
          end

          context "when everything is fine" do
            it { is_expected.to be_valid }
          end
        end

        context "unique_id" do
          it "generates a different ID for a different email" do
            handler.email = "loremipsum@ipsum.com"
            unique_id1 = handler.unique_id

            handler.email = "loremipsum222@ipsum.com"
            unique_id2 = handler.unique_id

            expect(unique_id1).to_not eq(unique_id2)
          end

          it "generates the same ID for the same email" do
            handler.email = "loremipsum@ipsum.com"
            unique_id1 = handler.unique_id

            handler.email = "loremipsum@ipsum.com"
            unique_id2 = handler.unique_id

            expect(unique_id1).to eq(unique_id2)
          end

          it "hashes the email" do
            handler.email = "loremipsum@ipsum.com"
            unique_id = handler.unique_id

            expect(unique_id).to_not include(handler.email)
          end
        end
      end
    end
  end
end
