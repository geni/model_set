require 'test/unit'
require 'pp'

unless defined?($SKIP_COVERAGE)
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    add_filter 'vendor'
  end
end

require 'model_set'

class Object
  def tap_pp(*args)
    pp [*args, self]
    self
  end
end

class Test::Unit::TestCase
  # overrides go here
end

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)
ActiveRecord::Migration.verbose = false
