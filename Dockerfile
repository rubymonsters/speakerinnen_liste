FROM ruby:2.6.5-alpine
COPY .build-deps /
RUN cat .build-deps | xargs apk add
RUN mkdir /speakerinnen_liste
WORKDIR /speakerinnen_liste
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN gem update --system
RUN gem install bundler
