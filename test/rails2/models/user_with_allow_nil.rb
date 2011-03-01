class UserWithAllowNil < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :name

  validates_existence_of :name, :allow_nil => true

end