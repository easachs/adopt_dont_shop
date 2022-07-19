require 'rails_helper'

RSpec.describe 'Admin Shelters Index' do
  # Admin Shelters Index
  # As a visitor
  # When I visit the admin shelter index ('/admin/shelters')
  # Then I see all Shelters in the system listed in reverse alphabetical order by name

  it 'lists all shelters in reverse alpha order' do
    shelter_a = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_c = Shelter.create(name: 'Centennial shelter', city: 'Centennial, CO', foster_program: false, rank: 5)
    shelter_b = Shelter.create(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 3)

    visit "/admin/shelters"
    expect(shelter_c.name).to appear_before(shelter_b.name)
    expect(shelter_b.name).to appear_before(shelter_a.name)
  end

  # Shelters with Pending Applications
  #
  # As a visitor
  # When I visit the admin shelter index ('/admin/shelters')
  # Then I see a section for "Shelters with Pending Applications"
  # And in this section I see the name of every shelter that has a pending application

  it 'has a section for Shelters with Pending Applications' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: shelter_2.id)
    pet_4 = Pet.create!(adoptable: true, age: 1, breed: 'orange tabby shorthair', name: 'Lasagna', shelter_id: shelter.id)
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    app_2 = App.create!(name: "Jack", address: "2021 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_3, app: app_2)
    visit "/admin/shelters"

    within "#pending" do
      expect(page).to have_content(shelter_2.name)
      expect(page).to_not have_content(shelter.name)
    end
  end

  # Shelters with Pending Applications Listed Alphabetically
  #
  # As a visitor
  # When I visit the admin shelter index ('/admin/shelters')
  # And I look in the section for shelters with pending applications
  # Then I see all those shelters are listed alphabetically

  it ' lists shelters with pending applications alphabetically' do
    shelter_1 = Shelter.create!(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 8)
    shelter_3 = Shelter.create!(name: 'Commerce City shelter', city: 'Commerce City, CO', foster_program: false, rank: 7)
    shelter_4 = Shelter.create!(name: 'Centennial shelter', city: 'Centennial, CO', foster_program: false, rank: 6)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter_1.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter_2.id)
    pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: shelter_3.id)
    pet_4 = Pet.create!(adoptable: true, age: 1, breed: 'orange tabby shorthair', name: 'Lasagna', shelter_id: shelter_4.id)
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    app_2 = App.create!(name: "Jack", address: "2021 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    app_3 = App.create!(name: "Jill", address: "76 Orchard Blvd", city: "Denver", state: "CO", zip: "80212", description: "ABC", status: "pending")
    app_4 = App.create!(name: "Carol", address: "100 Peninsula Pl", city: "Denver", state: "CO", zip: "80218", description: "ABC", status: "pending")
    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_2)
    PetApp.create!(pet: pet_3, app: app_3)
    PetApp.create!(pet: pet_4, app: app_4)
    visit "/admin/shelters"

    within "#pending" do
      expect(shelter_2.name).to appear_before(shelter_4.name)
      expect(shelter_4.name).to appear_before(shelter_3.name)
      expect(page).to_not have_content(shelter_1.name)
    end
  end
end
