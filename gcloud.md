### Install

https://cloud.google.com/sdk/docs/#deb
https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
additional comp:
https://cloud.google.com/sdk/docs/components#additional_components

gcloud projects describe ackube
gcloud projects list
gcloud projects list --filter=test
gcloud components list

https://cloud.google.com/resource-manager/docs/managing-notifications

List of resources:
https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/overview

api example:
https://www.googleapis.com/discovery/v1/apis/storage/v1/rest






### pub/sub

https://cloud.google.com/pubsub/docs/quickstart-cli

gcloud init
gcloud pubsub topics create my-topic
gcloud pubsub subscriptions create --topic my-topic my-sub
gcloud pubsub topics publish my-topic --message "hello"
gcloud pubsub subscriptions pull --auto-ack my-sub







### Storage to pub/sub

https://cloud.google.com/storage/docs/pubsub-notifications
https://cloud.google.com/storage/docs/key-terms




## Cloud Function

https://cloud.google.com/functions/docs/quickstart#functions_quickstart_url-go

gcloud functions deploy HelloGet --runtime go111 --trigger-http

gcloud functions describe HelloGet
gcloud functions logs read jenny-firestore-1
gcloud functions event-types list



```
availableMemoryMb: 256
entryPoint: HelloFirestore
eventTrigger:
  eventType: providers/cloud.firestore/eventTypes/document.update
  failurePolicy: {}
  resource: projects/ackube/databases/(default)/documents/users/a
  service: firestore.googleapis.com
labels:
  deployment-tool: console-cloud
name: projects/ackube/locations/us-central1/functions/jenny-firestore-1
runtime: go111
serviceAccountEmail: ackube@appspot.gserviceaccount.com
sourceUploadUrl: https://storage.googleapis.com/gcf-upload-us-central1-20d1d976-07b0-46fb-bb62-e881a885912b/e6ae4e5b-c707-47a8-889d-786b55f5c4f5.zip?GoogleAccessId=service-3998566470@gcf-admin-robot.iam.gserviceaccount.com&Expires=1549364194&Signature=DGDKWKuiAwUdTMDpAqo4FKgWGUevjvosNRqqx06t4Hr3MYxkEEvI2NFEi%2FAvGVnQ1SFPjlxYymIfU1x9P8Kfb1hgtEgQmXceumA46%2BHFzntbpuWAsH5QM8zAdPRZHgSH3gM7LIGynIEPjdML6kl6%2BdDb2%2BXGqVA2NcB9U%2B5Ewl6GrW4F7N3AjqEiLM2ndF4H52gMNvB9czATjKqbqUiNMdkJMY6%2FfK%2Bdb3oXdszukXXqYZ74kGreRS%2Fj7A%2FTs2LCJIJUASAKs96k%2FTASjnIq4hPxfUtHKI0ExQlz4gBjaz%2BcvFO0EQBlQ5whoA6hKdj4YBw4bfLYHj41Tl4E%2BOKZ3Q%3D%3D
status: ACTIVE
timeout: 60s
updateTime: '2019-02-05T10:27:12Z'
versionId: '1'
```




- need pub/sub emulator?
