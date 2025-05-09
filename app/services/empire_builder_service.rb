class EmpireBuilderService
  def initialize(user)
    @user = user
  end

  def create_empire(name = nil)
    empire_name = name || generate_empire_name

    ActiveRecord::Base.transaction do
      empire = Empire.create!(
        user: @user,
        name: empire_name
      )

      unless empire.save
        return empire
      end

      create_starting_star_system(empire)

      empire
    end
  rescue => e
    empire = Empire.new(user: @user)
    empire.errors.add(:name, e.message)
    empire
  end
  
  private

    def generate_empire_name
      10.times do
        name = "#{Faker::Adjective.positive}-#{Faker::Hipster.word}"
        return name unless Empire.exists?(name: name)
      end

      "#{Faker::Adjective.positive}-#{Faker::Hipster.word}-#{Faker::Number.hexadecimal(digits: 4)}"
    end

    def create_starting_star_system(empire)
      StarSystem.create!(
      name: Faker::Space.star,
      system_type: "terrestrial",
      max_population: 1000,
      current_population: 500,
      max_buildings: 10,
      loyalty: 100,
      empire: empire
      )
    end
end