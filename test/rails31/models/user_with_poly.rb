class UserWithPoly < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :relation, :polymorphic => true

  validates :relation, :existence => true

end
