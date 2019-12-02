[![Build Status](https://travis-ci.org/rubymonsters/speakerinnen_liste.png)](https://travis-ci.org/rubymonsters/speakerinnen_liste) [![Code Climate](https://codeclimate.com/github/rubymonsters/speakerinnen_liste.png)](https://codeclimate.com/github/rubymonsters/speakerinnen_liste)

# About speakerinnen.org

speakerinnen.org is a searchable web directory designed specifically for women* conference speakers. Women* speakers are encouraged to sign up and provide professional information, including their area of expertise, any previous conferences they've presented at, contact details, etc.

The aim of the app is to provide a way for conference and event organizers to find and contact appropriate women* speakers. (But obviously there are many different contexts in which it can be used...)

**Please note: Sometimes for better readability in long passages of text the term `women` is written without a star but we always mean everyone who defines herself as a woman.**



# Getting Started

**1. Clone the repository:** `git clone git@github.com:rubymonsters/speakerinnen_liste.git` and access the folder: 
`cd speakerinnen_liste`.

**1.2 Copy `config/database_example.yml` and rename it to `database.yml` file and make sure it is always set to `.gitignore`:**

```bash

$ cp config/database_example.yml config/database.yml
```

**2. Setup project locally**
**2.1 Install Docker** If you don't have Docker installed, please download it [here](https://docs.docker.com/install/) for your operating system.

**2.2 DB setup (First time only):**  
**2.2.1** Create and migrate database: `docker-compose run web rake db:create db:migrate`
**2.2.2** Run database seeds: `docker-compose run web rake db:seed` # this will create initial profiles that are listed in the db/seed.rb
**2.2.3** Import the profiles into the Elasticsearch index: `docker-compose run web rake elasticsearch:import:all`

**2.3** Run all tests: `docker-compose run web rake spec` 
**2.4.** Run app: `docker-compose run web`

**Admin user**

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

# Run tests excluding elasticsearch specs, so without a running elasticsearch server
$  bundle exec rspec spec --tag '~elasticsearch'
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

#Deployment
We use Heroku to deploy.

# Contributing

Do you want to contribute?

If you want to contribute, you can get an overview over the open issues on our [Project Management Board](https://github.com/rubymonsters/speakerinnen_liste/projects/1) and via https://github.com/rubymonsters/speakerinnen_liste/issues/216.

We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

Find further details in: https://github.com/rubymonsters/speakerinnen_liste/blob/master/CONTRIBUTING.md

# ♥ Code of Conduct

Please note that [speakerinnen](https://speakerinnen.org) has a [Contributor Code of Conduct](https://github.com/rubymonsters/speakerinnen_liste/blob/master/code-of-conduct.md) based on the [Contributor Covenant](https://www.contributor-covenant.org). By participating in this project online or at events you agree to abide by its terms.
