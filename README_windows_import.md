## How to run the docker image for import on Windows

Prerequisites: 
- Install Docker for Windows
- Install git
- Json file of the credential that has access to the project storage
- The firebase login token of an account that has access to the firebase project. 

```
docker run -it --rm -a STDOUT --name run-import -v "/C:\projects\farmsmart-backup"://usr/src/farmsmart -w="//usr/src/farmsmart" farmsmart/gcp-firebase:1.0.0 ./backup/firebase-export.sh farmsmart-backup-restore-service-account.json 1/f6s6P84QMjwep7oV5tSQA9t1RGzM5L31M9pFky8D1_4 firebase-maribel
```