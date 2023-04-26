#!/bin/bash
. ./common.sh
echo ${repoList}
echo length
for (( i=1; i<=length; i++ )); do
    repoPath="CODEBUILD_SRC_DIR_source$i"
    repo=${repoList[$i-1]}
    declare "REPOSITORY_URI_source$i=$REPOSITORY_URI/$repo"
    repoUri="REPOSITORY_URI_source$i"
    if [ $TAG == $repo ]
    then
      docker push ${!repoUri}:"$IMAGE_TAG"
      echo Setting up github connection..
      git init
      if [$repo == "oauth-server"]
      then
        git remote add testorigin https://${SECRET_USERNAME}:${SECRET_TOKEN}@github.com/IBS-Skillset/authorization-server.git
      else
        git remote add testorigin https://${SECRET_USERNAME}:${SECRET_TOKEN}@github.com/IBS-Skillset/${repo}.git
      fi
      git config --global user.email $SECRET_EMAIL
      git config --global user.name $SECRET_USERNAME
      git checkout -B main
      git fetch --all
      git reset --hard testorigin/main
      export NEWIMAGETAG=${!repoUri}:$IMAGE_TAG
      echo $NEWIMAGETAG
      ./yq -i ".spec.template.spec.containers[0].image = \"$NEWIMAGETAG\"" deploy/deployment.yaml
      git add .
      git commit -m "Updating deployment yaml with updated version ${NEWIMAGETAG}"
      git push testorigin main
      printf '[{"name":"%s","imageUri":"%s"}]' "$repo" ${!repoUri}:"$IMAGE_TAG" >> imageDefinitions.json
      cat imageDefinitions.json
    fi
done
if [ $TAG == "hotel-book" ]
then
  docker push "$REPOSITORY_URI_CMD":"$IMAGE_TAG"
  docker push "$REPOSITORY_URI_QUERY":"$IMAGE_TAG"
  printf '[{"name":"book-cmd","imageUri":"%s"}]','[{"name":"book-query","imageUri":"%s"}]' "$REPOSITORY_URI_CMD":"$IMAGE_TAG" "$REPOSITORY_URI_QUERY":"$IMAGE_TAG" >> imageDefinitions.json
  cat imageDefinitions.json
fi