require 'rails_helper'

RSpec.describe "Home Page", type: :feature do
  before do
    visit root_path
  end

  it "displays the game title" do
    expect(page).to have_content("Voidfront Realms Elite")
  end

  it "displays the welcome message" do
    expect(page).to have_content("Welcome to Voidfront Realms Elite")
  end

  it "displays the game description" do
    expect(page).to have_content("Manage your own star empire")
  end

  it "has a 'Play Now' button" do
    expect(page).to have_link("Play Now")
  end

  it "has a 'Learn More' button" do
    expect(page).to have_link("Learn More")
  end

  it "displays game features" do
    expect(page).to have_content("Resource Management")
    expect(page).to have_content("Fleet Construction")
    expect(page).to have_content("Research & Technology")
  end
end