# OtakuWarrior Store

OtakuWarrior Store is an e-commerce platform specializing in anime and manga merchandise. This Rails application provides a complete shopping experience with product browsing, cart management, checkout, and order tracking.

## Git Version Control

This project uses Git for version control and follows industry best practices:

### Git Requirements Met

- **32+ Commits**: The repository contains 36+ commits, each with descriptive messages explaining the changes made.
- **3+ Branches**: The repository uses a feature-based branching strategy with 3 branches:
  - `main`: The stable, production-ready code
  - `feature/customer-profile`: Customer profile management functionality
  - `feature/order-status-fixes`: Order status tracking and checkout improvements
- **GitHub Remote Repository**: The local repository is linked to a GitHub remote repository.
- **Feature Branch Development**: Two major features were developed in separate branches and merged into main.
- **Descriptive Commit Messages**: All commits have clear, descriptive messages.

### Git Review Guide

For a comprehensive guide on how to review the Git history of this project, please see the [Git Review Guide](GIT_REVIEW_GUIDE.md). This document provides detailed instructions on:

- Viewing commit messages and history
- Examining changes in specific commits
- Comparing changes between commits
- Understanding the branching and merging strategy
- Reviewing file history

## Application Setup

### Ruby version
- Ruby 3.2.2
- Rails 7.0.8

### System dependencies
- SQLite3 for development
- Active Storage for image uploads
- Devise for authentication
- Stripe for payment processing

### Configuration
1. Clone the repository
   ```
   git clone git@github.com:asyed04/otakuwarrior_store.git
   cd otakuwarrior_store
   ```

2. Install dependencies
   ```
   bundle install
   yarn install
   ```

3. Set up the database
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server
   ```
   rails server
   ```

### Docker Setup
You can also run the application using Docker:

1. Make sure you have Docker and Docker Compose installed on your system

2. Set your Rails master key as an environment variable:
   ```
   export RAILS_MASTER_KEY=your_master_key_here
   ```
   On Windows PowerShell:
   ```
   $env:RAILS_MASTER_KEY="your_master_key_here"
   ```

3. Build and start the Docker container:
   ```
   docker-compose build
   docker-compose up
   ```

4. Access the application at http://localhost:3000

5. To stop the containers:
   ```
   docker-compose down
   ```

### Testing
- Cypress is used for end-to-end testing
- Run tests with:
  ```
  yarn cypress open
  ```

## Features

- Product browsing with category filtering
- Search functionality
- Shopping cart
- User authentication and profiles
- Order processing and tracking
- Admin dashboard for product and order management
