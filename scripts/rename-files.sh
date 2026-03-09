#!/bin/bash
# Fayllarni nomlash uchun skript
# Barcha fayllardagi katta harflar va bo'shliqlarni almashtiradi

for file in "$@"; do
    new_name=$(echo "$file" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr '_' '-')
    if [ "$file" != "$new_name" ]; then
        mv "$file" "$new_name"
        echo "Renamed: $file -> $new_name"
    fi
done
