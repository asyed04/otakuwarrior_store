@echo off
echo ===================================================
echo PostgreSQL Setup Script for Otaku Warrior Store
echo ===================================================
echo.

echo This script will help you set up PostgreSQL for your Rails application.
echo Please make sure PostgreSQL is installed on your system.
echo.

set /p PGUSER=Enter PostgreSQL username (default: postgres): 
if "%PGUSER%"=="" set PGUSER=postgres

set /p PGPASSWORD=Enter PostgreSQL password: 
if "%PGPASSWORD%"=="" (
    echo Password cannot be empty
    exit /b 1
)

echo.
echo Setting environment variables...
setx POSTGRES_USER "%PGUSER%"
setx POSTGRES_PASSWORD "%PGPASSWORD%"
setx POSTGRES_HOST "localhost"

echo.
echo Creating databases...
echo Note: If you see any errors, make sure PostgreSQL is running and your credentials are correct.

psql -U %PGUSER% -c "CREATE DATABASE otakuwarrior_store_development;" postgres
psql -U %PGUSER% -c "CREATE DATABASE otakuwarrior_store_test;" postgres
psql -U %PGUSER% -c "CREATE DATABASE otakuwarrior_store_production;" postgres

echo.
echo Importing data into development database...
psql -U %PGUSER% -d otakuwarrior_store_development -f storage\all_postgres.sql

echo.
echo Installing required gems...
call bundle install

echo.
echo Setting up Rails environment...
call rails db:environment:set RAILS_ENV=development

echo.
echo ===================================================
echo Setup complete!
echo.
echo Next steps:
echo 1. Start your Rails server: rails server
echo 2. Access your application at http://localhost:3000
echo ===================================================

pause