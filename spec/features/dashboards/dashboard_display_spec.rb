require 'rails_helper'

RSpec.describe "Empire Dashboard", type: :feature do
  let(:user) { create(:user) }
  let!(:empire) { create(:empire, name: "Test Empire", user: user) }
  let!(:star_system) { create(:star_system, name: "Alpha Centauri", system_type: "terrestrial", empire: empire) }

  before do
    # Log in the user
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    visit dashboard_path
  end

  it "displays the empire name" do
    expect(page).to have_content("Test Empire")
  end

  it "displays empire resources" do
    expect(page).to have_content("Credits")
    expect(page).to have_content(empire.credits.to_s)
    expect(page).to have_content("Minerals")
    expect(page).to have_content(empire.minerals.to_s)
    expect(page).to have_content("Energy")
    expect(page).to have_content(empire.energy.to_s)
    expect(page).to have_content("Food")
    expect(page).to have_content(empire.food.to_s)
  end

  it "displays star systems" do
    expect(page).to have_content("Star Systems")
    expect(page).to have_content("Alpha Centauri")
    expect(page).to have_content("terrestrial".humanize)
  end
end