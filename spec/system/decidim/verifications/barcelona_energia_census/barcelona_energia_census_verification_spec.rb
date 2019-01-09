# frozen_string_literal: true

require "spec_helper"

describe "Authorizations", type: :system, perform_enqueued: true, with_authorization_workflows: ["barcelona_energia_census_authorization_handler"] do
  let!(:organization) do
    create(:organization,
      default_locale: :ca,
      available_locales: [:es, :ca],
      available_authorizations: ['barcelona_energia_census_authorization_handler'])
  end
  let!(:user) { create(:user, :confirmed, organization: organization, email: 'test_unic_ok@nemon2ib.com') }
  let!(:user2) { create(:user, :confirmed, organization: organization) }
  let!(:authorization) do
    create(
      :authorization,
      :granted,
      user: user2,
      name: 'barcelona_energia_census_authorization_handler',
      metadata: { }
    )
  end

  let!(:valid_barcelona_energia_census) do
    {
      email: 'test_unic_ok@nemon2ib.com',
      password: 'RaU6?Lqw'
    }
  end
  
  let!(:invalid_barcelona_energia_census) do
    {
      email: 'test_unic_ko@nemon2ib.com',
      password: 'RaU6?Lqw'
    }
  end

  context "when email is the same than user logged in" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_verifications.new_authorization_path(handler: "barcelona_energia_census_authorization_handler")
    end

    it 'redirects to verification after login' do
      expect(page).to have_content("Client de Barcelona Energia")
    end

    it 'allows the user to fill up form field', barcelona_energia_census_stub_type: :valid do
      submit_barcelona_energia_census_form(
        email: valid_barcelona_energia_census[:email],
        password: valid_barcelona_energia_census[:password]
      )

      expect(page).to have_current_path decidim_verifications.authorizations_path
      expect(page).to have_content('Has estat autoritzat amb èxit.')
    end

    it 'shows an error when email is not the same', barcelona_energia_census_stub_type: :valid do
      submit_barcelona_energia_census_form(
        email: invalid_barcelona_energia_census[:email],
        password: invalid_barcelona_energia_census[:password]
      )

      expect(page).to have_content('El correu electrònic que introdueixes no coincideix amb el que tens la sessió iniciada.')
    end

    it 'shows an error when data is not valid in Barcelona Energia Census', barcelona_energia_census_stub_type: :invalid do
      submit_barcelona_energia_census_form(
        email: valid_barcelona_energia_census[:email],
        password: valid_barcelona_energia_census[:password]
      )

      expect(page).to have_content("S'ha produït un error en crear l'autorització.")
      expect(page).to have_content('El cens de Barcelona Energia no pot validar les seves dades. No es compleixen les condicions addicionals per verificar-se')
    end

    it 'does not submit when data is not fulfilled' do
      submit_barcelona_energia_census_form(
        email: '',
        password: ''
      )

      expect(page).to have_current_path decidim_verifications.new_authorization_path(handler: "barcelona_energia_census_authorization_handler")
    end

    context "when the user has already been authorised" do
      let!(:authorization) do
        create(:authorization,
               name: Decidim::Verifications::BarcelonaEnergiaCensus::BarcelonaEnergiaCensusAuthorizationHandler.handler_name,
               user: user)
      end

      it "shows the authorization at their account" do
        visit decidim_verifications.authorizations_path

        within ".authorizations-list" do
          expect(page).to have_content("Client de Barcelona Energia")
          expect(page).not_to have_link("Client de Barcelona Energia")
          expect(page).to have_content(I18n.localize(authorization.granted_at, format: :long, locale: :ca))
        end
      end
    end
  end

  private

  def submit_barcelona_energia_census_form(email:, password:)
    fill_in 'Correu electrònic', with: email
    fill_in 'Contrassenya', with: password

    click_button 'Enviar'
  end

end
