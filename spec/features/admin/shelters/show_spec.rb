require 'rails_helper'

RSpec.describe 'Admin Shelters Show Page' do
  it 'returns the shelter name and full address' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content(shelter.name)
    expect(page).to have_content(shelter.address)
    expect(page).to have_content(shelter.city)
    expect(page).to have_content(shelter.zip)
  end

  it 'has a statistics section showing the average age of all adoptable pets for the shelter' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: false, age: 7, breed: 'shih tzu', name: 'Lucifer', shelter_id: shelter.id)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content("Statistics")
    expect(page).to have_content("Average age of adoptable pets: 2")
  end

  it 'has a statistics section showing the number of adoptable pets for the shelter' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: false, age: 7, breed: 'shih tzu', name: 'Lucifer', shelter_id: shelter.id)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content("Number of adoptable pets: 2")
  end

  it 'shows the number of pets that have beend adopted from the shelter' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 7, breed: 'shih tzu', name: 'Lucifer', shelter_id: shelter.id)
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    app_2 = App.create!(name: "John", address: "22 Dexter St", city: "Denver", state: "CO", zip: "80200", description: "123", status: "pending")
    app_3 = App.create!(name: "Juli", address: "562 8th Ave", city: "Denver", state: "CO", zip: "80212", description: "123", status: "pending")
    PetApp.create!(pet: pet_1, app: app_1, approval: 'approved')
    PetApp.create!(pet: pet_1, app: app_2, approval: 'approved')
    PetApp.create!(pet: pet_1, app: app_2)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content("Number of adopted pets: 2")
  end
end
