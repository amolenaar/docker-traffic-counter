# TODO: base image on alpine; use Elixir release process to install docker container; use erlinit to get things started

FROM msaraiva/elixir-gcc:1.3.4

ENV MIX_ENV=prod

WORKDIR /app/


EXPOSE 9100

# We need the following applications:
# * docker
# * libpcap

RUN apk update \
    && apk add docker libpcap-dev \
    && rm -rf /var/cache/apk/*

ADD apps ./apps
ADD config ./config
ADD mix.* ./

RUN mix local.hex --force && mix local.rebar --force \
    && mix deps.get && mix compile

CMD ["mix", "run", "--no-halt"]
