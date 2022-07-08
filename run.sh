#!/bin/sh

docker run -it --rm \
	-v "$(pwd)"/web:/web \
	-v "$(pwd)"/app:/app \
	-v "$(pwd)"/templates:/templates \
	-w /app \
	-p 8080:8080 \
	jolielang/jolie:edge \
	jolie main.ol
