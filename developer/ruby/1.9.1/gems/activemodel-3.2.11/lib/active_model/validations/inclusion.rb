require 'active_support/core_ext/range'

module ActiveModel
  # == Active Model Inclusion Validator
  module Validations
    class InclusionValidator < EachValidator
      ERROR_MESSAGE = "An object with the method #include? or a proc or lambda is required, " <<
                      "and must be supplied as the :in (or :within) option of the configuration hash"

      def check_validity!
        unless [:include?, :call].any?{ |method| delimiter.respond_to?(method) }
          raise ArgumentError, ERROR_MESSAGE
        end
      end

      def validate_each(record, attribute, value)
        exclusions = delimiter.respond_to?(:call) ? delimiter.call(record) : delimiter
        unless exclusions.send(inclusion_method(exclusions), value)
          record.errors.add(attribute, :inclusion, options.except(:in, :within).merge!(:value => value))
        end
      end

    private

      def delimiter
        @delimiter ||= options[:in] || options[:within]
      end

      # In Ruby 1.9 <tt>Range#include?</tt> on non-numeric ranges checks all possible
      # values in the range for equality, so it may be slow for large ranges. The new
      # <tt>Range#cover?</tt> uses the previous logic of comparing a value with the
      # range endpoints.
      def inclusion_method(enumerable)
        enumerable.is_a?(Range) ? :cover? : :include?
      end
    end

    module HelperMethods
      # Validates whether the value of the specified attribute is available in a
      # particular enumerable object.
      #
      #   class Person < ActiveRecord::Base
      #     validates_inclusion_of :gender, :in => %w( m f )
      #     validates_inclusion_of :age, :in => 0..99
      #     validates_inclusion_of :format, :in => %w( jpg gif png ), :message => "extension %{value} is not included in the list"
      #     validates_inclusion_of :states, :in => lambda{ |person| STATES[person.country] }
      #   end
      #
      # Configuration options:
      # * <tt>:in</tt> - An enumerable object of available items. This can be
      #   supplied as a proc or lambda which returns an enumerable. If the enumerable
      #   is a range the test is performed with <tt>Range#cover?</tt>
      #   (backported in Active Support for 1.8), otherwise with <tt>include?</tt>.
      # * <tt>:within</tt> - A synonym(or alias) for <tt>:in</tt>
      # * <tt>:message</tt> - Specifies a custom error message (default is: "is not
      #   included in the list").
      # * <tt>:allow_nil</tt> - If set to true, skips this validation if the attribute
      #   is +nil+ (default is +false+).
      # * <tt>:allow_blank</tt> - If set to true, skips this validation if the
      #   attribute is blank (default is +false+).
      # * <tt>:on</tt> - Specifies when this validation is active. Runs in all
      #   validation contexts by default (+nil+), other options are <tt>:create</tt>
      #   and <tt>:update</tt>.
      # * <tt>:if</tt> - Specifies a method, proc or string to call to determine if
      #   the validation should occur (e.g. <tt>:if => :allow_validation</tt>, or
      #   <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>). The method, proc
      #   or string should return or evaluate to a true or false value.
      # * <tt>:unless</tt> - Specifies a method, proc or string to call to determine
      #   if the validation should not occur (e.g. <tt>:unless => :skip_validation</tt>,
      #   or <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>). The method,
      #   proc or string should return or evaluate to a true or false value.
      # * <tt>:strict</tt> - Specifies whether validation should be strict.
      #   See <tt>ActiveModel::Validation#validates!</tt> for more information.
      def validates_inclusion_of(*attr_names)
        validates_with InclusionValidator, _merge_attributes(attr_names)
      end
    end
  end
end
