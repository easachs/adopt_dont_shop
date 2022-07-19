require 'rails_helper'

RSpec.describe 'Admin Shelters Show Page' do
  it 'returns the shelter name and full address' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content(shelter.name)
    expect(page).to have_content(shelter.address)
    expect(page).to have_content(shelter.city)
    expect(page).to have_content(shelter.zip)
  end
  #   Average Pet Age
  #
  # As a visitor
  # When I visit an admin shelter show page
  # Then I see a section for statistics
  # And in that section I see the average age of all adoptable pets for that shelter
  it 'has a statistics section showing the average age of all adoptable pets for that shelter' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: false, age: 7, breed: 'shih tzu', name: 'Lucifer', shelter_id: shelter.id)
    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content("Average age of adoptable pets: 2")
  end
end
