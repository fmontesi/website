FROM alpine/git as Build

WORKDIR /

RUN git clone --depth=1 --recursive https://github.com/fmontesi/website.git

FROM jolielang/jolie
COPY --from=Build /website/app /app
COPY --from=Build /website/web /web

WORKDIR /app
EXPOSE 8080
CMD ["jolie","main.ol"]
