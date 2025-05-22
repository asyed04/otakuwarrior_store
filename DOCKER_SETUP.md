# Docker Setup for OtakuWarrior Store

This document explains the Docker configuration for the OtakuWarrior Store application.

## Docker Files

The following files have been set up for Docker:

1. **Dockerfile**: Defines how to build the application container
2. **docker-compose.yml**: Configures the services needed to run the application
3. **bin/docker-entrypoint**: Script that runs when the container starts
4. **.dockerignore**: Specifies which files to exclude from the Docker build

## How It Works

### Dockerfile

The Dockerfile uses a multi-stage build process:
- First stage (build): Installs dependencies and precompiles assets
- Second stage (final): Creates a smaller production image with only what's needed to run the app

### docker-compose.yml

The docker-compose.yml file:
- Configures the web service to run the Rails application
- Maps port 3000 from the container to your local machine
- Sets up volumes to persist the SQLite database and uploaded files
- Configures environment variables for production mode

### docker-entrypoint

The docker-entrypoint script:
- Runs database migrations when the container starts
- Seeds the database if it hasn't been seeded before
- Ensures the storage directory exists

## Database

The application uses SQLite for all environments, including production in Docker. The database file is stored in a Docker volume to persist data between container restarts.

## Running the Application

To run the application with Docker:

1. Set your Rails master key as an environment variable:
   ```
   export RAILS_MASTER_KEY=your_master_key_here
   ```
   On Windows PowerShell:
   ```
   $env:RAILS_MASTER_KEY="your_master_key_here"
   ```

2. Build and start the Docker container:
   ```
   docker-compose build
   docker-compose up
   ```

3. Access the application at http://localhost:3000

4. To stop the containers:
   ```
   docker-compose down
   ```

## Data Persistence

The application uses Docker volumes to persist:
- The SQLite database
- Uploaded files (product images)

This ensures your data remains intact even when containers are stopped or removed.

## Deployment Considerations

For a production deployment, you might want to consider:
- Using environment variables for sensitive configuration
- Setting up proper logging
- Configuring a reverse proxy like Nginx for SSL termination
- Regular database backups