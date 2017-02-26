# TODO: base image on alpine; use Elixir release process to install docker container; use erlinit to get things started

FROM elixir:1.4.1

ENV MIX_ENV=prod

WORKDIR /work/

ADD apps ./apps
ADD config ./config
ADD mix.* ./

EXPOSE 9100

# We need the following applications:
# * docker
# * libpcap

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        software-properties-common \
    && curl -fsSL https://apt.dockerproject.org/gpg | apt-key add - \
    && add-apt-repository \
        "deb https://apt.dockerproject.org/repo/ debian-$(lsb_release -cs) main" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-engine \
        libpcap0.8-dev \
    && rm -rf /var/lib/apt/lists \
    && mix local.hex --force && mix local.rebar --force \
    && mix deps.get && mix compile

CMD ["mix", "run", "--no-halt"]
