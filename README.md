# farmsmart-backup

Cron scheduled backup for farmsmart, the backup is scheduled to run via CircleCI, the schedule can be modified in `./circleci/config.yml`.

---

## Export

`backup/firebase-export.sh ${credential_file} ${firebase_token} ${project}`

- `credential_file` : The path to the GCP service account.
- `firebase_token` : The firebase token which can be generated with `firebase login:ci`.
- `project` : The GCP project id to backup.
- `date` : The date of the backup present in the GCP backup bucket.

## Import

`backup/firebase-import.sh ${credential_file} ${firebase_token} ${project} ${date}`

- `credential_file` : The path to the GCP service account.
- `firebase_token` : The firebase token which can be generated with `firebase login:ci`.
- `project` : The GCP project id to backup.
- `date` : The date of the backup present in the GCP backup bucket.
