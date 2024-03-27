#!/bin/bash

# Get command line arguments
directory=$1
s3_bucket_path=$2
aws_profile=$3

verify_directory_exists() {
  if [[ ! -d "$directory" ]]; then
    echo "Directory '$directory' does not exist."
    exit 1
  fi
}

change_directory() {
  cd "$directory" || exit 1
}

make_file_executable() {
  local file="$1"
  chmod +x "$file"
  echo "File '$file' has been made executable."
}

execute_file() {
  local file="$1"
  "./$file"
  if [[ $? -eq 0 ]]; then
    echo "File '$file' executed successfully."
  else
    echo "File '$file' failed to execute."
    exit 1
  fi
}

iterate_and_execute_scripts() {
  scripts_found=false
  for file in *.sh; do
    scripts_found=true
    if [[ -f "$file" ]]; then
      if [[ ! -x "$file" ]]; then
        make_file_executable "$file"
      else
        echo "File '$file' is already executable."
      fi
      execute_file "$file"
    fi
  done

  if [ "$scripts_found" = false ]; then
    echo "No script files found in '$directory'."
  fi
}

is_aws_logged_in() {
  # Try to get SSO credentials
  aws sts get-caller-identity --profile "$aws_profile" &>/dev/null
  return $?
}

login_to_aws_via_sso() {
  if is_aws_logged_in; then
    echo "You are already logged into AWS."
  else
    echo "Logging into AWS using SSO..."
    aws sso login --profile "$aws_profile"
  fi
}

upload_file_to_s3() {
  local local_path="$1"

  aws s3 cp "$local_path" "$s3_bucket_path" --profile "$aws_profile"
  return $?
}

delete_local_file() {
  local local_path="$1"

  rm "$local_path"

  if [[ ! -f "$local_path" ]]; then
    echo "File '$local_path' deleted successfully."
  else
    echo "Failed to delete file '$local_path'."
  fi
}

iterate_and_upload_files() {
  parquet_files_found=false
  for local_path in "$directory"/*.parquet; do
    if [[ -f "$local_path" ]]; then
      parquet_files_found=true
      if upload_file_to_s3 "$local_path"; then
        echo "File '$local_path' uploaded successfully to '$s3_bucket_path'."
        delete_local_file "$local_path"
      else
        echo "File '$local_path' failed to upload."
      fi
    fi
  done

  if [ "$parquet_files_found" = false ]; then
    echo "No .parquet files found in '$directory'."
  fi
}

check_for_csv_files() {
	csv_files_found=false
  for local_path in "$directory"/*.csv; do
    if [[ -f "$local_path" ]]; then
      csv_files_found=true
      # Convert CSV to Parquet here (assuming you have a script or function ready)
      convert_csv_to_parquet "$local_path"
    fi
  done

  if [ "$csv_files_found" = true ]; then
    echo "CSV files converted to Parquet format."
  else
    echo "No CSV files found for conversion."
  fi
}

check_for_parquet_files() {
	parquet_files_found=false
  for local_path in "$directory"/*.parquet; do
    if [[ -f "$local_path" ]]; then
      parquet_files_found=true
      break # Found at least one Parquet file, no need to check further
    fi
  done

  # If there are Parquet files, upload them
  if [ "$parquet_files_found" = true ]; then
    iterate_and_upload_files
  else
    echo "No Parquet files found for upload."
  fi
}

convert_csv_to_parquet() {
  local csv_file=$1
  echo "Converting $csv_file to Parquet format..."
  python3 ./convert_csv_to_parquet.py "$csv_file"
}

main() {
	# Verify directory
  verify_directory_exists

	# Run change directory
  change_directory

  # Running downloaded shell scripts in the specified directory
  iterate_and_execute_scripts

  # Login to AWS using SSO if not already logged in
  login_to_aws_via_sso

  # Check for CSV file & convert to parquet format
  check_for_csv_files

  # Now check for Parquet files & iupload to AWS
  check_for_parquet_files
}



main
