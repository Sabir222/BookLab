#!/bin/bash

OUTPUT_FILE="./docker-setup.txt"

# Truncate the output file (clear previous content)
> "$OUTPUT_FILE"

# Files to copy from
FILES=(
  "./docker-compose.dev.yml"
  "./apps/web/Dockerfile"
  "./apps/server/Dockerfile"
  "./apps/docs/Dockerfile"
)

for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    echo "======= Start of $FILE =======" >> "$OUTPUT_FILE"
    cat "$FILE" >> "$OUTPUT_FILE"
    echo -e "\n======= End of $FILE =======\n" >> "$OUTPUT_FILE"
    echo "✅ Copied contents of $FILE into $OUTPUT_FILE"
  else
    echo "❌ File not found: $FILE" >> "$OUTPUT_FILE"
    echo "❌ File not found: $FILE"
  fi
done

echo "📄 All code written to $OUTPUT_FILE"
