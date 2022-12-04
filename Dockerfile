FROM gcc:9.5.0 as compiler
COPY . /tmp
WORKDIR /tmp
RUN bash compile.sh

FROM debian:11-slim
RUN apt-get update
RUN apt-get -y install libcurl4-openssl-dev
WORKDIR /usr/app
COPY --from=compiler /tmp/a.out /usr/app/a.out
ENTRYPOINT ["/usr/app/a.out"]
