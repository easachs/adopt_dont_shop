class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_by_alpha
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def self.with_pending_applications
    joins(pets: :apps).where(pets: { apps: { status: 'pending' }})
  end

  def self.name_and_address(id)
    find_by_sql("SELECT name, city, address, zip FROM shelters WHERE shelters.id = #{id}").first
  end

  def self.alpha_sort
    order(:name)
  end

  def num_adoptable
    adoptable_pets.count
  end

  def num_approved
    pets.joins(:pet_apps).where("pet_apps.approval = 'approved'").count
  end

  def avg_age
    adoptable_pets.average(:age)
  end

  def pending_apps
    App.where(status: 'pending')
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end
end
