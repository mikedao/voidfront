# frozen_string_literal: true

# spec/features/buildings/building_construction_spec.rb
require 'rails_helper'

RSpec.describe 'Building Construction', type: :feature do
  let(:user) { create(:user) }
  let(:empire) { create(:empire, user: user, credits: 1000, minerals: 500, energy: 500) }
  let(:star_system) { create(:star_system, empire: empire, name: 'Alpha Centauri') }
  let!(:building_type) do
    create(:building_type, key: 'government_administration',
                           name: 'Government Administration',
                           description: 'Increases tax revenue by 5%',
                           unique_per_system: true,
                           level_data: {
                             '1' => {
                               construction_time: 8.hours.to_i,
                               demolition_time: 1.hour.to_i,
                               cost: {
                                 credits: 200,
                                 minerals: 100,
                                 energy: 125
                               },
                               effects: {
                                 tax_modifier: 0.05
                               }
                             }
                           })
  end

  before do
    # Log in the user
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
  end

  scenario 'User can see available buildings on the star system page' do
    visit edit_star_system_path(star_system)

    expect(page).to have_content('Available Buildings')
    expect(page).to have_content('Government Administration')
    expect(page).to have_content('Increases tax revenue by 5%')
    expect(page).to have_content('Cost: 200 Credits, 100 Minerals, 125 Energy')
  end

  scenario 'User can start construction of a building', js: true do
    visit edit_star_system_path(star_system)

    expect(page).to have_button('Build')

    # Debug: Check if the hidden fields exist
    expect(page).to have_field('building[building_type_id]', type: 'hidden')
    expect(page).to have_field('building[star_system_id]', type: 'hidden')

    # Get the initial count
    initial_count = Building.count
    puts "Initial building count: #{initial_count}"

    # Click Build button to open modal
    click_button 'Build'

    # Modal should be visible
    expect(page).to have_content('Confirm Building Construction')
    expect(page).to have_content('Government Administration')
    expect(page).to have_content('200 Credits')
    expect(page).to have_content('100 Minerals')
    expect(page).to have_content('125 Energy')

    # Click Confirm Construction button in the modal
    within('#buildModal') do
      click_button 'Confirm Construction'
    end

    # Debug: Check if form was submitted
    puts "Current URL after form submission: #{page.current_url}"
    puts "Page has success message: #{page.has_content?('Building construction started')}"
    puts "Page has error message: #{page.has_content?('Error')}"

    # Debug: Check the building count after form submission
    puts "Building count after form submission: #{Building.count}"

    # Check that the building was created
    expect(Building.count).to eq(initial_count + 1)

    expect(page).to have_content('Building construction started')

    # Check resources were deducted
    expect(empire.reload.credits).to eq(800)
    expect(empire.minerals).to eq(400)
    expect(empire.energy).to eq(375)

    # Check building exists and is under construction
    building = Building.last
    expect(building.building_type).to eq(building_type)
    expect(building.star_system).to eq(star_system)
    expect(building.status).to eq('under_construction')
    expect(building.level).to eq(1)
    expect(building.construction_start).not_to be_nil
    expect(building.construction_end).not_to be_nil
  end

  scenario "User cannot build if they don't have enough resources" do
    # Update empire to have insufficient resources
    empire.update(credits: 100, minerals: 50, energy: 50)

    visit edit_star_system_path(star_system)

    expect(page).to have_button('Insufficient resources', disabled: true)
    expect(page).to have_content('Insufficient resources')
  end

  scenario 'User cannot build if the star system is at max buildings' do
    # Update star system to be at max buildings
    star_system.update(max_buildings: 1)
    create(:building, star_system: star_system, building_type: building_type, status: 'operational')

    visit edit_star_system_path(star_system)

    expect(page).to have_button('Already built', disabled: true)
    expect(page).to have_content('Already built')
  end

  scenario 'User cannot build a unique building twice' do
    # Create the building first
    create(:building, star_system: star_system, building_type: building_type, status: 'operational')

    visit edit_star_system_path(star_system)

    expect(page).to have_content('Already built')
    expect(page).not_to have_button('Build')
  end

  scenario 'User can see buildings under construction' do
    # Create a building under construction
    create(:building, :under_construction,
           star_system: star_system,
           building_type: building_type,
           construction_start: 2.hours.ago,
           construction_end: 6.hours.from_now)

    visit edit_star_system_path(star_system)

    expect(page).to have_content('Buildings Under Construction')
    expect(page).to have_content('Government Administration')
    expect(page).to have_content('Construction Progress')

    # Check for progress bar (25% complete)
    expect(page).to have_css(".progress-bar[style*='width: 25%']")
  end

  scenario 'User can see operational buildings' do
    # Create a completed building
    create(:building, star_system: star_system,
                      building_type: building_type, status: 'operational')

    visit edit_star_system_path(star_system)

    expect(page).to have_content('Operational Buildings')
    expect(page).to have_content('Government Administration')
    expect(page).to have_content('Increases tax revenue by 5%')
    expect(page).to have_button('Demolish')
  end

  scenario 'User can demolish a building' do
    # Create a completed building
    building = create(:building, star_system: star_system,
                                 building_type: building_type, status: 'operational')

    visit edit_star_system_path(star_system)

    expect do
      click_button 'Demolish'
    end.to change { building.reload.status }.from('operational').to('being_demolished')

    expect(page).to have_content('Building demolition started')
    expect(page).to have_content('Buildings Being Demolished')
    expect(page).to have_content('Government Administration')
  end
end
