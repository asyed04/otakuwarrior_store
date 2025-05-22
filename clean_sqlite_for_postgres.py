import re

input_file = "storage/all_clean.sql"
output_file = "storage/all_postgres.sql"

with open(input_file, "r", encoding="utf-8") as f:
    lines = f.readlines()

create_tables = []
insert_statements = []
create_indexes = []
other_lines = []

current_block = []
in_create_table = False
in_create_index = False
in_insert = False

# Track the column order for products
products_columns = None

for line in lines:
    # Remove SQLite-specific lines and keywords
    if any([
        "PRAGMA" in line,
        "BEGIN TRANSACTION" in line,
        "COMMIT;" in line,
        "sqlite_sequence" in line,
    ]):
        continue
    line = line.replace("AUTOINCREMENT", "")
    line = line.replace("IF NOT EXISTS", "")
    line = re.sub(r"datetime\(\d+\)", "timestamp", line)
    line = line.replace("decimal", "numeric")
    line = line.replace("boolean DEFAULT NULL", "boolean")
    line = re.sub(r"integer PRIMARY KEY", "SERIAL PRIMARY KEY", line)
    # Replace char(10) with E'\n' everywhere (case-insensitive, allow whitespace)
    line = re.sub(r'char\s*\(\s*10\s*\)', r"E'\\n'", line, flags=re.IGNORECASE)
    
    # Convert boolean values in INSERT statements
    if line.strip().upper().startswith("INSERT INTO"):
        # Convert 0/1 to FALSE/TRUE for boolean fields
        line = re.sub(r',0,', r',FALSE,', line)
        line = re.sub(r',1,', r',TRUE,', line)
        line = re.sub(r',0\)', r',FALSE)', line)
        line = re.sub(r',1\)', r',TRUE)', line)
        
        # Special handling for products table
        if "INSERT INTO products" in line:
            # Fix boolean values in specific positions
            parts = line.split("VALUES")
            if len(parts) == 2:
                values_part = parts[1]
                # Extract values inside parentheses
                match = re.search(r'\(([^)]+)\)', values_part)
                if match:
                    values = match.group(1).split(',')
                    # Position 8 is on_sale (0-based index)
                    if len(values) > 8:
                        values[8] = "TRUE" if values[8].strip() in ["1", "TRUE"] else "FALSE"
                    # Reconstruct the line
                    line = parts[0] + "VALUES(" + ",".join(values) + ")"

    # Group CREATE TABLE blocks
    if in_create_table:
        current_block.append(line)
        if line.strip().endswith(";"):
            create_tables.append("".join(current_block))
            in_create_table = False
        continue
    if line.strip().upper().startswith("CREATE TABLE"):
        in_create_table = True
        current_block = [line]
        continue

    # Group CREATE INDEX blocks
    if in_create_index:
        current_block.append(line)
        if line.strip().endswith(";"):
            create_indexes.append("".join(current_block))
            in_create_index = False
        continue
    if line.strip().upper().startswith("CREATE INDEX") or line.strip().upper().startswith("CREATE UNIQUE INDEX"):
        in_create_index = True
        current_block = [line]
        continue

    # Detect products column order from CREATE TABLE or INSERT INTO with columns
    if line.strip().upper().startswith("CREATE TABLE") and '"products"' in line:
        # Parse columns from CREATE TABLE
        m = re.search(r'\("(.+?)"\)', line)
        if m:
            products_columns = [col.strip().strip('"') for col in m.group(1).split(',')]
    if line.strip().lower().startswith("insert into products"):
        m = re.match(r'insert into products \(([^)]+)\)', line.strip().lower())
        if m:
            products_columns = [col.strip().strip('"') for col in m.group(1).split(',')]

    # Group multi-line and single-line INSERT statements
    if in_insert:
        current_block.append(line)
        if line.strip().endswith(";"):
            insert_sql = "".join(current_block)
            if insert_sql.strip().lower().startswith("insert into products"):
                # Use products_columns to find on_sale index
                def bool_fix(match):
                    vals = match.group(1).split(",")
                    if products_columns and 'on_sale' in products_columns:
                        idx = products_columns.index('on_sale')
                        vals[idx] = "FALSE" if vals[idx].strip() == "0" else ("TRUE" if vals[idx].strip() == "1" else vals[idx])
                    elif len(vals) > 8:
                        vals[8] = "FALSE" if vals[8].strip() == "0" else ("TRUE" if vals[8].strip() == "1" else vals[8])
                    return "(" + ",".join(vals) + ")"
                insert_sql = re.sub(r"\(([^)]+)\)", bool_fix, insert_sql)
            insert_statements.append(insert_sql)
            in_insert = False
        continue
    if line.strip().upper().startswith("INSERT INTO"):
        in_insert = True
        current_block = [line]
        # If this is a single-line INSERT (ends with ;), process immediately
        if line.strip().endswith(";"):
            insert_sql = "".join(current_block)
            if insert_sql.strip().lower().startswith("insert into products"):
                def bool_fix(match):
                    vals = match.group(1).split(",")
                    if products_columns and 'on_sale' in products_columns:
                        idx = products_columns.index('on_sale')
                        vals[idx] = "FALSE" if vals[idx].strip() == "0" else ("TRUE" if vals[idx].strip() == "1" else vals[idx])
                    elif len(vals) > 8:
                        vals[8] = "FALSE" if vals[8].strip() == "0" else ("TRUE" if vals[8].strip() == "1" else vals[8])
                    return "(" + ",".join(vals) + ")"
                insert_sql = re.sub(r"\(([^)]+)\)", bool_fix, insert_sql)
            insert_statements.append(insert_sql)
            in_insert = False
        continue

    # Everything else (not in CREATE TABLE, CREATE INDEX, or INSERT)
    if not in_create_table and not in_create_index and not in_insert and line.strip():
        other_lines.append(line)

