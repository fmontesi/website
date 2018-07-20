#!/bin/sh

docker run -it --rm \
	-v "$(pwd)"/web:/var/lib/leonardo/www \
	-v "$(pwd)"/docker/hooks:/server/leonardo/hooks \
	-p 8080:8080 \
	jolielang/leonardo
