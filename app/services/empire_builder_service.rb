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

      create_starting_star_system(empire)

      empire
    end
  end
  
  private

    def generate_empire_name
      Faker::Space.galaxy
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