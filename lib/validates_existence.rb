if Rails::VERSION::MAJOR >= 3
  require 'rails3'
  ActiveRecord::Base.send(:include, Perfectline::ValidatesExistence::Rails3)
else
  require 'rails2'
  ActiveRecord::Base.send(:extend,  Perfectline::ValidatesExistence::Rails2)
end
