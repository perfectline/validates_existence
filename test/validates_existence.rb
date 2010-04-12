require 'test/unit'
require 'rubygems'

gem 'activerecord', '~> 2'

require 'sqlite3'
require 'active_record'
require 'active_record/migration'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(
        "adapter" => "sqlite3",
        "database" => ":memory:"
)

require File.join(File.dirname(__FILE__), '..', 'rails', 'init.rb')

class User < ActiveRecord::Base
  belongs_to :name

  validates_existence_of :name
end

class UserWithAllowNil < ActiveRecord::Base
  self.table_name = "users"

  belongs_to :name

  validates_existence_of :name, :allow_nil => true
end

class UserWithPolyName < ActiveRecord::Base
  self.table_name = "users"

  belongs_to :relation, :polymorphic => true

  validates_existence_of :relation
end

class UserWithPolyNameAllowNil < ActiveRecord::Base
  self.table_name = "users"

  belongs_to :relation, :polymorphic => true

  validates_existence_of :relation, :allow_nil => true
end

class Name < ActiveRecord::Base
end

class ValidatesExistenceTest < Test::Unit::TestCase

  def setup
    ActiveRecord::Schema.define(:version => 1) do

      create_table :names, :force => true do |t|
        t.column :name, :string
      end

      create_table :users, :force => true do |t|
        t.references :name
        t.references :relation, :polymorphic => true
      end

    end
  end

  def teardown
    ActiveRecord::Base.connection.drop_table(:users)
    ActiveRecord::Base.connection.drop_table(:names)
  end

  def test_save_with_no_relation
    assert_equal User.new.save, false
  end

  def test_save_with_relation
    name = Name.create(:name => "foo")
    assert_equal User.new(:name => name).save, true
  end

  def test_save_with_bogus_id
    assert_equal User.new(:name_id => 100).save, false
  end

  def test_allow_nil
    assert_equal UserWithAllowNil.new.save, true
  end

  def test_poly_relation
    assert_equal UserWithPolyName.new.save, false
  end

  def test_poly_relation_with_name
    name = Name.create(:name => "bar")
    assert_equal UserWithPolyName.new(:relation => name).save, true
  end

  def test_poly_relation_with_allow_nil
    assert_equal UserWithPolyNameAllowNil.new.save, true
  end

end


