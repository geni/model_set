lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'model_set'
  gem.version       = IO.read('VERSION')
  gem.authors       = ['Justin Balthrop', 'Scott Steadman']
  gem.email         = ['git@justinbalthrop.com', 'scott.steadman@geni.com']
  gem.description   = %q{Easy manipulation of sets of ActiveRecord models}
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/geni/model_set'
  gem.license       = 'MIT'

  # gem dependencies in Gemfile

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
