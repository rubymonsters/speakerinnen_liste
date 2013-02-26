require 'active_support/concern'

module ActiveRecord
  module Scoping
    module Default
      extend ActiveSupport::Concern

      included do
        # Stores the default scope for the class
        class_attribute :default_scopes, :instance_writer => false
        self.default_scopes = []
      end

      module ClassMethods
        # Returns a scope for the model without the default_scope.
        #
        #   class Post < ActiveRecord::Base
        #     def self.default_scope
        #       where :published => true
        #     end
        #   end
        #
        #   Post.all          # Fires "SELECT * FROM posts WHERE published = true"
        #   Post.unscoped.all # Fires "SELECT * FROM posts"
        #
        # This method also accepts a block. All queries inside the block will
        # not use the default_scope:
        #
        #   Post.unscoped {
        #     Post.limit(10) # Fires "SELECT * FROM posts LIMIT 10"
        #   }
        #
        # It is recommended to use the block form of unscoped because chaining
        # unscoped with <tt>scope</tt> does not work.  Assuming that
        # <tt>published</tt> is a <tt>scope</tt>, the following two statements
        # are equal: the default_scope is applied on both.
        #
        #   Post.unscoped.published
        #   Post.published
        def unscoped #:nodoc:
          block_given? ? relation.scoping { yield } : relation
        end

        def before_remove_const #:nodoc:
          self.current_scope = nil
        end

        protected

        # Use this macro in your model to set a default scope for all operations on
        # the model.
        #
        #   class Article < ActiveRecord::Base
        #     default_scope where(:published => true)
        #   end
        #
        #   Article.all # => SELECT * FROM articles WHERE published = true
        #
        # The <tt>default_scope</tt> is also applied while creating/building a record. It is not
        # applied while updating a record.
        #
        #   Article.new.published    # => true
        #   Article.create.published # => true
        #
        # You can also use <tt>default_scope</tt> with a block, in order to have it lazily evaluated:
        #
        #   class Article < ActiveRecord::Base
        #     default_scope { where(:published_at => Time.now - 1.week) }
        #   end
        #
        # (You can also pass any object which responds to <tt>call</tt> to the <tt>default_scope</tt>
        # macro, and it will be called when building the default scope.)
        #
        # If you use multiple <tt>default_scope</tt> declarations in your model then they will
        # be merged together:
        #
        #   class Article < ActiveRecord::Base
        #     default_scope where(:published => true)
        #     default_scope where(:rating => 'G')
        #   end
        #
        #   Article.all # => SELECT * FROM articles WHERE published = true AND rating = 'G'
        #
        # This is also the case with inheritance and module includes where the parent or module
        # defines a <tt>default_scope</tt> and the child or including class defines a second one.
        #
        # If you need to do more complex things with a default scope, you can alternatively
        # define it as a class method:
        #
        #   class Article < ActiveRecord::Base
        #     def self.default_scope
        #       # Should return a scope, you can call 'super' here etc.
        #     end
        #   end
        def default_scope(scope = {})
          scope = Proc.new if block_given?
          self.default_scopes = default_scopes + [scope]
        end

        def build_default_scope #:nodoc:
          if method(:default_scope).owner != ActiveRecord::Scoping::Default::ClassMethods
            evaluate_default_scope { default_scope }
          elsif default_scopes.any?
            evaluate_default_scope do
              default_scopes.inject(relation) do |default_scope, scope|
                if scope.is_a?(Hash)
                  default_scope.apply_finder_options(scope)
                elsif !scope.is_a?(Relation) && scope.respond_to?(:call)
                  default_scope.merge(scope.call)
                else
                  default_scope.merge(scope)
                end
              end
            end
          end
        end

        def ignore_default_scope? #:nodoc:
          Thread.current["#{self}_ignore_default_scope"]
        end

        def ignore_default_scope=(ignore) #:nodoc:
          Thread.current["#{self}_ignore_default_scope"] = ignore
        end

        # The ignore_default_scope flag is used to prevent an infinite recursion situation where
        # a default scope references a scope which has a default scope which references a scope...
        def evaluate_default_scope
          return if ignore_default_scope?

          begin
            self.ignore_default_scope = true
            yield
          ensure
            self.ignore_default_scope = false
          end
        end

      end
    end
  end
end
