import re

input_file = "storage/all_postgres.sql"
output_file = "storage/all_postgres_fixed.sql"

with open(input_file, "r", encoding="utf-8") as f:
    content = f.read()

# Fix provinces table inserts
def fix_provinces(match):
    parts = match.group(1).split(',')
    # Make sure numeric fields are not boolean
    if len(parts) >= 6:
        # Fix gst (index 3)
        if parts[3].strip().upper() == 'FALSE':
            parts[3] = '0'
        elif parts[3].strip().upper() == 'TRUE':
            parts[3] = '0.05'
            
        # Fix pst (index 4)
        if parts[4].strip().upper() == 'FALSE':
            parts[4] = '0'
        elif parts[4].strip().upper() == 'TRUE':
            parts[4] = '0.07'
            
        # Fix hst (index 5)
        if parts[5].strip().upper() == 'FALSE':
            parts[5] = '0'
        elif parts[5].strip().upper() == 'TRUE':
            parts[5] = '0.13'
    
    return "INSERT INTO provinces VALUES(" + ",".join(parts) + ")"

# Fix orders table inserts
def fix_orders(match):
    parts = match.group(1).split(',')
    # Make sure numeric fields are not boolean
    if len(parts) >= 7:
        # Fix customer_id (index 1)
        if parts[1].strip().upper() == 'TRUE':
            parts[1] = '1'
        elif parts[1].strip().upper() == 'FALSE':
            parts[1] = '0'
            
        # Fix gst (index 3)
        if parts[3].strip().upper() == 'FALSE':
            parts[3] = '0'
        elif parts[3].strip().upper() == 'TRUE':
            parts[3] = '0.05'
            
        # Fix pst (index 4)
        if parts[4].strip().upper() == 'FALSE':
            parts[4] = '0'
        elif parts[4].strip().upper() == 'TRUE':
            parts[4] = '0.07'
            
        # Fix hst (index 5)
        if parts[5].strip().upper() == 'FALSE':
            parts[5] = '0'
        elif parts[5].strip().upper() == 'TRUE':
            parts[5] = '0.13'
    
    return "INSERT INTO orders VALUES(" + ",".join(parts) + ")"

# Apply fixes
content = re.sub(r'(INSERT INTO provinces VALUES\([^)]+\))', fix_provinces, content)
content = re.sub(r'(INSERT INTO orders VALUES\([^)]+\))', fix_orders, content)

with open(output_file, "w", encoding="utf-8") as f:
    f.write(content)

print(f"Fixed SQL file created: {output_file}")