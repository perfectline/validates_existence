class UserWithAllowNil < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :name

  validates :name, :existence => true, :allow_nil => true

end