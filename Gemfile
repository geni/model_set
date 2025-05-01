source "http://www.rubygems.org"

gemspec

git 'https://github.com/makandra/rails.git', :branch => '2-3-lts' do
  gem 'rails',        '~>2.3.18'
  gem 'activerecord', :require => false
end

group :development, :test do
  gem 'method_source'
  gem 'pg'
  gem 'rake'
  gem 'simplecov',  :require => false
  gem 'test-unit' # for shoulda-context
end