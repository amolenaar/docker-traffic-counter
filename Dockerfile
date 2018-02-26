# Alias this container as builder:
FROM bitwalker/alpine-elixir:1.5.2 as builder

RUN \
    apk update && \
    apk --no-cache --update add \
      g++ \
      make \
      libpcap-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /work

ENV MIX_ENV=prod

# Umbrella
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
COPY rel rel

RUN mix do deps.get, deps.compile
RUN mix release --env=prod --verbose

### Release

FROM alpine:3.7

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl docker libpcap

EXPOSE 9100

ENV PORT=9100 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/bash

WORKDIR /docker_traffic_counter

COPY --from=builder /work/_build/prod/rel/docker_traffic_counter/releases/0.1.0/docker_traffic_counter.tar.gz .

RUN tar zxf docker_traffic_counter.tar.gz && rm docker_traffic_counter.tar.gz

RUN chown -R root ./releases

USER root

ENTRYPOINT ["/docker_traffic_counter/bin/docker_traffic_counter"]
CMD ["foreground"]
