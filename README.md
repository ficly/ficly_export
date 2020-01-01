# The Ficly Export Project

This won't do you much good if you don't have the data, but this is my attempt to turn Ficly into a static export.  I ended up building a Rails app and then writing a bunch of rake tasks and and after_action filter to just dump out all the files as cleanly as possible.

It took too long, but it works.

## Local Setup

### Requirements

* Ruby 2.6.3
* MySQL or MariaDB
  * The default database.yml is localhost, and root w/out a password.
  * The database name is `ficly_export`

### Getting the Data

The sql file to import is in db/export.sql.gz.  It's a little over 600mb uncompressed.  So, you'll need to do something like:

```cd db
gunzip export.sql.gz
mysql < export.sql
```

### Setting up Rails

* You'll need to install Ruby 2.6.5 however you want to make that happen.
* Install the bundler gem: `gem install bundler`
* `bundle`

And there you go!

## TODO

* Could be better looking, especially on mobile. You're welcome to help with that and submit a pull request!
* Speed up the export process. You're also welcome to help with that.  To look at the monster as it is, check out lib/tasks/export.rake.
