class UserWithPolyAllowNil < ActiveRecord::Base

  self.table_name = "users"

  belongs_to :relation, :polymorphic => true

  validates_existence_of :relation, :allow_nil => true

end