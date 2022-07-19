require 'rails_helper'

RSpec.describe 'admin app show' do

  it 'can approve a pet for adoption' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: false, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)

    visit "/admin/apps/#{app_1.id}"
    within "#pet_#{pet_1.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")

    within "#pet_#{pet_1.id}" do
      expect(page).to_not have_button('Approve')
      expect(page).to_not have_button('Reject')
      expect(page).to have_content('Approved')
    end
  end

  it 'can reject a pet for adoption' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: false, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)

    visit "/admin/apps/#{app_1.id}"
    within "#pet_#{pet_1.id}" do
      click_button 'Reject'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")

    within "#pet_#{pet_1.id}" do
      expect(page).to_not have_button('Reject')
      expect(page).to_not have_button('Approve')
      expect(page).to have_content('Rejected')
    end
  end

  it 'approval/rejection doesnt affect other applications for that same pet' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    app_2 = App.create!(name: "John", address: "22 Dexter St", city: "Denver", state: "CO", zip: "80200", description: "123", status: "pending")
    app_3 = App.create!(name: "Terry", address: "8080 Elm St", city: "Boulder", state: "CO", zip: "80222", description: "LOL", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_1, app: app_2)
    PetApp.create!(pet: pet_1, app: app_3)
    
    
    visit "/admin/apps/#{app_1.id}"
    within "#pet_#{pet_1.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")

    within "#pet_#{pet_1.id}" do
      expect(page).to_not have_button('Reject')
      expect(page).to_not have_button('Approve')
      expect(page).to have_content('Approved')
    end

    visit "/admin/apps/#{app_2.id}"
    within "#pet_#{pet_1.id}" do
      click_button 'Reject'
    end

    expect(current_path).to eq("/admin/apps/#{app_2.id}")

    within "#pet_#{pet_1.id}" do
      expect(page).to_not have_button('Reject')
      expect(page).to_not have_button('Approve')
      expect(page).to have_content('Rejected')
    end

    visit "/admin/apps/#{app_3.id}"
    within "#pet_#{pet_1.id}" do
      click_button 'Reject'
    end

    expect(current_path).to eq("/admin/apps/#{app_3.id}")

    within "#pet_#{pet_1.id}" do
      expect(page).to_not have_button('Reject')
      expect(page).to_not have_button('Approve')
      expect(page).to have_content('Rejected')
    end
  end

  it 'can changed app status to accepted when all pets approved' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)
    PetApp.create!(pet: pet_3, app: app_1)

    visit "/admin/apps/#{app_1.id}"
    expect(page).to have_content('Status: pending')
    
    within "#pet_#{pet_1.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')

    within "#pet_#{pet_2.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')

    within "#pet_#{pet_3.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: accepted')
  end

  it 'can changed app status to rejected when any pets rejected' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)
    PetApp.create!(pet: pet_3, app: app_1)

    visit "/admin/apps/#{app_1.id}"
    expect(page).to have_content('Status: pending')
    
    within "#pet_#{pet_1.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')

    within "#pet_#{pet_2.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')

    within "#pet_#{pet_3.id}" do
      click_button 'Reject'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: rejected')
  end

  it 'can make pet unadoptable upon app accepted' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_2, app: app_1)

    visit "/admin/apps/#{app_1.id}"
    expect(page).to have_content('Status: pending')
    
    within "#pet_#{pet_1.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')

    within "#pet_#{pet_2.id}" do
      click_button 'Approve'
    end

    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: accepted')

    expect(pet_1.reload.adoptable).to be(false)
    expect(pet_2.reload.adoptable).to be(false)
    
    visit "/pets/#{pet_1.id}"
    expect(page).to have_content("Adoptable: false")

    visit "/pets/#{pet_2.id}"
    expect(page).to have_content("Adoptable: false")
  end
  
  it 'only lets pets have one approved application at a time' do
    app_1 = App.create!(name: "Bob", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "ABC", status: "pending")
    app_2 = App.create!(name: "John", address: "22 Dexter St", city: "Denver", state: "CO", zip: "80200", description: "123", status: "pending")
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    
    PetApp.create!(pet: pet_1, app: app_1)
    PetApp.create!(pet: pet_1, app: app_2)
    
    visit "/admin/apps/#{app_1.id}"
    expect(page).to have_content('Status: pending')
    
    visit "/admin/apps/#{app_2.id}"
    expect(page).to have_content('Status: pending')
    
    within "#pet_#{pet_1.id}" do
      click_button 'Approve'
    end
    
    expect(current_path).to eq("/admin/apps/#{app_2.id}")
    expect(page).to have_content('Status: accepted')
    
    visit "/admin/apps/#{app_1.id}"
    
    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to have_content('Status: pending')
    
    within "#pet_#{pet_1.id}" do
      expect(page).to have_content("Approved elsewhere")
      expect(page).to_not have_button("Approve")
      expect(page).to have_button("Reject")
      click_button 'Reject'
    end
    
    expect(current_path).to eq("/admin/apps/#{app_1.id}")
    expect(page).to_not have_button("Approve")
    expect(page).to_not have_button("Reject")
    expect(page).to have_content("Rejected")
  end
end