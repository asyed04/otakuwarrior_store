# PostgreSQL Migration Guide

This guide will help you migrate your Rails application from SQLite to PostgreSQL.

## Prerequisites

1. Install PostgreSQL on your system if you haven't already:
   - For Windows: Download and install from [PostgreSQL Downloads](https://www.postgresql.org/download/windows/)
   - For WSL/Ubuntu: `sudo apt update && sudo apt install postgresql postgresql-contrib`

2. Install the pg gem:
   ```
   bundle install
   ```

## Setting up PostgreSQL

1. Start the PostgreSQL service:
   - Windows: It should start automatically after installation
   - WSL/Ubuntu: `sudo service postgresql start`

2. Create a PostgreSQL user (if needed):
   ```
   # For Windows, use psql from the Start menu
   # For WSL/Ubuntu:
   sudo -u postgres psql
   ```

3. In the PostgreSQL prompt, create a user and databases:
   ```sql
   CREATE USER your_username WITH PASSWORD 'your_password';
   ALTER USER your_username WITH SUPERUSER;
   CREATE DATABASE otakuwarrior_store_development;
   CREATE DATABASE otakuwarrior_store_test;
   CREATE DATABASE otakuwarrior_store_production;
   GRANT ALL PRIVILEGES ON DATABASE otakuwarrior_store_development TO your_username;
   GRANT ALL PRIVILEGES ON DATABASE otakuwarrior_store_test TO your_username;
   GRANT ALL PRIVILEGES ON DATABASE otakuwarrior_store_production TO your_username;
   \q
   ```

4. Update your environment variables or the database.yml file with your PostgreSQL credentials.

## Importing Data

1. Import the PostgreSQL SQL file:
   ```
   # For Windows:
   psql -U your_username -d otakuwarrior_store_development -f storage/all_postgres.sql

   # For WSL/Ubuntu:
   psql -U your_username -d otakuwarrior_store_development -f /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/storage/all_postgres.sql
   ```

2. If you encounter any errors during import, check the error message and fix the SQL file as needed.

## Updating Rails Application

1. Update your Rails application to use PostgreSQL:
   ```
   rails db:environment:set RAILS_ENV=development
   ```

2. Restart your Rails server:
   ```
   rails server
   ```

## Troubleshooting

If you encounter any issues:

1. Check PostgreSQL logs for detailed error messages.
2. Ensure PostgreSQL service is running.
3. Verify database.yml configuration matches your PostgreSQL setup.
4. Make sure the pg gem is properly installed.

For "relation does not exist" errors:
- Ensure tables are created in the correct order (tables with foreign keys should be created after the referenced tables).
- Check if all required tables are included in the SQL file.