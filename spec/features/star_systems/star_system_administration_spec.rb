require 'rails_helper'

RSpec.describe "Star System Administration", type: :feature do
  # First user
  let(:user) { create(:user) }
  let!(:empire) { create(:empire, user: user) }
  let!(:star_system) { create(:star_system, name: "Alpha Centauri", empire: empire) }

  # Second user and empire for authorization tests
  let(:other_user) { create(:user) }
  let!(:other_empire) { create(:empire, user: other_user) }
  let!(:other_star_system) { create(:star_system, name: "Sirius", empire: other_empire) }

  before do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Log in"
  end

  it "User can see 'Administer' button for each star system on dashboard" do
    visit dashboard_path

    expect(page).to have_link("Administer")
  end

  it "can access the edit page for their own star system" do
    visit dashboard_path

    click_link "Administer", match: :first

    expect(current_path).to eq(edit_star_system_path(star_system))
    expect(page).to have_content("Administer Star System")
    expect(page).to have_field("Name", with: "Alpha Centauri")
    expect(page).to_not have_field("Name", with: "Sirius")
  end

  it "can update the star system name" do
    visit edit_star_system_path(star_system)

    fill_in "Name", with: "Polaris"
    click_on "Update Star System"

    expect(current_path).to eq(edit_star_system_path(star_system))
    expect(page).to have_content("Star system updated successfully")
    expect(star_system.reload.name).to eq("Polaris")
  end

  it "cannot update star system with a blank name" do
    visit edit_star_system_path(star_system)

    fill_in "Name", with: ""
    click_on "Update Star System"

    expect(page).to have_content("Name can't be blank")
  end
end
