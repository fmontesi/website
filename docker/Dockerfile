FROM alpine as Build

WORKDIR /

RUN apk update && \
		apk add git
RUN git clone --depth=1 --recurse-submodules https://github.com/fmontesi/website.git /git
# RUN rm -rf /www/.git && rm -rf /www/docker

# Start from scratch, copy the installer, install, remove the installer.
FROM jolielang/jolie:1.9.1
COPY --from=Build /git/app /app
COPY --from=Build /git/web /web

WORKDIR /app

EXPOSE 8080

CMD ["jolie","main.ol"]
