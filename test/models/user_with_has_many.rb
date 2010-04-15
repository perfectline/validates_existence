class UserWithHasMany < ActiveRecord::Base
  self.table_name = "users"

  has_many :names

  validates_existence_of :names
end