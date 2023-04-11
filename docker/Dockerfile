FROM jolielang/jolie:edge-dev AS build
ADD *.ol *.json /work/
COPY data /work/data
COPY private /work/private
COPY templates /work/templates
COPY web /work/web
WORKDIR /work
RUN sudo jpm install

FROM jolielang/jolie:edge
COPY --from=build /work /app
WORKDIR /app

EXPOSE 8080

CMD ["jolie","main.ol"]
