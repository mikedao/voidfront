require 'rails_helper'

RSpec.describe "Manage Empire", type: :feature do
  let(:user) { create(:user) }
  let!(:empire) { create(:empire, name: "Test Empire", user: user, tax_rate: 20) }
  let!(:star_system) { create(:star_system, name: "Alpha Centauri", system_type: "terrestrial", empire: empire) }

  before do
    # Log in the user
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"
  end

  scenario "User can see tax rate on dashboard" do
    visit dashboard_path
    
    expect(page).to have_content("Tax Rate")
    expect(page).to have_content("20%")
  end

  scenario "User can access empire management page" do
    visit dashboard_path
    
    expect(page).to have_link("Manage Empire")
    click_link "Manage Empire"
    
    expect(current_path).to eq(edit_empire_path(empire))
    expect(page).to have_content("Manage Your Empire")
    expect(page).to have_field("Name", with: "Test Empire")
    expect(page).to have_field("empire[tax_rate]", with: "20")
  end

  scenario "User can update empire name" do
    visit edit_empire_path(empire)
    
    fill_in "Name", with: "Galactic Federation"
    click_button "Update Empire"
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Empire updated successfully")
    expect(page).to have_content("Galactic Federation")
    expect(page).not_to have_content("Test Empire")
  end

  scenario "User can update tax rate" do
    visit edit_empire_path(empire)
    fill_in "empire[tax_rate]", with: "30"
    click_button "Update Empire"
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Empire updated successfully")
    expect(page).to have_content("Tax Rate")
    expect(page).to have_content("30%")
    expect(page).not_to have_content("20%")
  end

  scenario "User cannot update with invalid tax rate" do
    visit edit_empire_path(empire)
    
    fill_in "empire[tax_rate]", with: "101"
    click_button "Update Empire"
    
    expect(page).to have_content("Tax rate must be less than or equal to 100")
  end

  scenario "User cannot update with invalid name" do
    visit edit_empire_path(empire)
    
    fill_in "Name", with: ""
    click_button "Update Empire"
    
    expect(page).to have_content("Name can't be blank")
  end
end
