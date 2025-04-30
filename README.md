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

  sudo gem install ninjudd-deep_clonable -s http://gems.github.com
  sudo gem install ninjudd-ordered_set -s http://gems.github.com
  sudo gem install ninjudd-model_set -s http://gems.github.com

## License

Copyright (c) 2025 Justin Balthrop, Geni.com; Published under The MIT License, see LICENSE
