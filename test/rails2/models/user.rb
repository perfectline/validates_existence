class User < ActiveRecord::Base

  belongs_to :name

  validates_existence_of :name

end
