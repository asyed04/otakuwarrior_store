# Migrating from SQLite to PostgreSQL

This guide provides instructions for migrating the Otaku Warrior Store application from SQLite to PostgreSQL.

## Why Migrate to PostgreSQL?

PostgreSQL offers several advantages over SQLite:

1. **Better concurrency**: PostgreSQL handles multiple simultaneous connections better than SQLite.
2. **Advanced features**: PostgreSQL provides more advanced database features like full-text search, JSON support, and more.
3. **Scalability**: PostgreSQL is designed to scale with your application as it grows.
4. **Production readiness**: PostgreSQL is more suitable for production environments.

## Migration Steps

### 1. Install PostgreSQL

#### Windows
- Download and install PostgreSQL from [the official website](https://www.postgresql.org/download/windows/)
- Make sure to remember the password you set for the postgres user during installation

#### WSL/Ubuntu
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo service postgresql start
```

### 2. Run the Setup Script

We've provided scripts to help you set up PostgreSQL for this application:

#### Windows
Run the `setup_postgres.bat` script by double-clicking it or running it from the command prompt:
```
setup_postgres.bat
```

#### WSL/Ubuntu
Run the `setup_postgres.sh` script:
```bash
./setup_postgres.sh
```

### 3. Manual Setup (if the script doesn't work)

If the automated script doesn't work, follow these steps:

1. Create the PostgreSQL databases:
```sql
CREATE DATABASE otakuwarrior_store_development;
CREATE DATABASE otakuwarrior_store_test;
CREATE DATABASE otakuwarrior_store_production;
```

2. Import the data:
```bash
# Windows
psql -U postgres -d otakuwarrior_store_development -f storage\all_postgres.sql

# WSL/Ubuntu
psql -U postgres -d otakuwarrior_store_development -f /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/storage/all_postgres.sql
```

3. Set environment variables:
```bash
# Windows
setx POSTGRES_USER "postgres"
setx POSTGRES_PASSWORD "your_password"
setx POSTGRES_HOST "localhost"

# WSL/Ubuntu
export POSTGRES_USER="postgres"
export POSTGRES_PASSWORD="your_password"
export POSTGRES_HOST="localhost"
```

### 4. Verify the Migration

1. Start your Rails server:
```
rails server
```

2. Access your application at http://localhost:3000

3. Test key functionality to ensure everything works correctly:
   - User registration and login
   - Product browsing and searching
   - Shopping cart and checkout
   - Admin functionality

## Troubleshooting

### Common Issues

1. **Connection refused**
   - Make sure PostgreSQL service is running
   - Check your database.yml configuration

2. **Authentication failed**
   - Verify your PostgreSQL username and password
   - Check environment variables

3. **Relation does not exist**
   - This usually happens when tables are created in the wrong order
   - Check the SQL file and ensure tables with foreign keys are created after the referenced tables

4. **Missing pg gem**
   - Run `bundle install` to install the pg gem

### Getting Help

If you encounter any issues during migration, refer to:
- PostgreSQL documentation: https://www.postgresql.org/docs/
- Rails guides on database configuration: https://guides.rubyonrails.org/configuring.html#configuring-a-database