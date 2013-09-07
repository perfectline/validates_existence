require "active_record"

module Perfectline
  module ValidatesExistence
    module Validator
      class ExistenceValidator < ActiveModel::EachValidator

        def initialize(options)
          # set the default message if its unspecified
          options[:message] ||= :existence
          options[:both]    = true unless options.key?(:both)
          options[:allow_new] = false unless options.key?(:allow_new)
          super(options)
        end

        def validate(record)
          attributes.each do |attribute|
            value = record.read_attribute_for_validation(attribute)
            target_id = if !attribute.match(/_id$/) && options[:allow_nil]
                association = record.class.reflect_on_association(attribute)
                association.respond_to?(:foreign_key)  ? record[association.foreign_key] : record[association.association_foreign_key]
              else
                value
              end
            next if (target_id.nil? && value.nil? && options[:allow_nil]) || (value.blank? && options[:allow_blank])
            validate_each(record, attribute, value)
          end
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

          if value.nil? || target_class.nil? || !exists?(target_class, value)
            errors = [attribute]

            # add the error on both :relation and :relation_id
            if options[:both]
              if ActiveRecord::VERSION::MAJOR > 3 || (ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR >= 1)
                foreign_key = association.foreign_key
              else
                foreign_key = association.primary_key_name
              end

              errors << (attribute.to_s.ends_with?("_id") ? normalized : foreign_key)
            end

            messages = [:"#{record.class.i18n_scope}.errors.messages.existence", "does not exist"]

            errors.each do |error|
              record.errors.add(error, options[:message], :message => messages)
            end
          end
        end

        def exists?(target_class, value)
          (options[:allow_new] && value.new_record?) || target_class.exists?(value)
        end
      end
    end

    module ClassMethods
      def validates_existence_of(*attr_names)
        validates_with ActiveRecord::Base::ExistenceValidator, _merge_attributes(attr_names)
      end
    end

  end
end

ActiveRecord::Base.send(:include, Perfectline::ValidatesExistence::Validator)
ActiveRecord::Base.send(:extend, Perfectline::ValidatesExistence::ClassMethods)
