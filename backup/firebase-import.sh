#!/bin/bash
set -euo pipefail

google_service_account=${1}
firebase_token=${2}
google_project_id=${3}
backup_date=${4}

backup_bucket=${google_project_id}_farmsmart_backup
firebase_asset_bucket=${google_project_id}.appspot.com

firestore_data="gs://${backup_bucket}/${backup_date}/firestore_data"
firebase_assets="gs://${backup_bucket}/${backup_date}/assets"
firebase_user_data="gs://${backup_bucket}/${backup_date}/user_data/users_${backup_date}.json"

# Safety Checks
# Authenticate service account.
echo "Authenticating with service account: '${google_service_account}'"
gcloud auth activate-service-account --key-file "${google_service_account}"
gcloud config set project "${google_project_id}"

if (gsutil ls "gs://${backup_bucket}/${backup_date}" &>/dev/null)
  then
    echo "Found backup directory for ${backup_date}"
  else
    echo "Backup date ${backup_date} does not exist in bucket gs://${backup_bucket}, aborting restore."
    exit 1
fi

if (gsutil ls "${firestore_data}" &>/dev/null)
  then
    echo "Firestore data exists in backup."
  else
    echo "Cannot find firestore data in backup bucket (${firestore_data}), aborting restore."
    exit 1
fi

if (gsutil ls "${firebase_assets}" &>/dev/null)
  then
    echo "Firebase media exists in backup."
  else
    echo "Cannot find firebase media in backup bucket (${firebase_assets}), aborting restore."
    exit 1
fi

if (gsutil ls "${firebase_user_data}" &>/dev/null)
  then
    echo "Firebase media exgit ists in backup."
  else
    echo "Cannot find user data in backup bucket (${firebase_user_data}), aborting restore."
    exit 1
fi


# # Import firebase user data.
mkdir -p output
gsutil cp -rZ "${firebase_user_data}" "./output/users.json"
firebase auth:import --token "${firebase_token}" --project "${google_project_id}" "./output/users.json"

# Delete all existing collections.
echo "Deleting all collections from firestore"
firebase firestore:delete --token "${firebase_token}" --project "${google_project_id}" -y --all-collections

# Import firestore data into the firebase project.
echo "Restoring firestore data to ${google_project_id} from 'gs://${backup_bucket}/${backup_date}'"
gcloud beta firestore import "${firestore_data}" --project "${google_project_id}"

# Import the firebase cloud storage bucket data.
echo "Restoring bucket assets to ${google_project_id} from 'gs://${backup_bucket}/${backup_date}'"
gsutil rsync -rd "${firebase_assets}" "gs://${firebase_asset_bucket}"
