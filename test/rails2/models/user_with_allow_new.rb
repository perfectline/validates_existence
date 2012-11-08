class UserWithAllowNew < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :name

  validates_existence_of :name, :allow_new => true

end
