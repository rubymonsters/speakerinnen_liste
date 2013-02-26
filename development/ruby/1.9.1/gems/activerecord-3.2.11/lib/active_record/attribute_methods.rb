require 'active_support/core_ext/enumerable'
require 'active_support/deprecation'

module ActiveRecord
  # = Active Record Attribute Methods
  module AttributeMethods #:nodoc:
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      include Read
      include Write
      include BeforeTypeCast
      include Query
      include PrimaryKey
      include TimeZoneConversion
      include Dirty
      include Serialization
      include DeprecatedUnderscoreRead

      # Returns the value of the attribute identified by <tt>attr_name</tt> after it has been typecast (for example,
      # "2004-12-12" in a data column is cast to a date object, like Date.new(2004, 12, 12)).
      # (Alias for the protected read_attribute method).
      def [](attr_name)
        read_attribute(attr_name)
      end

      # Updates the attribute identified by <tt>attr_name</tt> with the specified +value+.
      # (Alias for the protected write_attribute method).
      def []=(attr_name, value)
        write_attribute(attr_name, value)
      end
    end

    module ClassMethods
      # Generates all the attribute related methods for columns in the database
      # accessors, mutators and query methods.
      def define_attribute_methods
        unless defined?(@attribute_methods_mutex)
          msg = "It looks like something (probably a gem/plugin) is overriding the " \
                "ActiveRecord::Base.inherited method. It is important that this hook executes so " \
                "that your models are set up correctly. A workaround has been added to stop this " \
                "causing an error in 3.2, but future versions will simply not work if the hook is " \
                "overridden. If you are using Kaminari, please upgrade as it is known to have had " \
                "this problem.\n\n"
          msg << "The following may help track down the problem:"

          meth = method(:inherited)
          if meth.respond_to?(:source_location)
            msg << " #{meth.source_location.inspect}"
          else
            msg << " #{meth.inspect}"
          end
          msg << "\n\n"

          ActiveSupport::Deprecation.warn(msg)

          @attribute_methods_mutex = Mutex.new
        end

        # Use a mutex; we don't want two thread simaltaneously trying to define
        # attribute methods.
        @attribute_methods_mutex.synchronize do
          return if attribute_methods_generated?
          superclass.define_attribute_methods unless self == base_class
          super(column_names)
          column_names.each { |name| define_external_attribute_method(name) }
          @attribute_methods_generated = true
        end
      end

      def attribute_methods_generated?
        @attribute_methods_generated ||= false
      end

      # We will define the methods as instance methods, but will call them as singleton
      # methods. This allows us to use method_defined? to check if the method exists,
      # which is fast and won't give any false positives from the ancestors (because
      # there are no ancestors).
      def generated_external_attribute_methods
        @generated_external_attribute_methods ||= Module.new { extend self }
      end

      def undefine_attribute_methods
        super
        @attribute_methods_generated = false
      end

      def instance_method_already_implemented?(method_name)
        if dangerous_attribute_method?(method_name)
          raise DangerousAttributeError, "#{method_name} is defined by ActiveRecord"
        end

        if superclass == Base
          super
        else
          # If B < A and A defines its own attribute method, then we don't want to overwrite that.
          defined = method_defined_within?(method_name, superclass, superclass.generated_attribute_methods)
          defined && !ActiveRecord::Base.method_defined?(method_name) || super
        end
      end

      # A method name is 'dangerous' if it is already defined by Active Record, but
      # not by any ancestors. (So 'puts' is not dangerous but 'save' is.)
      def dangerous_attribute_method?(name)
        method_defined_within?(name, Base)
      end

      def method_defined_within?(name, klass, sup = klass.superclass)
        if klass.method_defined?(name) || klass.private_method_defined?(name)
          if sup.method_defined?(name) || sup.private_method_defined?(name)
            klass.instance_method(name).owner != sup.instance_method(name).owner
          else
            true
          end
        else
          false
        end
      end

      def attribute_method?(attribute)
        super || (table_exists? && column_names.include?(attribute.to_s.sub(/=$/, '')))
      end

      # Returns an array of column names as strings if it's not
      # an abstract class and table exists.
      # Otherwise it returns an empty array.
      def attribute_names
        @attribute_names ||= if !abstract_class? && table_exists?
            column_names
          else
            []
          end
      end
    end

    # If we haven't generated any methods yet, generate them, then
    # see if we've created the method we're looking for.
    def method_missing(method, *args, &block)
      unless self.class.attribute_methods_generated?
        self.class.define_attribute_methods

        if respond_to_without_attributes?(method)
          send(method, *args, &block)
        else
          super
        end
      else
        super
      end
    end

    def attribute_missing(match, *args, &block)
      if self.class.columns_hash[match.attr_name]
        ActiveSupport::Deprecation.warn(
          "The method `#{match.method_name}', matching the attribute `#{match.attr_name}' has " \
          "dispatched through method_missing. This shouldn't happen, because `#{match.attr_name}' " \
          "is a column of the table. If this error has happened through normal usage of Active " \
          "Record (rather than through your own code or external libraries), please report it as " \
          "a bug."
        )
      end

      super
    end

    def respond_to?(name, include_private = false)
      self.class.define_attribute_methods unless self.class.attribute_methods_generated?
      super
    end

    # Returns true if the given attribute is in the attributes hash
    def has_attribute?(attr_name)
      @attributes.has_key?(attr_name.to_s)
    end

    # Returns an array of names for the attributes available on this object.
    def attribute_names
      @attributes.keys
    end

    # Returns a hash of all the attributes with their names as keys and the values of the attributes as values.
    def attributes
      attrs = {}
      attribute_names.each { |name| attrs[name] = read_attribute(name) }
      attrs
    end

    # Returns an <tt>#inspect</tt>-like string for the value of the
    # attribute +attr_name+. String attributes are truncated upto 50
    # characters, and Date and Time attributes are returned in the
    # <tt>:db</tt> format. Other attributes return the value of
    # <tt>#inspect</tt> without modification.
    #
    #   person = Person.create!(:name => "David Heinemeier Hansson " * 3)
    #
    #   person.attribute_for_inspect(:name)
    #   # => '"David Heinemeier Hansson David Heinemeier Hansson D..."'
    #
    #   person.attribute_for_inspect(:created_at)
    #   # => '"2009-01-12 04:48:57"'
    def attribute_for_inspect(attr_name)
      value = read_attribute(attr_name)

      if value.is_a?(String) && value.length > 50
        "#{value[0..50]}...".inspect
      elsif value.is_a?(Date) || value.is_a?(Time)
        %("#{value.to_s(:db)}")
      else
        value.inspect
      end
    end

    # Returns true if the specified +attribute+ has been set by the user or by a database load and is neither
    # nil nor empty? (the latter only applies to objects that respond to empty?, most notably Strings).
    def attribute_present?(attribute)
      value = read_attribute(attribute)
      !value.nil? && !(value.respond_to?(:empty?) && value.empty?)
    end

    # Returns the column object for the named attribute.
    def column_for_attribute(name)
      self.class.columns_hash[name.to_s]
    end

    protected

    def clone_attributes(reader_method = :read_attribute, attributes = {})
      attribute_names.each do |name|
        attributes[name] = clone_attribute_value(reader_method, name)
      end
      attributes
    end

    def clone_attribute_value(reader_method, attribute_name)
      value = send(reader_method, attribute_name)
      value.duplicable? ? value.clone : value
    rescue TypeError, NoMethodError
      value
    end

    # Returns a copy of the attributes hash where all the values have been safely quoted for use in
    # an Arel insert/update method.
    def arel_attributes_values(include_primary_key = true, include_readonly_attributes = true, attribute_names = @attributes.keys)
      attrs      = {}
      klass      = self.class
      arel_table = klass.arel_table

      attribute_names.each do |name|
        if (column = column_for_attribute(name)) && (include_primary_key || !column.primary)

          if include_readonly_attributes || !self.class.readonly_attributes.include?(name)

            value = if klass.serialized_attributes.include?(name)
                      @attributes[name].serialized_value
                    else
                      # FIXME: we need @attributes to be used consistently.
                      # If the values stored in @attributes were already type
                      # casted, this code could be simplified
                      read_attribute(name)
                    end

            attrs[arel_table[name]] = value
          end
        end
      end

      attrs
    end

    def attribute_method?(attr_name)
      attr_name == 'id' || (defined?(@attributes) && @attributes.include?(attr_name))
    end
  end
end
