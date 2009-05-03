module Perfectline
  module Validations

    class << self
      def bootstrap
        ActiveRecord::Validations.send(:include, Perfectline::Validations::ValidatesExistence)
      end
    end
  end
end