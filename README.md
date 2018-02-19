[![Build Status](https://travis-ci.org/rubymonsters/speakerinnen_liste.png)](https://travis-ci.org/rubymonsters/speakerinnen_liste) [![Code Climate](https://codeclimate.com/github/rubymonsters/speakerinnen_liste.png)](https://codeclimate.com/github/rubymonsters/speakerinnen_liste)

speakerinnen.org is a searchable web directory designed specifically for women conference speakers. Women speakers are encouraged to sign up and provide professional information, including their area of expertise, any previous conferences they've presented at, contact details, etc.

The aim of the app is to provide a way for conference and event organizers to find and contact appropriate women speakers. (But obviously there are many different contexts in which it can be used...)

==================

## Getting Started

1. For your database.yml please copy config/database_example.yml (Example below in Mac OS X or Linux):

	```
	cp config/database_example.yml config/database.yml
	```

2. Install [PostgreSQL](http://www.postgresql.org/download/) (it depends on your OS) - currently (2018-02) we use PostgreSQL 9.5.5

3. [Create a PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2) user with the same name as your username

4.a) With a **Mac**: Install [elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/setup.html) - we use version 2.4. If you are on a Mac and use homebrew and have any issues to install the old version (which is 'keg only'), try ```brew link —force elasticsearch@2.4``` to make elasticsearch run.

4.b) With a **ubuntu** you follow that guide to install [elasticseach 2.4.5](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-16-04) PAY ATTENION TO THE VERSION!

to install:
```bash
$ wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-2.4.5.deb
$ sudo dpkg -i elasticsearch-2.4.5.deb
$ sudo update-rc.d elasticsearch defaults
```

to start:
```bash
$ sudo service elasticsearch status
$ sudo service elasticsearch start
$ be rake elasticsearch:import:all
```

to test:
```bash
curl "localhost:9200/_nodes/settings?pretty=true"
```

To get the tests running:

You have to start elasticsearch!
```bash
$ export ES_VERSION=2.4.5
$ curl -sS https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ES_VERSION}/elasticsearch-${ES_VERSION}.tar.gz | tar xz -C ./tmp
$ export TEST_CLUSTER_COMMAND=./tmp/elasticsearch-2.4.5/bin/elasticsearch
$ sudo service elasticsearch start
bundle expec rspec
```

if the tests are still failing:
```
rake db:test:clone
```

5. Install Bundler (if you don't have it already)
	```
	gem install bundler
	```

6. Install gems:
	```
	bundle install
	```

7. Create the database:
	```
	bundle exec rake db:create
	```

8. Run the database migrations:
	```
	bundle exec rake db:migrate
	```

9. Run the database seeds:
	```
	bundle exec rake db:seed
	```
10. Import the profiles into the elasticsearch index with: ```bundle exec rake elasticsearch:import:all```

11. Start elasticsearch with ```elasticsearch``` on port 9200 (make sure elasticsearch is running when you start the app and want to use any search related features - also specs depend on a running elasticsearch instance)

12. Run the app:
	```
	bundle exec rails s
	```

13. If you build or test some admin features you have to create an admin user. You also can assign the status via the console:
	```
	rails c
	user = Profile.find(<your-profile-id>)
	user.admin = true
	user.save
	```

# Contributing

Do you want to contribute?

If you want to contribute, you can get an overview over the open issues. We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

https://github.com/rubymonsters/speakerinnen_liste/issues/216

Find further details in: https://github.com/rubymonsters/speakerinnen_liste/blob/master/CONTRIBUTING.md
