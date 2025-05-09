require 'rails_helper'

RSpec.describe "Authorzation", type: :feature do
  let(:user) { create(:user) }
  let!(:empire) { create(:empire, name: "Test Empire", user: user) }
  let!(:star_system) { create(:star_system, name: "Alpha Centauri", system_type: "terrestrial", empire: empire) }
   
  describe "Accessing protected resources" do
    context "when user is not authenticated" do
      it "redirects to login page when trying to access dashboard" do
        visit dashboard_path
        expect(current_path).to eq(root_path)
        expect(page).to have_content("You must be logged in to access this page.")
      end
    end

    context "when user is authenticated" do
      before do
        visit login_path
        fill_in "Email", with: user.email
        fill_in "Password", with: "password123"
        click_button "Log in"
      end

      it "alllows access to dashboard" do
        visit dashboard_path
        expect(current_path).to eq(dashboard_path)
        expect(page).to have_content("Dashboard")
      end
    end
  end

  describe "accessing public resources" do
    it "allows access to home page without authentication" do
      visit root_path
      expect(current_path).to eq(root_path)
    end
    
    it "allows access to login page without authentication" do
      visit login_path
      expect(current_path).to eq(login_path)
    end
    
    it "allows access to registration page without authentication" do
      visit new_user_path
      expect(current_path).to eq(new_user_path)
    end
  end
end