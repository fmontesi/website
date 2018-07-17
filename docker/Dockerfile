FROM alpine as Build

WORKDIR /

RUN apk update && \
		apk add git
RUN git clone --depth=1 https://github.com/fmontesi/website.git /www
RUN rm -rf /www/.git && rm -rf /www/docker

# Start from scratch, copy the installer, install, remove the installer.
FROM jolielang/leonardo
COPY --from=Build /www /var/lib/leonardo/www
COPY hooks/* /server/leonardo/hooks/
COPY r2.html /var/lib/leonardo/www/
