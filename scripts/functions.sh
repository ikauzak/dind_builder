docker_build() {
  echo $REGISTRY_AUTH_KEY | base64 -d > auth.json
  cat auth.json | docker login -u _json_key --password-stdin https://$REGISTRY

  if [ -z "$IMAGE" ]; then
    IMAGE="$CI_PROJECT_PATH_SLUG"
  fi

  if [ -z "$IMAGE_TAG" ]; then
    IMAGE_TAG="$CI_COMMIT_REF_SLUG"
  fi

  if [ -z "$DOCKERFILE" ]; then
    DOCKERFILE='Dockerfile'
  fi

  if [ -z "$BUILD_CONTEXT" ]; then
    BUILD_CONTEXT='.'
  fi

  #.$(date +%Y%m%d)
  docker build -t "$REGISTRY/$IMAGE:$IMAGE_TAG" -f "$DOCKERFILE" "$BUILD_CONTEXT"
  docker push "$REGISTRY/$IMAGE:$IMAGE_TAG"

  if [ "$IMAGE_TAG" = "master" ] ; then
    docker tag "$REGISTRY/$IMAGE:$IMAGE_TAG" "$REGISTRY/$IMAGE:latest"
    docker push "$REGISTRY/$IMAGE:latest"
  fi
}
