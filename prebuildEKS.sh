#!/bin/bash
. ./common.sh
for (( i=1; i<=length; i++ )); do
  repo=${repoList[$i-1]}
  echo $repo
  export REPO_URI = $REPOSITORY_URI/$repo
  if [ $TAG == $repo]
  then
    docker pull $REPO_URI:$IMAGE_TAG
  fi
done
