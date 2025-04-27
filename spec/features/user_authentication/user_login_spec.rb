require 'rails_helper'

RSpec.describe "User Login", type: :feature do
  let(:user) { create(:user, email: "test@example.com", username: "testuser", password: "password123") }

  scenario "User can see the login page" do
    visit login_path
    expect(page).to have_content("Log in to Your Account")
    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
    expect(page).to have_button("Log in")
  end

  scenario "User can log in with valid credentials" do
    user # create the user before visiting the page
    
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    
    expect(page).to have_content("Login Successful")
    expect(page).to have_content("Welcome, #{user.username}")
    expect(current_path).to eq(root_path)
  end

  scenario "User cannot log in with invalid email" do
    visit login_path
    fill_in "Email", with: "wrong@example.com"
    fill_in "Password", with: "password123"
    click_button "Log in"
    
    expect(page).to have_content("Invalid email or password")
    expect(page).not_to have_content("Welcome")
  end

  scenario "User cannot log in with invalid password" do
    user # create the user
    
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"
    
    expect(page).to have_content("Invalid email or password")
    expect(page).not_to have_content("Welcome")
  end

  xscenario "User is remembered after checking remember me" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    check "Remember me"
    click_button "Log in"
    
    expect(page).to have_content("Welcome, #{user.username}")
    
    Capybara.reset_session!
    
    visit root_path
    save_and_open_page
    expect(page).to have_content("Welcome, #{user.username}")
  end

  scenario "User is not remembered without checking remember me" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    # Don't check "Remember me"
    click_button "Log in"
    
    expect(page).to have_content("Welcome, #{user.username}")
    
    # Clear the session cookies
    Capybara.reset_session!
    
    # Visit the site again - user should NOT be logged in
    visit root_path
    expect(page).not_to have_content("Welcome, #{user.username}")
    expect(page).to have_link("Login")
  end

  scenario "Remembered user is properly logged out" do
    # Login with remember me
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    check "Remember me"
    click_button "Log in"
    
    # Now log out
    click_link "Logout"
    expect(page).to have_content("You have been logged out")
    
    # Even after a "browser restart" the user should be logged out
    Capybara.reset_session!
    visit root_path
    expect(page).not_to have_content("Welcome, #{user.username}")
    expect(page).to have_link("Login")
  end
end