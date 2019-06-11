#!/bin/bash
set -euo pipefail

google_service_account=${1}
google_project_id=${2}
backup_bucket=${3}
firebase_asset_bucket=${4}
backup_date=${5}


# Authenticate service account.
echo "Authenticating with service account: '${google_service_account}'"
gcloud auth activate-service-account --key-file "${google_service_account}"
gcloud config set project "${google_project_id}"

# Import firebase user data.
firebase auth:import ./output.json

# Delete all existing collections.
echo "Deleting all collections from firestore"
firebase firestore:delete -y --all-collections

# Import firestore data into the firebase project.
echo "Restoring firestore data to ${google_project_id} from 'gs://${backup_bucket}/${backup_date}'"
gcloud beta firestore import "gs://${backup_bucket}/${backup_date}/firestore_data"

# Import the firebase cloud storage bucket data.
echo "Restoring bucket assets to ${google_project_id} from 'gs://${backup_bucket}/${backup_date}'"
gsutil rsync -rd "gs://${backup_bucket}/${backup_date}/assets" "gs://${firebase_asset_bucket}"
