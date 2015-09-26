FROM ruby:2.2.1

# Run updates and install packages.
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      postgresql-client-9.4

# Set up working directory
ENV APP_HOME=/speakerinnen-liste
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Set up gems. This happens *before* the rest of the code is added in order to
# maximise the use of cache.
ADD Gemfile $APP_HOME/
ADD Gemfile.lock $APP_HOME/
RUN bundle install  --jobs 20

# Add application code (for deployment)
ADD . $APP_HOME/
