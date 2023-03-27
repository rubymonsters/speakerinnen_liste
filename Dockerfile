FROM ruby:3.1.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /speakerinnen_liste
WORKDIR /speakerinnen_liste
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN gem update --system
RUN gem install bundler
