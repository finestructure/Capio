#!/bin/sh

dburl="http://localhost:5984/dev/"

for fname in *.json ; do
  echo Uploading $fname
  curl -X POST $dburl -H "Content-Type: application/json" -d @$fname
done
