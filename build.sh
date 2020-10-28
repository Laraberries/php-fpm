#!/usr/bin/env bash

#PHP_VERSION=7.2
#PHP_VERSION=7.3
PHP_VERSION=7.4
#PHP_VERSION=latest

PREFIX=edge
SUFFIX=-fpm
NAME=${PREFIX}-${PHP_VERSION}

if [[ ${PHP_VERSION} == "latest" ]]; then
    PREFIX=latest
    SUFFIX=""
    NAME=latest
fi

docker buildx build \
    --output "type=image,push=false,name=${NAME}" \
    --platform linux/amd64,linux/arm,linux/arm64 \
    --build-arg VERSION=${NAME} \
    --build-arg MINOR_PHP_VERSION=${PHP_VERSION:0:3} \
    --build-arg FULL_PHP_VERSION=${PHP_VERSION}${SUFFIX} \
    --tag "${DOCKER_IMAGE}:${NAME}" .
