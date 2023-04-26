#!/bin/bash
. ./common.sh
echo ${repoList}
echo length
for (( i=1; i<=length; i++ )); do
  repoPath="CODEBUILD_SRC_DIR_source$i"
  cd ${!repoPath}
  repo=${repoList[$i-1]}
  declare "REPOSITORY_URI_source$i=$REPOSITORY_URI/$repo"
  echo $repo
  if [ $TAG == $repo ]
  then
    if [[ $repo == "hotel-search-service" || $repo == "hotel-book-service" || $repo == "hotel-book-reprice-pad" || $repo == "hotel-details-pad" || $repo == "hotel-availability-pad" ]]
    then
      mvn -s settings.xml clean install
    else
      mvn clean install -DskipTests
    fi
    repoUri="REPOSITORY_URI_source$i"
    docker build -t ${!repoUri}:latest .
    docker tag ${!repoUri}:latest ${!repoUri}:"$IMAGE_TAG"
  fi
done
if [ $TAG == "hotel-book" ]
then
  cd $CODEBUILD_SRC_DIR_source12
  mvn -s settings.xml clean install -DskipTests
  docker build -t "$REPOSITORY_URI_CMD":latest -t "$REPOSITORY_URI_QUERY":latest .
  docker tag "$REPOSITORY_URI_CMD":latest "$REPOSITORY_URI_CMD":"$IMAGE_TAG"
  docker tag "$REPOSITORY_URI_QUERY":latest "$REPOSITORY_URI_QUERY":"$IMAGE_TAG"
fi