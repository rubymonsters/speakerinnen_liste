# How to contribute

So you want to make Speakerinnen Liste better. Great!

Here are the steps to contribute:

## Grab an issue

Here, you'll have an overview over the open issues: https://github.com/rubymonsters/speakerinnen_liste/issues/216. We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

If you have other ideas feel free to open an own issue!


## Working on your own branch

1. [Fork](https://help.github.com/articles/fork-a-repo) the main repository.
   This is your own copy of the `speakerinnen_liste` project to work in.
2. Clone your repository to your local machine.
3. `git checkout -b newdesign`
This creates a new branch, called `newdesign` in our example, in your local repository.
4. Make your changes.
5. `git commit`
6. `git push origin newdesign:newdesign`
This pushes your new branch called `newdesign` to your GitHub repository.

## Integrating your working code to master

When you have made your changes and tested them, please send us a [pull request](https://help.github.com/articles/about-pull-requests/).

## Before you start working

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
bundle exec rspec
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

## Git(Hub) Help

If you have any questions about Git or GitHub, [GitHub
Help](https://help.github.com/) is a great resource!
