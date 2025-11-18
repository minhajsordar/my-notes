#!/bin/bash
# restore-lostdir.sh
# Automatically detect and rename LOST.DIR files with correct extensions
# Unknown types will be renamed with "-unt.jpg"

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

# Create a subfolder for recovered files
RECOVERED="$LOSTDIR/Recovered"
mkdir -p "$RECOVERED"

echo "🔍 Detecting file types and renaming..."

# Loop through all files
for file in *; do
  [ -f "$file" ] || continue

  mimetype=$(file --mime-type -b "$file")

  # Determine file extension
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
    *) ext="jpg" ;; # Default extension
  esac

  # Rename and move file
  if [[ "$mimetype" == *"application/octet-stream"* || "$mimetype" == "inode/x-empty" || "$mimetype" == "text/x-asm" ]]; then
    newname="${file}-unt.jpg"
    mv "$file" "$RECOVERED/$newname"
    echo "⚠️  Unknown type → renamed to $newname"
  else
    newname="${file}.${ext}"
    mv "$file" "$RECOVERED/$newname"
    echo "✅ $file → $newname"
  fi
done

echo ""
echo "🎉 Done! Recovered files are in: $RECOVERED"
