#!/bin/bash
# Mundarija yaratish skripti
# README.md fayllaridan mundarija yaratadi

echo "# Java Learning - Mundarija"
echo ""

for dir in */; do
    if [ -f "${dir}README.md" ]; then
        echo "## ${dir%/}"
        grep "^[0-9]\." "${dir}README.md" | while IFS= read -r line; do
            echo "- $line"
        done
        echo ""
    fi
done
