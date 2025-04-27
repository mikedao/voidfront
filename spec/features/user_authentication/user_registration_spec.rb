require 'rails_helper'

RSpec.describe "User Registration", type: :feature do
  scenario "User successfully registers" do
    visit new_user_path

    fill_in "Email", with: "test@example.com"
    fill_in "Username", with: "testuser"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"

    expect {
      click_button "Register"
    }.to change(User, :count).by(1)

    expect(page).to have_content("Registration Successful")
    expect(current_path).to eq(root_path)
  end

  scenario "User attempts to register with invalid information" do
    visit new_user_path
    
    # Leave fields blank to trigger validation errors
    click_button "Register"
    
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Username can't be blank")
    expect(page).to have_content("Password can't be blank")
    
    expect(User.count).to eq(0)
  end

  scenario "User attempts to register with mismatched passwords" do
    visit new_user_path
    
    fill_in "Email", with: "test@example.com"
    fill_in "Username", with: "testuser"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "differentpassword"
    
    click_button "Register"
    
    expect(page).to have_content("Password confirmation doesn't match")
    expect(User.count).to eq(0)
  end

  scenario "User attempts to register with an email that is already taken" do
    # Create a user first
    User.create(email: "taken@example.com", username: "existinguser", password: "password123")
    
    visit new_user_path
    
    fill_in "Email", with: "taken@example.com"
    fill_in "Username", with: "newuser"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    click_button "Register"
    
    expect(page).to have_content("Email has already been taken")
    expect(User.count).to eq(1)
  end
end