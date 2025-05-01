# ModelSet

ModelSet is a array-like class for dealing with sets of ActiveRecord models. ModelSet
stores a list of ids and fetches the models lazily only when necessary. You can also add
conditions in SQL to further limit the set. Currently I support alternate queries using
the Solr search engine through a subclass, but I plan to abstract this out into a "query
engine" class that will support SQL, Solr, Sphinx, and eventually, other query methods
(possibly raw RecordCache hashes and other search engines).

## Usage
```ruby
class RobotSet < ModelSet
end

set1 = RobotSet.new([1,2,3,4]) # doesn't fetch the models

set1.each do |model| # fetches all
  # do something
end

set2 = RobotSet.new([1,2])

set3 = set1 - set2
set3.ids
# => [3,4]

set3 << Robot.find(5)
set3.ids
# => [3,4,5]
```

## Install
```ruby
# Gemfile
gem 'model_set'
```

## Development

### Clone the repo
```sh
git clone git@github.com:geni/model_set.git
```

### Install gems
```sh
bundle install --clean --path vendor/bundle
```

### Create the database
```sh
psql -U postgres -c "CREATE DATABASE  model_set_test OWNER $(whoami | sed -e 's/\./_/g')"
```

### Run the tests
```sh
bundle exec rake test

# view the coverage report
elinks coverage/index.html
```

## License

Copyright (c) 2025 Justin Balthrop, Geni.com; Published under The MIT License, see LICENSE
