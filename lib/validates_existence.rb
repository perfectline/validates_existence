if Rails::MAJOR >= 3
  require "rails3/validator"
else
  require "rails2/validator"
  ActiveRecord::Base.extend(Perfectline::ValidatesExistence)
end