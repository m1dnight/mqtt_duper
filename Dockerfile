################################################################################
# Build Image
FROM elixir:1.15-slim as build
LABEL maintainer "Christophe De Troyer <christophe@call-cc.be>"

# Install compile-time dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git
RUN mkdir /app
WORKDIR /app

# Install Hex and Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Compile entire project.
COPY . .
RUN mix compile

# Build the entire release.
RUN mix release

################################################################################
# Release Image

FROM elixir:1.15-slim AS app

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssl locales libssl-dev

# Set the locale
# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV MIX_ENV=prod

# Make the working directory for the application.
RUN mkdir /app
WORKDIR /app

# Copy release from build container to this container.
COPY --from=build /app/_build/prod/rel/ .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["/app/mqtt_duper/bin/mqtt_duper", "start"]
