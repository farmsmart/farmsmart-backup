# farmsmart-backup

Cron scheduled backup for farmsmart, the backup is scheduled to run via CircleCI, the schedule can be modified in `./circleci/config.yml`.

[Use this link to check a cron schedule](https://crontab.guru/#0_1_*_*_*`)

The backup bucket is in the same project and should be named <google_project_id>_farmsmart_backup.

- The bucket has a retention policy of 7 days which prevents early deletion of backups.
- The bucket also has a lifecycle rule which deletes data older than 7 days to reduce storage costs.

---

## Export

`backup/firebase-export.sh ${credential_file} ${firebase_token} ${project}`

- `credential_file` : The path to the GCP service account.
- `firebase_token` : The firebase token which can be generated with `firebase login:ci`.
- `project` : The GCP project id to backup.
- `date` : The date of the backup present in the GCP backup bucket.

## Import

Currently the import is a manual process which requires firebase SDK and the google cloud SDK. There is a docker image which has these dependencies installed - farmsmart/gcp-firebase:1.0.0

`backup/firebase-import.sh ${credential_file} ${firebase_token} ${project} ${date}`

- `credential_file` : The path to the GCP service account.
- `firebase_token` : The firebase token which can be generated with `firebase login:ci`.
- `project` : The GCP project id to backup.
- `date` : The folder which contains the backup present in the GCP backup bucketwhich is in the form "%Y%m%d.%H%M%SZ" eg. `20190614.130149Z`

See [sample windows import using docker](README_windows_import.md)

