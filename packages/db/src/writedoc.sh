#!/bin/bash

# Use ./migrations as the default directory if no argument is given
TARGET_DIR="${1:-./migrations}"
OUTPUT_FILE="./MIGRATIONS.md"

# Clear the output file
> "$OUTPUT_FILE"

# Find files, sort by filename (basename) numerically
find "$TARGET_DIR" -type f | sort -t '/' -k 3 | while read -r FILE; do
  echo "Processing $FILE"

  {
    echo -e "\n\n### File: $FILE\n"
    echo '```sql'
    cat "$FILE"
    echo '```'
    echo -e "\n---"
  } >> "$OUTPUT_FILE"
done

echo "✅ All file contents have been written to $OUTPUT_FILE"
