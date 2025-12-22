FROM ruby:3.2.2

# System dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    postgresql-client \
    build-essential \
    libpq-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /speakerinnen_liste

# Install Bundler 2.4 in system gems
RUN gem install bundler -v '~> 2.4'

# Configure app-specific gem path
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Copy Gemfiles first
COPY Gemfile* ./

# Install app gems
RUN bundle _2.4_ install

# Copy the rest of the app
COPY . .

CMD ["bash"]
