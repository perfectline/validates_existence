require 'rubygems'

gem 'activerecord', '~> 2'

require 'sqlite3'
require 'test/unit'
require 'active_record'
require 'active_record/base'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(
        "adapter" => "sqlite3",
        "database" => ":memory:"
)

require File.join(File.dirname(__FILE__), '..', 'rails', 'init.rb')

autoload :Name,                 File.join(File.dirname(__FILE__), 'models', 'name.rb')
autoload :User,                 File.join(File.dirname(__FILE__), 'models', 'user.rb')
autoload :UserWithAllowNil,     File.join(File.dirname(__FILE__), 'models', 'user_with_allow_nil.rb')
autoload :UserWithPoly,         File.join(File.dirname(__FILE__), 'models', 'user_with_poly.rb')
autoload :UserWithPolyAllowNil, File.join(File.dirname(__FILE__), 'models', 'user_with_poly_allow_nil.rb')