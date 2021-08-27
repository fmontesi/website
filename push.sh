#!/bin/sh

docker build . -f docker/Dockerfile -t fmontesi/website
docker push fmontesi/website
