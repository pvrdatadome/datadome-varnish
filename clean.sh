#!/bin/sh

DOCKER_CONTAINER=nginx
DOCKER_IMAGE=my-nginx

docker rm -f $DOCKER_CONTAINER
docker rmi $DOCKER_IMAGE
