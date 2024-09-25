# File Downloader Script

Script to download files with a specified extension from a given URL.

## Usage

```sh
./download.sh <file_list_url> <file_extension> [output_dir]
```

## Arguments

  * file_list_url: The URL of the page containing the list of files to download.
  * file_extension: The file extension to look for (e.g., pdf, jpg). This argument is mandatory.
  * output_dir: (Optional) The directory to save the downloaded files. Defaults to <file_extension>_downloads.

## Example

```sh
./download.sh http://example.com/pdfs/ pdf
./download.sh http://example.com/files.html jpg custom_directory
```

## Description

The script will:

  * Download the HTML content of the provided URL.
  * Extract all URLs with the specified file extension from the HTML content.
  * Download each file and save it to the specified or default output directory.