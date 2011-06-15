require 'active_support/concern'
require 'active_model'

module Perfectline
  module ValidatesExistence

    module Rails3
      extend ActiveSupport::Concern

      class ExistenceValidator < ActiveModel::EachValidator

        def initialize(options)
          # set the default message if its unspecified
          options[:message] ||= :existence
          options[:both]    = true unless options.key?(:both)
          super(options)
        end

        def validate_each(record, attribute, value)
          normalized = attribute.to_s.sub(/_id$/, "").to_sym
          association = record.class.reflect_on_association(normalized)

          if association.nil? || !association.belongs_to?
            raise ArgumentError, "Cannot validate existence on #{normalized}, not a :belongs_to association"
          end

          target_class = nil

          # dealing with polymorphic belongs_to
          if association.options[:polymorphic]
            foreign_type = record.send(association.options[:foreign_type] || association.foreign_type)
            target_class = foreign_type.constantize unless foreign_type.nil?
          else
            target_class = association.klass
          end

          if value.nil? || target_class.nil? || !target_class.exists?(value)
            errors = [attribute]

            # add the error on both :relation and :relation_id
            if options[:both]
              if Rails::VERSION::MINOR >= 1
                foreign_key = association.foreign_key
              else
                foreign_key = association.primary_key_name
              end

              errors << (attribute.to_s.ends_with?("_id") ? normalized : foreign_key)
            end

            errors.each do |error|
              record.errors.add(error, options[:message], :message => "does not exist")
            end
          end
        end
      end

      module ClassMethods
        def validates_existence_of(*attr_names)
          validates_with ExistenceValidator, _merge_attributes(attr_names)
        end
      end

    end
  end
end

