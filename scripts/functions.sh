docker_build() {
  echo $REGISTRY_AUTH_KEY | base64 -d > auth.json
  cat auth.json | docker login -u _json_key --password-stdin https://$REGISTRY

  if [ -z "$DOCKERFILE" ]; then
    DOCKERFILE='Dockerfile'
  fi

  if [ -z "$BUILD_CONTEXT" ]; then
    BUILD_CONTEXT='.'
  fi

  docker build -t "$REGISTRY/$GOOGLE_PROJECT_ID/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BRANCH" -f $DOCKERFILE $BUILD_CONTEXT
  docker push "$REGISTRY/$GOOGLE_PROJECT_ID/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BRANCH-$CIRCLE_BUILD_NUM"

  if [ "$CIRCLE_BRANCH" = "master" ] ; then
    docker tag "$REGISTRY/$GOOGLE_PROJECT_ID/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BRANCH" "$REGISTRY/$GOOGLE_PROJECT_ID/$CIRCLE_PROJECT_REPONAME:latest"
    docker push "$REGISTRY/$GOOGLE_PROJECT_ID/$CIRCLE_PROJECT_REPONAME:latest"
  fi
}
