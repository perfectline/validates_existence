module ActiveModel
  module Validations

    class ExistenceValidator < EachValidator

      def initialize(options)
        # set the default message if its unspecified
        options[:message] ||= :existence
        super(options)
      end

      def validate_each(record, attribute, value)
        normalized = attribute.to_s.sub(/_id$/, "").to_sym
        association = record.class.reflect_on_association(normalized)

        if association.nil? or !association.belongs_to?
          raise ArgumentError, "Cannot validate existence on #{normalized}, not a :belongs_to association"
        end

        target_class = nil

        # dealing with polymorphic belongs_to
        if association.options.has_key?(:foreign_type)
          foreign_type = record.__send__(association.options.fetch(:foreign_type))
          target_class = foreign_type.constantize unless foreign_type.nil?
        else
          target_class = association.klass
        end

        if target_class.nil? or !target_class.exists?(value)
          record.errors.add(attribute, options[:message], :default => "does not exist")

          # add the error on both :relation and :relation_id
          if options[:both]
            normalized = attribute.to_s.ends_with?("_id") ? normalized : "#{attribute}_id"
            record.errors.add(normalized, options[:message], :default => "does not exist")
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