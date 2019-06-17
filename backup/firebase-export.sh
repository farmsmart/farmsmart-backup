#!/bin/bash
set -euo pipefail

google_service_account=${1}
firebase_token=${2}
google_project_id=${3}

backup_bucket="${google_project_id}_farmsmart_backup"
firebase_asset_bucket="${google_project_id}.appspot.com"
backup_date=$(date -u +"%Y%m%d.%H%M%SZ")


# Authenticate service account.
echo "Authenticating with service account '${google_service_account}'"
gcloud auth activate-service-account --key-file "${google_service_account}"
gcloud config set project "${google_project_id}"


mkdir -p output

# Export firebase user data.
firebase auth:export --token "${firebase_token}" --project "${google_project_id}" --format=json "./output/users_${backup_date}.json"
gsutil cp -rZ "./output/users_${backup_date}.json" "gs://${backup_bucket}/${backup_date}/user_data/"

# Export firestore data to backup bucket.
echo "Backing up $google_project_id firestore data from 'gs://${backup_bucket}/firestore_data/${backup_date}'"
gcloud beta firestore export "gs://${backup_bucket}/${backup_date}/firestore_data"

# Copy firebase assets to backup bucket in seperate project.
echo "Backing up $google_project_id firebase assets from 'gs://${firebase_asset_bucket}/'' to 'gs://${backup_bucket}/${backup_date}/assets'"
gsutil cp -rZ -L "./output/firebase_assets_backup_${backup_date}.log" "gs://${google_project_id}.appspot.com" "gs://${backup_bucket}/${backup_date}/assets"

# Copy log files
echo "Uploading log file to ${backup_bucket}"
gsutil cp -rZ "./output/firebase_assets_backup_${backup_date}.log" "gs://${backup_bucket}/${backup_date}/logs/"
