import sqlite3
import os
import re

# Configuration
sqlite_db_path = "storage/development.sqlite3"  # Path to your SQLite database
output_file = "storage/full_postgres_import.sql"  # Output SQL file for PostgreSQL

# Connect to SQLite database
conn = sqlite3.connect(sqlite_db_path)
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

# Get all tables
cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';")
tables = [row['name'] for row in cursor.fetchall()]

# Get column types for each table
column_types = {}
for table in tables:
    cursor.execute(f"PRAGMA table_info({table});")
    column_types[table] = [(row['name'], row['type']) for row in cursor.fetchall()]

# Skip Rails internal tables
skip_tables = {'schema_migrations', 'ar_internal_metadata'}

# Table insertion order (to respect FKs)
def table_sort_key(table):
    # Put customers before orders, categories before products, etc.
    if table == 'categories': return 0
    if table == 'provinces': return 1
    if table == 'customers': return 2
    if table == 'products': return 3
    if table == 'orders': return 4
    if table == 'order_items': return 5
    return 10
ordered_tables = sorted([t for t in tables if t not in skip_tables], key=table_sort_key)

# Function to convert value for PostgreSQL
def convert_value(value, coltype):
    if value is None:
        return "NULL"
    if coltype.lower() in ["boolean", "bool"]:
        if str(value) in ["1", "True", "true", "TRUE"]:
            return "TRUE"
        elif str(value) in ["0", "False", "false", "FALSE"]:
            return "FALSE"
        else:
            return "NULL"
    if coltype.lower().startswith("varchar") or coltype.lower() in ["text", "char"]:
        return "'" + str(value).replace("'", "''") + "'"
    if coltype.lower().startswith("numeric") or coltype.lower().startswith("decimal"):
        return str(value)
    if coltype.lower().startswith("timestamp") or coltype.lower().startswith("datetime") or coltype.lower() == "date":
        return f"'{value}'"
    return str(value)

# Write output
with open(output_file, "w", encoding="utf-8") as f:
    for table in ordered_tables:
        columns = [col for col, _ in column_types[table]]
        types = [typ for _, typ in column_types[table]]
        cursor.execute(f"SELECT * FROM {table};")
        rows = cursor.fetchall()
        for row in rows:
            vals = [convert_value(row[col], types[i]) for i, col in enumerate(columns)]
            f.write(f"INSERT INTO {table} ({', '.join(columns)}) VALUES ({', '.join(vals)});\n")

print(f"PostgreSQL import SQL file created: {output_file}")