[![Build Status](https://travis-ci.org/rubymonsters/speakerinnen_liste.png)](https://travis-ci.org/rubymonsters/speakerinnen_liste) [![Code Climate](https://codeclimate.com/github/rubymonsters/speakerinnen_liste.png)](https://codeclimate.com/github/rubymonsters/speakerinnen_liste)

# About speakerinnen.org

speakerinnen.org is a searchable web directory designed specifically for women* conference speakers. Women* speakers are encouraged to sign up and provide professional information, including their area of expertise, any previous conferences they've presented at, contact details, etc.

The aim of the app is to provide a way for conference and event organizers to find and contact appropriate women* speakers. (But obviously there are many different contexts in which it can be used...)

**Please note: Sometimes for better readability in long passages of text the term `women` is written without a star but we always mean everyone who defines herself as a woman.**


# Technical Requirements

- Ruby v2.4.2
- Ruby on Rails, '5.2.0'
- Elasticsearch v2.4.5 - https://www.elastic.co
- ImageMagick - https://www.imagemagick.org
- PostgreSQL v9.5.5 - https://www.postgresql.org
- Bundler - https://bundler.io

- we use heroku to deploy, honeycomb to show metrics, elasticsearch for search

# Getting Started

## 1. Copy & Configuration

**1.1 Copy `config/database_example.yml` and create your own `database.yml` file and make sure it is always set to `.gitignore`:**

```bash

$ cp config/database_example.yml config/database.yml
```

**1.2 Adjust the settings of that config file according to your needs and ensure you have all server environments (development, test, staging, production) configured.**


## 2. Postgres

**2.1 Install [PostgreSQL](http://www.postgresql.org/download/) dependent on your operating system**

**2.2 Create a [PostgreSQL user](https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2) that is needed to log into the database (by default a `postgres` superuser is created after installation)**

## 3. Elasticsearch

**3.1 Install Elasticsearch 2.4**

### Mac

b) via homebrew

```bash

# Before Installation
$ brew search elasticsearch # this will list all available Elasticsearch versions

# Installation
$ brew install elasticsearch@2.4

# After installation
$ echo 'export PATH="/usr/local/opt/elasticsearch@2.4/bin:$PATH"' >> ~/.zshrc # please check, if you have to replace `~/.zshrc` with any other dotfile, e.g. .bash_profile, .bashrc, etc.
$ brew services list # check if Elasticsearch is now listed as brew services
$ brew services start elasticsearch@2.4

# Optional: Set a symlink and run Elasticsearch automatically on startup
$ ln -sfv /usr/local/opt/elasticsearch@2.4/*.plist ~/Library/LaunchAgents

# Troubleshooting:
If you have any issues to install the old version (which is 'keg only'), try `$ brew link —force elasticsearch@2.4` to make Elasticsearch run.
```

### Ubuntu

**3.2 c) Please follow the guide to install [Elasticseach 2.4.5](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-16-04) and pay attention to the version!**

```bash

# Installation Option 1: wget
$ wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-2.4.5.deb
$ sudo dpkg -i elasticsearch-2.4.5.deb
$ sudo update-rc.d elasticsearch defaults

# Installation Option 2: curl
$ export ES_VERSION=2.4.5
$ curl -sS https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ES_VERSION}/elasticsearch-${ES_VERSION}.tar.gz | tar xz -C ./tmp

# Set the test cluster command path for Elasticsearch
$ export TEST_CLUSTER_COMMAND=./tmp/elasticsearch-2.4.5/bin/elasticsearch

# Check the Elasticsearch status
$ sudo service elasticsearch status

# Start Elasticsearch
$ sudo service elasticsearch start
```

Please note: You can either export the variables any time you need them with `$ export VARIABLE_KEY=value` or you can store them permanently in your `.env` file and load it into your current project with `$ source .env`. To verify your env variables are now set, run `$ echo $VARIABLE_KEY` or to unset run `$ unset VARIABLE_KEY`.


### Browser Download

https://www.elastic.co/downloads/past-releases/elasticsearch-2-4-5

For more info, please follow the setup instructions here:
https://www.elastic.co/guide/en/elasticsearch/reference/2.4/setup.html


**3.3 After installation verify your Elasticsearch is working:**

```json

$ curl "localhost:9200/_nodes/settings?pretty=true"

// You should see a response like this
{
  "cluster_name" : "elasticsearch_username",
  "nodes" : {
    "z3J_O6uhQYeLc46hAGhWaQ" : {
      "name" : "Karolina Dean",
      "transport_address" : "127.0.0.1:9300",
      "host" : "127.0.0.1",
      "ip" : "127.0.0.1",
      "version" : "2.4.6",
      "build" : "5376dca",
      "http_address" : "127.0.0.1:9200",
      "settings" : {
        "name" : "Karolina Dean",
        "client" : {
          "type" : "node"
        },
        "cluster" : {
          "name" : "elasticsearch_username"
        },
        "path" : {
          "data" : "/usr/local/var/elasticsearch/",
          "logs" : "/usr/local/var/log/elasticsearch",
          "home" : "/usr/local/Cellar/elasticsearch@2.4/2.4.6/libexec"
        },
        "config" : {
          "ignore_system_properties" : "true"
        }
      }
    }
  }
}
```

## 4. Setup the project


**4.1 Install Bundler (if you don't have it already)**

  ```ruby

  $  gem install bundler
  ```

**4.2. Install the gems:**

  ```ruby

  $ bundle install
  ```

**4.3 Create the database:**

  ```ruby

  $ bundle exec rake db:create
  ```

**4.4. Run the database migrations:**

  ```ruby

  $ bundle exec rake db:migrate
  ```

**4.5 Run the database seeds:**

  ```ruby

  $ bundle exec rake db:seed # this will create initial profiles that are listed in the db/seed.rb
  ```

**4.6 Import the profiles into the Elasticsearch index:**

  ```ruby
  $ bundle exec rake elasticsearch:import:all
  ```

**4.7 Before you start the rails server, make sure `Elasticsearch` is running (this is required to use the search and specs that depend on a running Elasticsearch instance)**

  a) direct startup:

  Start Elasticsearch with `$ elasticsearch` on port 9200 (default port)

  b) via homebrew:

  ```bash

  $ brew services start elasticsearch@2.4
  ```

  c) via sudo service (ubuntu):

  ```bash

  $ sudo service elasticsearch start
  ```

