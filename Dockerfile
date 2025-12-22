FROM ruby:3.2.2

# System dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    yarn \
    postgresql-client \
    build-essential \
    libpq-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /speakerinnen_liste

# 1️⃣ Install Bundler 2.4 in system gems (default GEM_HOME)
RUN gem update --system
RUN gem install bundler -v '~> 2.4'

# 2️⃣ Copy Gemfiles first (for caching)
COPY Gemfile* ./

# 3️⃣ Install gems into /bundle, but use system Bundler
ENV BUNDLE_PATH=/bundle
RUN bundle install

# 4️⃣ Copy the rest of the app
COPY . .

# Default command
CMD ["bash"]
