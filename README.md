# Voidfront Realms Elite

Voidfront Realms Elite is a web-based science fiction strategy game inspired by classic BBS door games like Solar Realms Elite. Players manage their own space empire, starting with a single star system and expanding across the galaxy through resource management, technological research, and strategic decision-making.

## Game Overview

In Voidfront Realms Elite, you take on the role of an empire leader in a vast, mysterious universe. Your journey begins with a single star system, and through careful management of resources, strategic expansion, and diplomatic relations, you'll build a thriving interstellar civilization.

Key features include:
- **Empire Management**: Govern your empire's resources, taxation, and growth strategy
- **Star System Control**: Administer and develop different types of star systems
- **Population Growth**: Watch your empire grow based on your tax policies and system types
- **Economic Strategy**: Balance taxation and population growth to maximize your empire's potential
- **Scheduled Maintenance**: Experience daily empire maintenance cycles that update your resources
- **Building System**: Construct, upgrade, and demolish buildings to enhance your star systems

## Technical Details

- **Framework**: Ruby on Rails 7.1+
- **Testing**: RSpec with feature tests, model tests, and job tests
- **Styling**: TailwindCSS with a custom space-themed color palette
- **Database**: SQLite
- **Authentication**: Custom implementation using BCrypt (no Devise)
- **Background Jobs**: Sidekiq with sidekiq-scheduler for maintenance tasks
- **Ruby Version**: 3.2.2
- **Procfile**: Uses Foreman/bin/dev to run Rails, Sidekiq, and TailwindCSS concurrently

## Setup Instructions

### Prerequisites
- Ruby 3.4.4
- Redis 8.0.2 (for Sidekiq)
- Node.js 22.15.0
- Yarn 1.22.19 (for TailwindCSS)

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/voidfront.git
cd voidfront
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Set up the database
```bash
bin/rails db:create db:migrate
```

4. Seed the database with building types and (optionally) a sample empire
```bash
bin/rails db:seed
```

   - The seed file creates core building types. To see a sample building, ensure you have a user, an empire, and a star system. You can create these via the Rails console:
```ruby
# In rails console
y = User.create!(email: "test@example.com", password: "password")
e = Empire.create!(user: y, name: "Test Empire")
s = StarSystem.create!(empire: e, name: "Sol", system_type: "terrestrial")
```
   - Then re-run `bin/rails db:seed` to create a sample building in your star system.

5. Start the server, worker, and CSS compiler
```bash
bin/dev
```

The application will be available at http://localhost:3000

### Running Tests

Run the test suite with:
```bash
bundle exec rspec
```

Check test coverage with SimpleCov (results in coverage/ directory):
```bash
COVERAGE=true bundle exec rspec
```

#### Testing Notes
- Uses [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner) with truncation for feature tests to ensure database state is visible across Capybara and Rails processes.
- Feature tests for modals and JavaScript use Selenium with headless Chrome. Progressive enhancement ensures modals are accessible and testable in both JS and non-JS environments.
- Accessibility and progressive enhancement are prioritized for all UI features, including modals.

## Game Mechanics

### Empire Management
- Each player controls one empire with its own resources (credits, minerals, energy, food)
- Tax policies affect population growth and revenue
- Daily maintenance cycles update your empire's resources and population

### Star Systems
- Different system types (terrestrial, ocean, desert, tundra, gas_giant, asteroid_belt) have unique properties
- Population growth varies by system type and is affected by tax rates
- Systems have maximum population and building capacity limits

### Resource Management
- Credits: Generated through taxation
- Minerals, Energy, Food: Base resources for building and maintenance

### Building System
- Construct, upgrade, and demolish buildings in your star systems
- Each building type (e.g., Government Administration, Mining Facility, Power Plant, Research Laboratory) provides unique benefits
- Buildings have construction and demolition times, costs, and effects
- Some buildings are unique per system, others can be built multiple times
- Building status is updated during scheduled maintenance cycles
- Building construction and demolition use accessible, progressively enhanced modals for confirmation

## Development Approach

This project follows Test-Driven Development (TDD) principles:
1. Write tests first (feature tests and model tests)
2. Implement the minimum code required to pass those tests
3. Refactor for improved design

The application is built with a clean, modular architecture:
- **Models**: Core domain objects (User, Empire, StarSystem, Building, BuildingType)
- **Services**: Encapsulated business logic (EmpireBuilderService)
- **Jobs**: Background processing (MaintenanceJob, ScheduleMaintenanceJob)
- **Controllers**: Minimal request handling with business logic in services

## Project Status

Voidfront Realms Elite is currently under active development. Core gameplay systems including user authentication, empire management, star system management, and the building system are functional. Future updates will include ship building, research, exploration, and more advanced gameplay features.
