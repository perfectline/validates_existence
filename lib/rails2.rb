module Perfectline
  module ValidatesExistence

    module Rails2
      def validates_existence_of(*attribute_names)
        options = attribute_names.extract_options!.symbolize_keys
        options[:message] ||= :existence
        options[:both]    = true unless options.key?(:both)

        validates_each(attribute_names, options) do |record, attribute, value|
          normalized  = attribute.to_s.sub(/_id$/, "").to_sym
          association = record.class.reflect_on_association(normalized)

          if association.nil? or !association.belongs_to?
            raise ArgumentError, "Cannot validate existence on #{normalized}, not a :belongs_to association"
          end

          target_class = nil

          # dealing with polymorphic belongs_to
          if association.options.has_key?(:foreign_type)
            foreign_type = record.send(association.options.fetch(:foreign_type))
            target_class = foreign_type.constantize unless foreign_type.nil?
          else
            target_class = association.klass
          end

          if target_class.nil? or !target_class.exists?(value)
            errors = [attribute]

            # add the error on both :relation and :relation_id
            if options[:both]
              errors.push(attribute.to_s.ends_with?("_id") ? normalized : association.primary_key_name)
            end

            errors.each do |error|
              record.errors.add(error, options[:message], :default => "does not exist")
            end
          end
        end
      end
    end
  end
end

