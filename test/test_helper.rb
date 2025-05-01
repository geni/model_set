require 'test/unit'
require 'pp'

module CaptureRubyWarnings
  def warn(message)
    return if message =~ /assigned but unused variable/
    return if caller[0] =~ /vendor/ # Ignore warnings from vendored code
    super
  end
end

Warning.extend(CaptureRubyWarnings)

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
  :adapter  => "postgresql",
  :host     => "localhost",
  :username => `whoami`.chomp.tr('.', '_'),
  :password => '',
  :database => "model_set_test"
)
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.connection.client_min_messages = 'error'