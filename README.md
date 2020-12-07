[![Build Status](https://travis-ci.org/rubymonsters/speakerinnen_liste.png)](https://travis-ci.org/rubymonsters/speakerinnen_liste) [![Code Climate](https://codeclimate.com/github/rubymonsters/speakerinnen_liste.png)](https://codeclimate.com/github/rubymonsters/speakerinnen_liste)

# About speakerinnen.org

speakerinnen.org is a searchable web directory designed specifically for women conference speakers. Women speakers are encouraged to sign up and provide professional information, including their area of expertise, any previous conferences they've presented at, contact details, etc.

The aim of the app is to provide a way for conference and event organizers to find and contact appropriate women speakers. (But obviously there are many different contexts in which it can be used...)

# Getting Started (Initial Setup)

1. Clone the repository: `git clone git@github.com:rubymonsters/speakerinnen_liste.git` and access the folder: `cd speakerinnen_liste`. (If you have cloned the repository before and there is still an .env file, delete it.)
2. If you don't have Docker Engine installed, please download it [here](https://docs.docker.com/install) for your operating system.
3. Run `make setup` (builds images, installs gems, creates and migrates the datasase).
4. Run `make seed` (seeds database with example profiles and indexes them in Elasticsearch).

## Development

* `make dev` (opens a development shell, `rake`, `bundle` or `rails` commands will work here)
* `make up` (starts the app directly)
* `make test` (runs all the tests)
* `make usage` (get a list of possible commands)


## Admin user

  If you build or test admin features, you can use the test admin user to test those. The admin user can be found in [db/seeds.rb](db/seeds.rb#L156-L179). 

  Alternatively, assign the `admin` status to another user via the rails console:

  ```ruby
  # Open a dev shell
  $ make dev

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

First, open a dev shell by running `make dev`.

```
# Run all tests of the project (same as running `make test`)
$ bundle exec rspec spec

# If the tests are still failing, run:
$ bundle exec rake db:test:clone

# If tests are still failing, run:
$ rails db:test:prepare

# Run tests excluding elasticsearch specs, so without a running elasticsearch server
$  bundle exec rspec spec --tag '~elasticsearch'
```

# Please use Rubocop

```
# Open a dev shell
$ make dev
# Run rubocop and correct all errors it finds
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

# Deployment

We use Heroku to deploy.

# Contributing

Do you want to contribute?

If you want to contribute, you can get an overview over the open issues on our [Project Management Board](https://github.com/rubymonsters/speakerinnen_liste/projects/1) and via https://github.com/rubymonsters/speakerinnen_liste/issues/216.

We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

Find further details in [CONTRIBUTING.md](CONTRIBUTING.md).

# ♥ Code of Conduct

Please note that [speakerinnen](https://speakerinnen.org) has a [Contributor Code of Conduct](https://github.com/rubymonsters/speakerinnen_liste/blob/master/code-of-conduct.md) based on the [Contributor Covenant](https://www.contributor-covenant.org). By participating in this project online or at events you agree to abide by its terms.
