# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is used both for local development (via docker-compose, see the
# `dev` stage) and for building the production image that Kamal deploys (the
# `production` stage). Keep the two in sync when adding system dependencies.

ARG RUBY_VERSION=3.4.9

# ---------------------------------------------------------------------------
# base: OS packages every environment needs at runtime
# ---------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION}-slim AS base

# Packages needed to *run* the app: image processing (libvips is the default
# Active Storage variant processor, imagemagick is kept for mini_magick),
# a postgres client, curl for health checks, and jemalloc for lower memory use.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      imagemagick \
      libjemalloc2 \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ---------------------------------------------------------------------------
# dev: image used by docker-compose (make up / make test / make console ...)
#
# Paths intentionally match the existing docker-compose volumes:
#   - source is bind-mounted at /speakerinnen_liste
#   - gems live in the `bundle` named volume at /bundle (installed via `make bundle`)
# so no gems or app code are baked in here.
# ---------------------------------------------------------------------------
FROM base AS dev

# Toolchain so native gems (pg, mini_racer, sassc, ...) compile inside `make bundle`.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libyaml-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /speakerinnen_liste

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem update --system && gem install bundler

# ---------------------------------------------------------------------------
# build: compile gems and assets for the production image
# ---------------------------------------------------------------------------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libyaml-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# Install gems first for better layer caching.
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code.
COPY . .

# Precompile bootsnap for faster boot.
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets without needing the real RAILS_MASTER_KEY / SECRET_KEY_BASE.
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# ---------------------------------------------------------------------------
# production: final, self-contained image deployed by Kamal
# ---------------------------------------------------------------------------
FROM base AS production

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_LOG_TO_STDOUT=1 \
    LD_PRELOAD=libjemalloc.so.2

# Copy compiled gems and the prepared app from the build stage.
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run as an unprivileged user.
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database on server boot.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Thruster fronts Puma: HTTP caching/compression + X-Sendfile on port 80.
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
