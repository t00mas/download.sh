#!/bin/bash

# Script to download files with a specified extension from a given URL listing them with href attributes.
#
# Usage: ./download_pdfs.sh <file_list_url> <file_extension> [output_dir]
#
# Arguments:
#   file_list_url  - The URL of the page containing the list of files to download.
#   file_extension - The file extension to look for (e.g., pdf, jpg). This argument is mandatory.
#   output_dir     - (Optional) The directory to save the downloaded files. Defaults to <file_extension>_downloads.
#
# Example:
#   ./download.sh http://example.com/pdfs/ pdf
#   ./download.sh http://example.com/files.html jpg custom_directory
#
# The script will:
# 1. Download the HTML content of the provided URL.
# 2. Extract all URLs with the specified file extension from the HTML content.
# 3. Download each file and save it to the specified or default output directory.

# Check if at least two arguments are provided
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <file_list_url> <file_extension> [output_dir]"
  exit 1
fi

# URL of the file list passed as a command-line argument
file_list_url="$1"

# File extension to look for
file_extension="$2"

# Directory to save downloaded files, default to ${extension}_downloads if not provided
output_dir="${3:-${file_extension}_downloads}"
mkdir -p "$output_dir"

# Download the HTML content of the file list page
html_content=$(curl -s "$file_list_url")

# Extract all URLs with the specified extension from the HTML content using sed
file_urls=($(echo "$html_content" | sed -n "s/.*href=\"\([^\"]*\.${file_extension}\)\".*/\1/p"))

# Print extracted URLs for debugging
echo "Extracted ${file_extension} URLs:"
printf "%s\n" "${file_urls[@]}"

# If no URLs are found, exit with a message
if [[ ${#file_urls[@]} -eq 0 ]]; then
  echo "No ${file_extension} links found on the page. Please check if the page contains valid ${file_extension} links."
  exit 1
fi

# Extract the full base URL (including path up to the directory level) for relative links
base_url=$(echo "$file_list_url" | sed -E 's|(https?://.*/)[^/]*|\1|')

# Download each file
for file_url in "${file_urls[@]}"; do
    # Check if the URL is relative or absolute
    if [[ "$file_url" != http* ]]; then
        # Handle relative URLs, append them to the base URL (directory-level)
        file_url="${base_url}${file_url}"
    fi
    # Download the file
    curl -o "${output_dir}/$(basename "$file_url")" "$file_url"
done