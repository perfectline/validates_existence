if Rails::VERSION::MAJOR >= 3
  require "active_model"
  require "rails3/validator"

  ActiveModel::Validations.__send__(:include, Perfectline::ValidatesExistence::InstanceMethods)
  ActiveModel::Validations.__send__(:extend,  Perfectline::ValidatesExistence::ClassMethods)
else
  require "rails2/validator"
  
  ActiveRecord::Base.__send__(:extend, Perfectline::ValidatesExistence)
end