FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    postgresql-client \
    build-essential \
    libpq-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir /speakerinnen_liste
WORKDIR /speakerinnen_liste

# Use a dedicated gem path inside the container
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Update RubyGems
RUN gem update --system

# Install Bundler 2.4 explicitly
RUN gem install bundler -v '~> 2.4'

# Copy Gemfiles first for caching
COPY Gemfile* ./

# Install gems using Bundler 2.4
RUN bundle _2.4_ install

# Copy the rest of the app
COPY . .

# Default command
CMD ["bash"]

