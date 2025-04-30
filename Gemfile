source "http://www.rubygems.org"

gemspec

gem 'deep_clonable',  '>= 1.1.0'
gem 'ordered_set',    '>= 1.0.1'

git 'https://github.com/makandra/rails.git', :branch => '2-3-lts' do
  gem 'rails',        '~>2.3.18'
  gem 'activerecord', :require => false
end

group :development, :test do
  gem 'method_source'
  gem 'pg'
  gem 'rake'
  gem 'rsolr'
  gem 'simplecov',  :require => false
  gem 'test-unit' # for shoulda-context
end