**4.8 Run the app:**

  ```ruby

  $ bundle exec rails s
  ```

**4.9 Admin user**

  If you build or test some admin features you have to create an admin user (by default the admin attribute for each user is set to false) except 1 admin user is initially created by the `db/seed.rb` file.

  You also can assign the admin status of a user via the rails console:

  ```ruby

  # Log into the rails console
  $ bundle exec rails c

  # Inside the rails console
  user = Profile.find(<your-profile-id>)
  user.admin = true
  user.save

  # Verify your user admin status
  user.valid?

  # => true
  ```

# Testing

```ruby

# Run all tests of the project
$ bundle exec rspec spec

# If the tests are still failing, run:
$ bundle exec rake db:test:clone

# If tests are still failing, run:
$ rails db:test:prepare
```

# Please use Rubocop

```ruby
# Runs rubocop and corrects all errors it can
$ rubocop -a
```

# Database:
Our database schema looks like that:


![db](https://user-images.githubusercontent.com/1218914/43900439-368fa600-9be5-11e8-8f9c-d209784de1ef.jpg)

# Metrics
For seeing our metrics we use the free community edition of honeyycomb ( https://ui.honeycomb.io/login )
More infos how to use this: https://docs.honeycomb.io/beeline/ruby/

# Logging
We are using papertrail.
`heroku addons:open papertrail --app speakerinnen-liste`

# Report Errors
We are using sentry.
`heroku addons:open sentry --app speakerinnen-liste`

# Contributing

Do you want to contribute?

If you want to contribute, you can get an overview over the open issues on our [Project Management Board](https://github.com/rubymonsters/speakerinnen_liste/projects/1) and via https://github.com/rubymonsters/speakerinnen_liste/issues/216.

We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

Find further details in: https://github.com/rubymonsters/speakerinnen_liste/blob/master/CONTRIBUTING.md

# ♥ Code of Conduct

Please note that [speakerinnen](htts://speakerinnen.org) has a [Contributor Code of Conduct](https://github.com/rubymonsters/speakerinnen_liste/blob/master/code-of-conduct.md) based on the [Contributor Covenant](https://www.contributor-covenant.org). By participating in this project online or at events you agree to abide by its terms.
