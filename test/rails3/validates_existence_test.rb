require 'test_helper.rb'

class TestValidatesExistence < Test::Unit::TestCase

  def setup
    ActiveRecord::Schema.define(:version => 1) do

      create_table :names, :force => true do |t|
        t.column :name, :string
      end

      create_table :users, :force => true do |t|
        t.references :name
        t.references :relation, :polymorphic => true
      end

      create_table :users2, :force => true do |t|
        t.column :custom_id, :integer
      end

    end
  end

  def teardown
    ActiveRecord::Base.connection.drop_table(:users)
    ActiveRecord::Base.connection.drop_table(:names)
  end

  def test_save_with_no_relation
    user = User.new
    assert_equal    user.save, false
    assert_not_nil  user.errors[:name]
    assert_not_nil  user.errors[:name_id]
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
    assert_equal UserWithPoly.new.save, false
  end

  def test_poly_relation_with_name
    name = Name.create(:name => "bar")
    assert_equal UserWithPoly.new(:relation => name).save, true
  end

  def test_poly_relation_with_allow_nil
    assert_equal UserWithPolyAllowNil.new.save, true
  end

  def test_argument_error
    assert_raise ArgumentError do
      UserWithHasMany.new.save
    end
  end

  def test_errors_on_one_field
    user = UserWithBoth.new
    user.save

    assert_not_nil  user.errors[:name]
    assert_empty    user.errors[:name_id]
  end

  def test_save_with_new_record
    name = Name.create(:name => "foobar")
    user = User.create(:name => name)

    user.name = Name.new
    user.save

    assert_not_nil user.errors[:name]
  end

  def test_save_with_new_record_and_allow_new
    name = Name.new(:name => "foo")
    assert_equal UserWithAllowNew.new(:name => name).save, true
  end

  def test_save_with_custom_fk
    user = UserWithFk.new
    user.save

    assert_not_nil user.errors[:name]
    assert_not_nil user.errors[:custom_id]
  end

  def test_message_without_i18n
    I18n.locale = :en

    user = User.new :name_id => 100
    user.save

    assert_equal ["does not exist"], user.errors[:name]
  end

  def test_message_with_i18n
    I18n.load_path << File.expand_path("./test/shared/locales/pt.yml")
    I18n.backend.send(:init_translations)
    I18n.locale = :pt

    user = User.new :name_id => 100
    user.save

    assert_equal %w(inexistente), user.errors[:name]
  end

  def test_old_syntax
    name = Name.create(:name => "foo")
    assert_equal UserWithOldSyntax.new(:name => name).save, true
  end

end

