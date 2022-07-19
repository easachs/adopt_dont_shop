require 'rails_helper'

RSpec.describe 'app show' do
  it 'displays a link to all pets' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    visit "/apps/#{app_1.id}"

    expect(page).to have_content("Name: Bob")
    expect(page).to have_content("Address: 2020 Maple Lane")
    expect(page).to have_content("Name: Bob")

    expect(page).to have_link("Pets")
    click_link("Pets")
    expect(page).to have_current_path('/pets')
  end

  it 'displays a link to all shelters' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    visit "/apps/#{app_1.id}"

    expect(page).to have_link("Shelters")
    click_link("Shelters")
    expect(page).to have_current_path('/shelters')
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it 'displays a link to all veterinary offices' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    visit "/apps/#{app_1.id}"

    expect(page).to have_link("Veterinary Offices")
    click_link("Veterinary Offices")
    expect(page).to have_current_path('/veterinary_offices')
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it 'displays a link to all veterinarians' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    visit "/apps/#{app_1.id}"

    expect(page).to have_link("Veterinarians")
    click_link("Veterinarians")
    expect(page).to have_current_path('/veterinarians')
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it 'displays app attributes' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    app_2 = App.create!(name: "John", address: "2021", city: "San Fran", state: "CA", zip: "90909", description: "XYZ", status: "in progress")
    visit "/apps/#{app_1.id}"

    expect(page).to have_content(app_1.name)
    expect(page).to have_content(app_1.address)
    expect(page).to have_content(app_1.city)
    expect(page).to have_content(app_1.state)
    expect(page).to have_content(app_1.zip)
    expect(page).to have_content(app_1.description)
    expect(page).to_not have_content(app_2.name)
  end

  it 'displays pets wanting to be adopted as links' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: false, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)

    visit "/apps/#{app_1.id}"

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
    click_link "#{pet_1.name}"
    expect(current_path).to eq("/pets/#{pet_1.id}")
  end

  it 'can search for pets on in progress application' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit "/apps/#{app_1.id}"

    expect(page).to have_content('Search')
    fill_in 'Search', with: 'Lobster'
    click_button 'Submit'
    expect(page).to have_current_path("/apps/#{app_1.id}?search=Lobster")
    expect(page).to have_content('Lobster')
  end

  it 'doesnt search if app status not in progress' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit "/apps/#{app_1.id}"

    expect(page).to_not have_content('Search')
  end

  it 'can add a pet to an application' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit "/apps/#{app_1.id}"

    expect(page).to have_content('Search')
    fill_in 'Search', with: 'Lobster'
    click_button 'Submit'
    expect(page).to have_current_path("/apps/#{app_1.id}?search=Lobster")
    expect(page).to have_content('Lobster')
    click_on 'Adopt this Pet'
    expect(current_path).to eq("/apps/#{app_1.id}")
    expect(page).to have_content('Lobster')
    expect(page).to have_content('Search')
    fill_in 'Search', with: 'Lucille Bald'
    click_button 'Submit'
    expect(page).to have_current_path("/apps/#{app_1.id}?search=Lucille+Bald")
    expect(page).to have_content('Lucille Bald')
    click_on 'Adopt this Pet'
    expect(current_path).to eq("/apps/#{app_1.id}")
    expect(page).to have_content('Lucille Bald')
    expect(page).to have_content('Lobster')
    click_link 'Lobster'
    expect(current_path).to eq("/pets/#{pet_2.id}")
  end

  it 'can submit an application with pets' do
    # without pets
    no_pet_app = App.create!(name: "Dave", address: "22 Dexter St", city: "Denver", state: "CO", zip: "80200", description: "123", status: "in progress")
    visit "/apps/#{no_pet_app.id}"
    expect(page).to_not have_content('Submit Application')

    # with pets
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: false, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)

    visit "/apps/#{app_1.id}"

    within '#submit' do
      fill_in 'Description', with: 'I love dogs'
      click_button 'Submit Application'
    end

    expect(current_path).to eq("/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')
    expect(page).to have_content('Lobster')
    expect(page).to_not have_content('Beethoven')
    expect(page).to_not have_content('Search')
  end

  it 'cannot submit a petless application' do
    # without pets
    no_pet_app = App.create!(name: "Dave", address: "22 Dexter St", city: "Denver", state: "CO", zip: "80200", description: "123", status: "in progress")
    visit "/apps/#{no_pet_app.id}"
    expect(page).to_not have_content('Submit Application')
  end

  it 'can search for pet names on applications' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)
    visit "/apps/#{app_1.id}"
    fill_in 'Search', with: "Ba"
    click_on("Submit")

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
  end

  it 'can search for case insensitive pets by name on applications' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "in progress")
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)
    visit "/apps/#{app_1.id}"
    fill_in 'Search', with: "bA"
    click_on("Submit")

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
  end
end
