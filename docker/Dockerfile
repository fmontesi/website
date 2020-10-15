FROM alpine/git as Build

WORKDIR /

RUN git clone --depth=1 --recurse-submodules https://github.com/fmontesi/website.git /git
# RUN rm -rf /www/.git && rm -rf /www/docker

FROM jolielang/jolie
COPY --from=Build /git/app /app
COPY --from=Build /git/web /web

WORKDIR /app

EXPOSE 8080

CMD ["jolie","main.ol"]
