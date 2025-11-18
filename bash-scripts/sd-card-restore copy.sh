#!/bin/bash
# restore-lostdir.sh
# Automatically detect and rename LOST.DIR files with correct extensions

echo "=== LOST.DIR Recovery Script ==="
echo ""

# Ask for the LOST.DIR folder path
read -p "Enter the full path to your LOST.DIR folder: " LOSTDIR

# Check if folder exists
if [ ! -d "$LOSTDIR" ]; then
  echo "❌ Folder not found! Please check the path."
  exit 1
fi

cd "$LOSTDIR" || exit

echo "🔍 Detecting file types and renaming..."

# Loop through files in the folder
for file in *; do
  [ -f "$file" ] || continue
  
  # Get MIME type
  mimetype=$(file --mime-type -b "$file")

  # Determine extension
  case "$mimetype" in
    image/jpeg) ext="jpg" ;;
    image/png) ext="png" ;;
    image/gif) ext="gif" ;;
    video/mp4) ext="mp4" ;;
    video/quicktime) ext="mov" ;;
    video/x-msvideo) ext="avi" ;;
    audio/mpeg) ext="mp3" ;;
    audio/x-wav) ext="wav" ;;
    application/pdf) ext="pdf" ;;
    application/zip) ext="zip" ;;
    text/plain) ext="txt" ;;
    application/vnd.ms-excel) ext="xls" ;;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet) ext="xlsx" ;;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document) ext="docx" ;;
    application/msword) ext="doc" ;;
    *) ext="" ;;
  esac

  # Rename if extension found
  if [ -n "$ext" ]; then
    newname="${file}.${ext}"
    mv "$file" "$newname"
    echo "✅ $file → $newname"
  else
    echo "⚠️ Unknown type: $file ($mimetype)"
  fi
done

echo ""
echo "🎉 Done! Check your folder for renamed files."
