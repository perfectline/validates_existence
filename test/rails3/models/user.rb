class User < ActiveRecord::Base

  belongs_to :name

  validates :name, :existence => true

end
