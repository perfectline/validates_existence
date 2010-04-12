class UserWithPoly < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :relation, :polymorphic => true

  validates_existence_of :relation

end
