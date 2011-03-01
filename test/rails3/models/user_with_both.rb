class UserWithBoth < ActiveRecord::Base
  self.table_name = "users"

  belongs_to :name

  validates :name, :existence => {:both => false}
end