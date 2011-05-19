if Rails::VERSION::MAJOR >= 3
  if Rails::VERSION::MINOR >= 1
    require 'rails31'
    ActiveRecord::Base.send(:include, Perfectline::ValidatesExistence::Rails31)
  else
    require 'rails3'
    ActiveRecord::Base.send(:include, Perfectline::ValidatesExistence::Rails3)
  end
else
  require 'rails2'
  ActiveRecord::Base.send(:extend,  Perfectline::ValidatesExistence::Rails2)
end
