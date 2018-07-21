#!/bin/sh

docker run -it --rm \
	-v "$(pwd)"/web:/web \
	-v "$(pwd)"/app:/app \
	-w /app \
	-p 8080:8080 \
	jolielang/jolie \
	jolie main.ol
