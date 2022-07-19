require 'rails_helper'

RSpec.describe 'New Apps' do

  it 'has a link to fill out an application' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)

    visit '/pets'
    click_on('Start an Application')
    expect(current_path).to eq('/apps/new')
    fill_in('Name', with: app_1.name)
    fill_in('Address', with: app_1.address)
    fill_in('City', with: app_1.city)
    fill_in('State', with: app_1.state)
    fill_in('Zip', with: app_1.zip)

    click_on('Submit')
    expect(current_path).to eq("/apps/#{App.last.id}")
    expect(page).to have_content(app_1.name)
    expect(page).to have_content(app_1.address)
    expect(page).to have_content(app_1.city)
    expect(page).to have_content(app_1.state)
    expect(page).to have_content(app_1.zip)
    expect(page).to have_content("in progress")
  end

  it 'rejects incomplete application and gives error message' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)

    visit '/apps/new'
    fill_in('Name', with: app_1.name)
    fill_in('Address', with: app_1.address)
    fill_in('City', with: app_1.city)
    # no state
    fill_in('Zip', with: app_1.zip)

    click_on('Submit')
    expect(current_path).to eq("/apps/new")
    expect(page).to have_content("Error")
  end
end
