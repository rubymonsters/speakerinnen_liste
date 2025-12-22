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

# Set app-specific gem path
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Update RubyGems
RUN gem update --system

# Install Bundler 2.4 directly into /bundle
RUN gem install bundler -v '~> 2.4' --install-dir /bundle --bindir /bundle/bin

# Copy Gemfiles first (for caching)
COPY Gemfile* ./

# Install gems using Bundler 2.4
RUN bundle _2.4_ install

# Copy the rest of the app
COPY . .

# Default command
CMD ["bash"]
