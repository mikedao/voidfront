require 'rails_helper'

RSpec.describe "User Logout", type: :feature do
  let(:user) { create(:user, email: "test@example.com", username: "testuser", password: "password123") }

  scenario "User can log out" do
    # Log in first
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    
    # Verify logged in
    expect(page).to have_content("Welcome, #{user.username}")
    
    # Log out
    click_link "Logout"
    
    # Verify logged out
    expect(page).to have_content("You have been logged out")
    expect(page).to have_link("Login")
    expect(page).not_to have_content("Welcome, #{user.username}")
  end
end