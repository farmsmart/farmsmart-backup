#!/bin/bash
set -euo pipefail

google_service_account=${1}
google_project_id=${2}
temp_backup_bucket=${3}
backup_bucket=${4}
firebase_asset_bucket=${5}
backup_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Authenticate service account.
echo "Authenticating with service account '${google_service_account}'"
gcloud auth activate-service-account --key-file "${google_service_account}"
gcloud config set project "${google_project_id}"

# Export firebase user data.
firebase auth:export --format=json "./users_${backup_date}.json"

# Export firestore data to temporary bucket in same project.
echo "Backing up $google_project_id firestore data from 'gs://${temp_backup_bucket}/firestore_data/${backup_date}'"
gcloud beta firestore export "gs://${temp_backup_bucket}/${backup_date}/firestore_data"

# Copy firebase assets to backup bucket in seperate project.
echo "Backing up $google_project_id firebase assets from 'gs://${firebase_asset_bucket}/'' to 'gs://${backup_bucket}/${backup_date}/assets'"
gsutil cp -rZ -L "firebase_assets_backup_${backup_date}.log" "gs://${firebase_asset_bucket}/" "gs://${backup_bucket}/${backup_date}/assets"

# Copy from temp bucket to backup bucket.
echo "Copying assets to backup bucket 'gs://${backup_bucket}/${backup_date}/firestore_data'"
gsutil cp -rZ -L "firestore_data_backup_${backup_date}.log" "gs://${temp_backup_bucket}/${backup_date}/firestore_data" "gs://${backup_bucket}/${backup_date}/firestore_data"
