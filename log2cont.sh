#!/bin/bash


ENV=.env

if [ -f "$ENV" ]; then
    . $ENV
else
    . /opt/docker/wospi/$ENV
fi

docker exec -ti ${IMAGE_NAME} bash

