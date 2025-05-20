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

## Technical Details

- **Framework**: Ruby on Rails 7.1+
- **Testing**: RSpec with feature tests, model tests, and job tests
- **Styling**: TailwindCSS with a custom space-themed color palette
- **Database**: SQLite
- **Authentication**: Custom implementation using BCrypt (no Devise)
- **Background Jobs**: Sidekiq with sidekiq-scheduler for maintenance tasks
- **Ruby Version**: 3.2.2

## Setup Instructions

### Prerequisites
- Ruby 3.2.2
- Redis (for Sidekiq)
- Node.js and Yarn (for TailwindCSS)

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

4. Start the server, worker, and CSS compiler
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

## Development Approach

This project follows Test-Driven Development (TDD) principles:
1. Write tests first (feature tests and model tests)
2. Implement the minimum code required to pass those tests
3. Refactor for improved design

The application is built with a clean, modular architecture:
- **Models**: Core domain objects (User, Empire, StarSystem)
- **Services**: Encapsulated business logic (EmpireBuilderService)
- **Jobs**: Background processing (MaintenanceJob, ScheduleMaintenanceJob)
- **Controllers**: Minimal request handling with business logic in services

## Project Status

Voidfront Realms Elite is currently under active development. Core gameplay systems including user authentication, empire management, and star system management are functional. Future updates will include ship building, research, exploration, and more advanced gameplay features.
