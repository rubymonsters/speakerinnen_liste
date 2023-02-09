![Build Status](https://github.com/rubymonsters/speakerinnen_liste/actions/workflows/docker_ci.yml/badge.svg) [![Code Climate](https://codeclimate.com/github/rubymonsters/speakerinnen_liste.png)](https://codeclimate.com/github/rubymonsters/speakerinnen_liste)

# About speakerinnen.org

speakerinnen.org is a searchable web directory designed specifically for women conference speakers. Women speakers are encouraged to sign up and provide professional information, including their area of expertise, any previous conferences they've presented at, contact details, etc.

The aim of the app is to provide a way for conference and event organizers to find and contact appropriate women speakers. (But obviously there are many different contexts in which it can be used...)

# Getting Started (Initial Setup)

1. Clone the repository: `git clone git@github.com:rubymonsters/speakerinnen_liste.git` and access the folder: `cd speakerinnen_liste`. (If you have cloned the repository before and there is still an .env file, delete it.)
2. Copy the file `database.yml.sample` and name it `database.yml` inside the config folder. (The sample-file is a placeholder showing the standard usecase. The file `database.yml` is for individual usage and changes and is ignored by git.)
3. If you don't have Docker Engine installed, please download it [here](https://docs.docker.com/install) for your operating system.
4. Run `make setup` (builds images, installs gems, creates and migrates the database).
5. Run `make seed` (seeds database with example profiles and indexes them in Elasticsearch).

## Local development with Docker (default) -> at the moment this doesn't work on Apple Silicon chips, we are working on a fix.

* `make dev` (opens a development shell, `rake`, `bundle` or `rails` commands will work here)
* `make up` (starts the app directly)
* `make stop` (stops the container)
* `make test` (runs all the tests)
* `make usage` (get a list of possible commands)

### Local development without Docker (this is a workaround)

You need to define DATABASE_URL to point to your local Postgres and SEARCHBOX_URL to point to your local Elastic (Make sure those are set up with the right versions, etc.):  

This command for example runs the tests directly on your machine using the local postgres and elastic:

```
$ DATABASE_URL=postgres://127.0.0.1/ SEARCHBOX_URL=http://127.0.0.1:9200/ bundle exec rspec
```

This matches our settings in config/database.yml, but if you have different user, password or db name you can put all that in DATABASE_URL as explained here: https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING.
Or you comment out `host`, `username` and `password` in your config/database.yml.

Issues you might run into:
1. Docker might create files in tmp that the process in your machine can't overwrite. Do ```sudo rm -rf tmp``` to delete.
2. Rails can't write to log/test.log and might print to screen instead. To delete do: ``` sudo rm -rf log/ ```
3. If you have problem with `bundle install`, throw away the Gemfile.lock and re-run the command.

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

#Troubleshooting

## Docker

### Use upgraded Postgres or Elasticsearch version in Docker
If Postgres or Elasticsearch got upgraded in the docker-compose file, you need to delete all processes, images 
and volumes that still use the older version:
1. Use ```make tear-down``` to delete all processes and images

2. Delete all your local volumes inside Docker as well. (Otherwise you will get a DB connection error)
Check for your speakerinnen volumes in Docker:
``` docker volume ls ```
Ouput will be a list of volumes, pick all the speakerinnen ones (Postgres, Elasticsearch, Bundle) and delete them (adjust the name if yours is 
different):

    ``` docker volume rm speakerinnen_liste_postgres_data ```

    ```docker volume rm speakerinnen_liste_bundle```

    ```docker volume rm speakerinnen_liste_elastic_data```

3. ```make setup``` to recreate all images, processes and volumes.

4. ```make seed``` to populate the volumes.


# ♥ Code of Conduct

Please note that [speakerinnen](https://speakerinnen.org) has a [Contributor Code of Conduct](https://github.com/rubymonsters/speakerinnen_liste/blob/master/code-of-conduct.md) based on the [Contributor Covenant](https://www.contributor-covenant.org). By participating in this project online or at events you agree to abide by its terms.
