#!/bin/bash

# Start PostgreSQL service
sudo service postgresql start

# Generate the SQL file from SQLite
echo "Generating SQL from SQLite database..."
python3 /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/migrate_all_data.py

# Fix PostgreSQL-specific issues
echo "Fixing PostgreSQL-specific issues..."
python3 /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/fix_postgres_import.py

# Drop and recreate the database
echo "Recreating PostgreSQL database..."
sudo -u postgres psql -c "DROP DATABASE IF EXISTS otakuwarrior_store_development;"
sudo -u postgres psql -c "CREATE DATABASE otakuwarrior_store_development;"

# Import the fixed SQL file
echo "Importing data into PostgreSQL..."
sudo -u postgres psql -d otakuwarrior_store_development -f /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/storage/full_postgres_import_fixed.sql

echo "Migration complete!"