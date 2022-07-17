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
    save_and_open_page
    expect(shelter_c.name).to appear_before(shelter_b.name)
    expect(shelter_b.name).to appear_before(shelter_a.name)
  end
end
