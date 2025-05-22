import re
import csv
import io

input_file = "storage/full_postgres_import.sql"
output_file = "storage/full_postgres_import_fixed.sql"

# Only convert boolean columns for specific tables
# For products: only 'on_sale' (must match column list to values)
def fix_products_booleans(match):
    line = match.group(0)
    m = re.match(r'(INSERT INTO products\s*\(([^)]+)\)\s*VALUES\s*)(.+);', line, re.DOTALL)
    if not m:
        return line
    insert_prefix = m.group(1)
    columns = [col.strip().strip('"') for col in m.group(2).split(',')]
    values_part = m.group(3)
    if 'on_sale' not in columns:
        return line
    # Robustly split value tuples (handles multi-line, commas in strings, etc.)
    tuples = []
    buf = ''
    paren_count = 0
    in_quotes = False
    last_char = ''
    for c in values_part:
        buf += c
        if c in "'\"":
            if not in_quotes:
                in_quotes = c
            elif in_quotes == c and last_char != '\\':
                in_quotes = False
        elif not in_quotes:
            if c == '(': paren_count += 1
            if c == ')': paren_count -= 1
            if paren_count == 0 and buf.strip():
                tuples.append(buf.strip())
                buf = ''
        last_char = c
    def fix_tuple_str(t):
        t = t.strip()
        if not t.startswith('(') or not t.endswith(')'):
            return t
        vals = next(csv.reader([t[1:-1]], skipinitialspace=True))
        # Map columns to values
        col_val = dict(zip(columns, vals))
        if 'on_sale' in col_val:
            v = col_val['on_sale'].strip().strip("'").strip('"')
            if v.upper() == "NULL":
                col_val['on_sale'] = "NULL"
            elif v == "1":
                col_val['on_sale'] = "TRUE"
            elif v == "0":
                col_val['on_sale'] = "FALSE"
            else:
                col_val['on_sale'] = "FALSE"
        # Reconstruct tuple in original order
        new_vals = [col_val.get(col, '') for col in columns]
        return '(' + ','.join(new_vals) + ')'
    fixed_tuples = [fix_tuple_str(t) for t in tuples if t.strip()]
    return insert_prefix + '\n'.join(fixed_tuples) + ';'

# Read the input file
with open(input_file, "r", encoding="utf-8") as f:
    content = f.read()

# Fix only products booleans (robust to column order and multi-line)
content = re.sub(r'INSERT INTO products[^;]+;', fix_products_booleans, content, flags=re.DOTALL)

# Fix numeric values in provinces table
def fix_provinces_numeric(match):
    line = match.group(0)
    # Replace FALSE with 0 for numeric fields
    if "provinces" in line:
        # Check if there's a boolean in a numeric field position
        parts = line.split(",")
        if len(parts) >= 7:  # Assuming provinces has at least 7 fields
            # GST field (index 3)
            if "FALSE" in parts[3]:
                parts[3] = parts[3].replace("FALSE", "0")
            # PST field (index 4)
            if "FALSE" in parts[4]:
                parts[4] = parts[4].replace("FALSE", "0")
            # HST field (index 5)
            if "FALSE" in parts[5]:
                parts[5] = parts[5].replace("FALSE", "0")
            
            return ",".join(parts)
    return line

# Apply province-specific fixes
content = re.sub(r'INSERT INTO provinces[^;]+;', fix_provinces_numeric, content)

# Fix orders table numeric fields
def fix_orders_numeric(match):
    line = match.group(0)
    # Replace FALSE with 0 for numeric fields
    if "orders" in line:
        # Check if there's a boolean in a numeric field position
        parts = line.split(",")
        if len(parts) >= 7:  # Assuming orders has at least 7 fields
            # GST field (index 3)
            if "FALSE" in parts[3]:
                parts[3] = parts[3].replace("FALSE", "0")
            # PST field (index 4)
            if "FALSE" in parts[4]:
                parts[4] = parts[4].replace("FALSE", "0")
            # HST field (index 5)
            if "FALSE" in parts[5]:
                parts[5] = parts[5].replace("FALSE", "0")
            
            return ",".join(parts)
    return line

# Apply orders-specific fixes
content = re.sub(r'INSERT INTO orders[^;]+;', fix_orders_numeric, content)

# Write the fixed content to the output file
with open(output_file, "w", encoding="utf-8") as f:
    f.write(content)

print(f"Fixed SQL file created: {output_file}")