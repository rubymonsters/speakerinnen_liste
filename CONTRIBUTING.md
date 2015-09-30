# How to contribute

So you want to make Speakerinnen Liste better. Great!

Here are the steps to contribute:

##Grab an issue

Here, you'll have an overview over the open issues: https://github.com/rubymonsters/speakerinnen_liste/issues/216. We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

If you have other ideas feel free to open an own issue!


## Working on your own branch

1. [Fork](https://help.github.com/articles/fork-a-repo) the main repository.
   This is your own copy of the `speakerinnen_liste` project to work in.
2. Clone your repository to your local machine.
3. `git checkout -b newdesign`
This creates a new branch, called `newdesign` in our example, in your local
repository.
4. Make your changes.
5. `git commit`
6. `git push origin newdesign:newdesign`
This pushes your new branch called `newdesign` to your GitHub repository.

## Integrating your working code to master

When you have made your changes and tested them, please send us a pull request.

Do you want to contribute?

If you want to contribute, you can get an overview over the open issues. We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

## Before you start working

<ol>
<li>For your database.yml please copy config/database_example.yml (Example below in Mac OS X or Linux):
<p><code>
cp config/database_example.yml config/database.yml
</code></p>
</li>
<li>Install PostgreSQL (it depends on your OS):
<p>http://www.postgresql.org/download/</p>
</li>
<li>Create a PostgreSQL user with the same name as your username:
<p>https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2</p>
</li>
<li>Install Bundler (if you don't have it already):
<p><code>
gem install bundler
</code></p>
</li>
<li>Install gems:
<p><code>
bundle install
</code></p>
</li>
<li>Create the database:
<p><code>
bundle exec rake db:create
</code></p>
</li>
<li>Run the database migrations:
<p><code>
bundle exec rake db:migrate
</code></p>
</li>
<li>Run the database seeds:
<p><code>
bundle exec rake db:seed
</code></p>
</li>
<li>Run the app:
<p><code>
bundle exec rails s
</code></p>
</li>
<li>If you build or test some admin features you have to create an admin user. You also can assign the status via the console:
<p><code>
rails c
user = Profile.find(<your-profile-id>)
user.admin = true
user.save
</code></p>
</li>
</ol>
## Git(Hub) Help

If you have any questions about Git or GitHub, [GitHub
Help](https://help.github.com/) is a great resource!
