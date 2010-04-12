module Perfectline
  module ValidatesExistence

    def validates_existence_of(*attr_names)
      configuration = {:message => "does not exist", :on => :save}
      configuration.update(attr_names.extract_options!.symbolize_keys)

      send(validation_method(configuration[:on] || :save), configuration) do |record|

        attr_names.each do |attr|
          association = reflect_on_association(attr.to_s.sub(/_id$/, '').to_sym)

          if association.nil? || association.macro != :belongs_to
            raise ArgumentError, "Can not validate existence on #{attribute}, not a belongs_to association."
          end

          value = record.__send__(association.primary_key_name)
          next if value.nil? && configuration[:allow_nil]

          if association.options.has_key?(:foreign_type)
            foreign_type = record.__send__(association.options[:foreign_type])

            if not foreign_type.blank?
              association_class = foreign_type.constantize
            else
              record.errors.add(attr, :existence, :default => configuration[:message]) and next
            end
          else
            association_class = association.klass
          end

          unless association_class.exists?(value)
            record.errors.add(attr, :existence, :default => configuration[:message])
          end
        end
      end
    end

  end
end
