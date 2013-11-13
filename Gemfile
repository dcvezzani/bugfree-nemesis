source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'
gem 'squeel'
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem "rails-backbone" #, git: "git://github.com/dcvezzani/backbone-rails.git"

# To use ACL
gem "devise", ">= 2.1.0"
gem "cancan"
gem 'role_model'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'
gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# Generate rtf documents
# git://github.com/clbustos/reportbuilder.git
#gem 'reportbuilder'
#gem 'clbustos-rtf'

#gem 'numbers_and_words', git: "git://github.com/kslazarev/numbers_and_words.git"
gem 'numbers_and_words'

# pdf generation
# gem "prawnto_2", :require => "prawnto"
gem 'prawn'
#gem 'prawn', :git => "git://github.com/sandal/prawn.git", :tag => '0.10.2', :submodules => true
gem 'pdf-reader'

# generate open office documents
#gem 'serenity-odt'

group :test do
  #gem 'steak', '0.4.0.a4'
  gem 'steak'
  gem 'capybara'

  # gem "email_spec", ">= 1.2.1"
  # gem "cucumber-rails", ">= 1.3.0", :require => false
  # gem "capybara", ">= 1.1.2"
  # #gem 'capybara', git: 'https://github.com/jnicklas/capybara.git'
  # gem "database_cleaner", ">= 0.7.2"
  # gem "launchy", ">= 2.1.0"
  # gem "minitest"

  # Pretty printed test output
  # gem 'turn', :require => false

  # automatic tests
  gem "watchr"
end

# for temporary testing
group :production do
  gem "faker"
  gem "factory_girl_rails", ">= 3.3.0"
end

group :development, :test do
  gem 'database_cleaner'

  #gem "rspec-rails", ">= 2.10.1"
  gem "rspec-rails", ">= 2.12.0"
  gem "faker"
  gem "factory_girl_rails", ">= 3.3.0"
  gem "shoulda"
  #gem "factory_girl_rails", ">= 3.3.0", :require => false
  #gem 'factory_girl', ">= 3.3.0", :require => false
  # gem 'guard'

  #gem "spork", "> 0.9.0.rc"
  gem "spork", "= 1.0.0rc3"
  # gem "guard-spork"
  # gem 'rb-fsevent' #, :require => false if RUBY_PLATFORM =~ /darwin/i # so that Guard can detect file changes on OS X (Mac)
  # gem 'guard-rspec'
  # gem 'guard-livereload'
  # gem 'guard-cucumber'
  # gem 'capybara-rails-log-inspection', :git => "https://github.com/johnbintz/capybara-rails-log-inspection.git"

  # To use debugger
  # gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'debugger'

  gem 'cmess', git: 'http://github.com/fac/cmess.git'
  gem 'nokogiri'

  gem 'wirble'
end
