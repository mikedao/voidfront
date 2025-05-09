require 'rails_helper'

RSpec.describe "User Registration with Empire Name", type: :feature do
  scenario "User successfully registers with an empire name" do
    visit new_user_path

    fill_in "Email", with: "test@example.com"
    fill_in "Username", with: "testuser"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    fill_in "Empire name (optional)", with: "Galactic Federation"

    expect {
      click_button "Register"
    }.to change(User, :count).by(1)
      .and change(Empire, :count).by(1)

    # Check redirect to dashboard
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Registration Successful")
    expect(page).to have_content("Galactic Federation")
  end

  scenario "User attempts to register with an empire name that is already taken" do
    # Create an existing empire with a name
    existing_user = create(:user)
    create(:empire, name: "Galactic Federation", user: existing_user)
  
    visit new_user_path
    
    fill_in "Email", with: "new@example.com"
    fill_in "Username", with: "newuser"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    fill_in "Empire name (optional)", with: "Galactic Federation"
    
    click_button "Register"
    
    expect(page).to have_content("Name has already been taken")
    expect(User.count).to eq(1) # Just the existing user
  end
end