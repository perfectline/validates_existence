class UserWithAllowNew < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :name

  validates :name, :existence => { :allow_new => true }

end
