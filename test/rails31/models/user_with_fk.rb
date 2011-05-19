class UserWithFk < ActiveRecord::Base

  self.table_name = "users2"

  belongs_to :name, :foreign_key => :custom_id

  validates :name, :existence => true

end