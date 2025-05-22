#!/bin/bash

echo "==================================================="
echo "PostgreSQL Setup Script for Otaku Warrior Store"
echo "==================================================="
echo

echo "This script will help you set up PostgreSQL for your Rails application."
echo "Please make sure PostgreSQL is installed on your system."
echo

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "PostgreSQL is not installed. Please install it first:"
    echo "sudo apt update && sudo apt install postgresql postgresql-contrib"
    exit 1
fi

# Check if PostgreSQL service is running
if ! pg_isready &> /dev/null; then
    echo "PostgreSQL service is not running. Starting it now..."
    sudo service postgresql start
    sleep 2
fi

# Get PostgreSQL credentials
read -p "Enter PostgreSQL username (default: postgres): " PGUSER
PGUSER=${PGUSER:-postgres}

read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
if [ -z "$PGPASSWORD" ]; then
    echo "Password cannot be empty"
    exit 1
fi

# Export environment variables
export POSTGRES_USER="$PGUSER"
export POSTGRES_PASSWORD="$PGPASSWORD"
export POSTGRES_HOST="localhost"

# Add to .bashrc for persistence
echo "
# PostgreSQL environment variables for Otaku Warrior Store
export POSTGRES_USER=\"$PGUSER\"
export POSTGRES_PASSWORD=\"$PGPASSWORD\"
export POSTGRES_HOST=\"localhost\"
" >> ~/.bashrc

echo
echo "Setting up PostgreSQL databases..."

# Create databases
sudo -u postgres psql -c "CREATE USER $PGUSER WITH PASSWORD '$PGPASSWORD' SUPERUSER;" || true
sudo -u postgres psql -c "CREATE DATABASE otakuwarrior_store_development;" || true
sudo -u postgres psql -c "CREATE DATABASE otakuwarrior_store_test;" || true
sudo -u postgres psql -c "CREATE DATABASE otakuwarrior_store_production;" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE otakuwarrior_store_development TO $PGUSER;" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE otakuwarrior_store_test TO $PGUSER;" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE otakuwarrior_store_production TO $PGUSER;" || true

echo
echo "Importing data into development database..."
psql -U $PGUSER -d otakuwarrior_store_development -f /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/storage/all_postgres.sql

echo
echo "Installing required gems..."
bundle install

echo
echo "Setting up Rails environment..."
rails db:environment:set RAILS_ENV=development

echo
echo "==================================================="
echo "Setup complete!"
echo
echo "Next steps:"
echo "1. Start your Rails server: rails server"
echo "2. Access your application at http://localhost:3000"
echo "==================================================="