# If there is a partially collected INSERT at the end, add it
if in_insert and current_block:
    insert_sql = "".join(current_block)
    if insert_sql.strip().lower().startswith("insert into products"):
        def bool_fix(match):
            vals = match.group(1).split(",")
            if products_columns and 'on_sale' in products_columns:
                idx = products_columns.index('on_sale')
                vals[idx] = "FALSE" if vals[idx].strip() == "0" else ("TRUE" if vals[idx].strip() == "1" else vals[idx])
            elif len(vals) > 8:
                vals[8] = "FALSE" if vals[8].strip() == "0" else ("TRUE" if vals[8].strip() == "1" else vals[8])
            return "(" + ",".join(vals) + ")"
        insert_sql = re.sub(r"\(([^)]+)\)", bool_fix, insert_sql)
    insert_statements.append(insert_sql)

# Define table dependencies and insertion order
table_dependencies = {
    "customers": ["provinces"],
    "orders": ["customers"],
    "order_items": ["orders", "products"],
    "active_storage_attachments": ["active_storage_blobs"],
    "active_storage_variant_records": ["active_storage_blobs"],
    "products": ["categories"]
}

# Define insertion order to respect foreign key constraints
insertion_order = [
    "active_admin_comments",
    "active_storage_blobs",
    "admin_users",
    "categories",
    "schema_migrations",
    "ar_internal_metadata",
    "provinces",
    "customers",
    "pages",
    "products",
    "active_storage_attachments",
    "active_storage_variant_records",
    "orders",
    "order_items"
]

# Sort tables based on dependencies
def sort_tables_by_dependencies(tables):
    # Extract table names from CREATE TABLE statements
    table_dict = {}
    for block in tables:
        match = re.search(r'CREATE TABLE\s+"([^"]+)"', block)
        if match:
            table_name = match.group(1)
            table_dict[table_name] = block
    
    # Topological sort
    sorted_tables = []
    visited = set()
    temp_visited = set()
    
    def visit(table):
        if table in temp_visited:
            # Circular dependency detected
            return
        if table in visited:
            return
        
        temp_visited.add(table)
        
        # Visit dependencies first
        if table in table_dependencies:
            for dep in table_dependencies[table]:
                if dep in table_dict:
                    visit(dep)
        
        temp_visited.remove(table)
        visited.add(table)
        if table in table_dict:
            sorted_tables.append(table_dict[table])
    
    # Visit all tables
    for table in table_dict:
        if table not in visited:
            visit(table)
    
    # Add any remaining tables that weren't in the dependency graph
    for table, block in table_dict.items():
        if table not in visited:
            sorted_tables.append(block)
    
    return sorted_tables

# Sort tables by dependencies
sorted_create_tables = sort_tables_by_dependencies(create_tables)

# Group insert statements by table
insert_by_table = {}
for stmt in insert_statements:
    table_match = re.match(r'INSERT INTO (\w+)', stmt)
    if table_match:
        table_name = table_match.group(1)
        if table_name not in insert_by_table:
            insert_by_table[table_name] = []
        insert_by_table[table_name].append(stmt)

# Write output in correct order
with open(output_file, "w", encoding="utf-8") as f:
    # Write all CREATE TABLE statements first
    for block in sorted_create_tables:
        f.write(block)
        if not block.endswith("\n"):
            f.write("\n")
    f.write("\n")
    
    # Write INSERT statements in the correct order
    for table in insertion_order:
        if table in insert_by_table:
            for stmt in insert_by_table[table]:
                f.write(stmt)
                if not stmt.endswith("\n"):
                    f.write("\n")
    
    # Write any remaining INSERT statements
    for table, stmts in insert_by_table.items():
        if table not in insertion_order:
            for stmt in stmts:
                f.write(stmt)
                if not stmt.endswith("\n"):
                    f.write("\n")
    
    f.write("\n")
    
    # Write CREATE INDEX statements
    for block in create_indexes:
        f.write(block)
        if not block.endswith("\n"):
            f.write("\n")
    
    f.write("\n")
    
    # Write any other lines
    for line in other_lines:
        f.write(line)
        if not line.endswith("\n"):
            f.write("\n")

print("SQL file cleaned and reordered for PostgreSQL import: storage/all_postgres.sql")