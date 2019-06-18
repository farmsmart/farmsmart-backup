## How to run the docker image for import on Windows

Prerequisites: 
- Install Docker
- Install git
- Have the Json file of the credential that has access to the project buckets. role: *Storage Admin* and *Cloud Datastore Import Export Admin*
- The firebase login token of an account that has access to the firebase project. 

Steps:
1. Clone the farmsmart-backup repository
2. Change into the repository in local
3. Copy the json credentials of the service acount into the repo e.g. farmsmart-backup-restore-service-account.json
3. Use docker run. The local repo is mounted and so the credential is now available in the docker image.

Sample: Windows execution using Git Bash. Local repo is mounted to /usr/src/farmsmart double forward slash to ensure correct paths are used.
```
$ docker run -it --rm --name run-import -v "/C:\projects\farmsmart-backup"://usr/src/farmsmart -w="//usr/src/farmsmart" farmsmart/gcp-firebase:1.0.0 ./backup/firebase-import.sh farmsmart-backup-restore-service-account.json ${login_token} ${firebase_project} ${YYYYMMDD.HHMMSSZ}
```