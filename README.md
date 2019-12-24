# Docker builder image

This is a docker in docker in docker image for building images with CircleCi variables and Google Container Registry (GCR) as default registry.

## Required variables:

`REGISTRY_AUTH_KEY`= Auth key for pushing images into a registry (in base64 string).

`REGISTRY`= The registry url (eg: `gcp.io`).

`GOOGLE_PROJECT_ID`= The google project id where the image will be pushed to.

**PS: Use `REGISTRY_AUTH_KEY` and `GOOGLE_PROJECT_ID` as environment 	variables in the project pipeline.**

## Extra variables:
`DOCKERFILE`= path/to/Dockerfile
`BUILD_CONTEXT` = path/to/build_context

eg:
`DOCKERFILE`= services/webapp/Dockerfile
`BUILD_CONTEXT`= services/webapp/

## Image tag:

This project will tag your image as follow:

`CIRCLE_PROJECT_REPONAME:CIRCLE_BRANCH`

eg: `dind_builder:master`/`dind_builder:develop`

If this container is being executed in a `master`branch, it will also push an image with the `latest`tag as well.

eg: `dind_builder:latest`

## How to use:

1 - `source /scripts/functions.sh`

2 - Use the `docker_build`function

## CircleCI pipeline example:

```yaml
jobs:
  build:
    docker:
      - image: us.gcr.io/infra-dev-challenge/dind-builder:latest
    environment:
      DOCKERFILE: services/webapp/Dockerfile
      BUILD_CONTEXT: services/webapp/
      REGISTRY: gcr.io
    steps:
      - checkout
      - setup_remote_docker
      - run:
          name: Functions inside the build container used in this job
          command: |
            source /scripts/functions.sh
            docker_build

workflows:
  build_and_push_image:
    jobs:
      - build
