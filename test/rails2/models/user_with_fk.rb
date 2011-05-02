class UserWithFk < ActiveRecord::Base

  self.table_name = "users2"

  belongs_to :name, :foreign_key => :custom_id

  validates_existence_of :name

end