require 'faker'

PetApp.destroy_all
Pet.destroy_all
Shelter.destroy_all
Veterinarian.destroy_all
VeterinaryOffice.destroy_all
App.destroy_all

shelter_1 = Shelter.create!(name: "Dumb Friends League", city: "Denver", rank: 1, foster_program: true, address: "100 Drury Ln", zip: "80200")
pet_1 = shelter_1.pets.create!(name: "Parker", breed: "Lab", age: 5, adoptable: false)
pet_2 = shelter_1.pets.create!(name: "Rugsby", breed: "Beagle", age: 6, adoptable: true)
pet_3 = shelter_1.pets.create!(name: "Keyba", breed: "Shepherd", age: 7, adoptable: true)

3.times do
  shelter_1.pets.create!(
    name: Faker::Creature::Dog.name,
    breed: Faker::Creature::Dog.breed,
    age: rand(15),
    adoptable: [true, false].sample)
end

shelter_2 = Shelter.create!(name: "Foothills Animal Shelter", city: "Lakewood", rank: 2, foster_program: false, address: "200 Mulberry St", zip: "80201")
pet_4 = shelter_2.pets.create!(name: "Bingly", breed: "Mix", age: 8, adoptable: true)
pet_5 = shelter_2.pets.create!(name: "Juju", breed: "Boston", age: 2, adoptable: false)
pet_6 = shelter_2.pets.create!(name: "Carl", breed: "Bulldog", age: 4, adoptable: false)

3.times do
  shelter_2.pets.create!(
    name: Faker::Creature::Dog.name,
    breed: Faker::Creature::Dog.breed,
    age: rand(15),
    adoptable: [true, false].sample)
end

shelter_3 = Shelter.create!(name: "Denver Animal Shelter", city: "Denver", rank: 3, foster_program: true, address: "300 Cherry Dr", zip: "80202")

6.times do
  shelter_3.pets.create!(
    name: Faker::Creature::Dog.name,
    breed: Faker::Creature::Dog.breed,
    age: rand(15),
    adoptable: [true, false].sample)
end

app_1 = App.create!(name: "Mark", address: "2020 Maple Lane", city: "Denver", state: "CO", zip: "80202", description: "I'm lonely", status: "in progress")
app_2 = App.create!(name: "Tom", address: "4567 Elm St", city: "Centennial", state: "CO", zip: "80209", description: "I'm bored", status: "in progress")
app_3 = App.create!(name: "Jeff", address: "1234 Dahlia Rd", city: "Tampa", state: "FL", zip: "90210", description: "I like turtles", status: "in progress")

5.times do
  App.create!(
    name: Faker::Movies::PrincessBride.character,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip,
    description: [Faker::Movies::PrincessBride.quote, nil].sample,
    status: "in progress")
end

petapp_1 = PetApp.create!(app_id: app_1.id, pet_id: pet_2.id)
petapp_2 = PetApp.create!(app_id: app_1.id, pet_id: pet_4.id)
petapp_3 = PetApp.create!(app_id: app_2.id, pet_id: pet_4.id)

vetoffice_1 = VeterinaryOffice.create!(name: "Park Hill Vet", max_patient_capacity: 15, boarding_services: true)
vet_1 = vetoffice_1.veterinarians.create!(name: "Bob", review_rating: 3, on_call: true)
vet_2 = vetoffice_1.veterinarians.create!(name: "Sam", review_rating: 5, on_call: true)
vet_3 = vetoffice_1.veterinarians.create!(name: "Joe", review_rating: 1, on_call: false)

vetoffice_2 = VeterinaryOffice.create!(name: "Dogtor's Office", max_patient_capacity: 10, boarding_services: false)
vet_4 = vetoffice_2.veterinarians.create!(name: "Fred", review_rating: 2, on_call: false)
vet_5 = vetoffice_2.veterinarians.create!(name: "Bill", review_rating: 4, on_call: true)
vet_6 = vetoffice_2.veterinarians.create!(name: "Doug", review_rating: 5, on_call: false)
