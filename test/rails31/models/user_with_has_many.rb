class UserWithHasMany < ActiveRecord::Base
  self.table_name = "users"

  has_many :names

  validates :names, :existence => true
end