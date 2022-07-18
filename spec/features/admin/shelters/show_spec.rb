require 'rails_helper'

RSpec.describe 'Admin Shelters Show Page' do
  it 'returns the shelter name and full address' do
    # As a visitor
    # When I visit an admin shelter show page
    # Then I see that shelter's name and full address
    #
    # NOTE: Your query should only return the necessary data to complete the story
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '14 Maple St', zip: '81110')

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content(shelter.name)
    expect(page).to have_content(shelter.address)
    expect(page).to have_content(shelter.city)
    expect(page).to have_content(shelter.zip)
  end
end
