[![Build Status](https://travis-ci.org/rubymonsters/speakerinnen_liste.png)](https://travis-ci.org/rubymonsters/speakerinnen_liste) [![Code Climate](https://codeclimate.com/github/rubymonsters/speakerinnen_liste.png)](https://codeclimate.com/github/rubymonsters/speakerinnen_liste)

speakerinnen.org is a searchable web directory designed specifically for women conference speakers. Women speakers are encouraged to sign up and provide professional information, including their area of expertise, any previous conferences they've presented at, contact details, etc.

The aim of the app is to provide a way for conference and event organizers to find and contact appropriate women speakers. (But obviously there are many different contexts in which it can be used...)

==================

Do you want to contribute?

If you want to contribute, you can get an overview over the open issues. We are happy to answer your questions if you consider to help. All the issues have a link to their specification. If you want to work on an issue feel free to assign yourself.

https://github.com/rubymonsters/speakerinnen_liste/issues/216

For your database.yml please copy config/database_example.yml

For testing locally you have to create some profiles manually. It is important to confirm these profiles.
Normally that works via email. Locally you do that via the console:

```Ruby
rails c
user = Profile.find(<your-profile-id>)
user.confirmed_at = DateTime.now
user.save
```

If you build or test some admin features you have to create an admin user. You also can assign the status via the console:

```Ruby
rails c
user = Profile.find(<your-profile-id>)
user.admin = true
user.published = true
user.save
```

General Workflow: To work on an issue please open a feature branch derived from the master branch. When you have made your changes and tested them, please send us a pull request.
