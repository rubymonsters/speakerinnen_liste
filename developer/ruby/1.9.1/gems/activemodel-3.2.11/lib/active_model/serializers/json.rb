require 'active_support/json'
require 'active_support/core_ext/class/attribute'

module ActiveModel
  module Serializers
    # == Active Model JSON Serializer
    module JSON
      extend ActiveSupport::Concern
      include ActiveModel::Serialization

      included do
        extend ActiveModel::Naming

        class_attribute :include_root_in_json
        self.include_root_in_json = true
      end

      # Returns a hash representing the model. Some configuration can be
      # passed through +options+.
      #
      # The option <tt>include_root_in_json</tt> controls the top-level behavior
      # of +as_json+. If true (the default) +as_json+ will emit a single root
      # node named after the object's type. For example:
      #
      #   user = User.find(1)
      #   user.as_json
      #   # => { "user": {"id": 1, "name": "Konata Izumi", "age": 16,
      #                   "created_at": "2006/08/01", "awesome": true} }
      #
      #   ActiveRecord::Base.include_root_in_json = false
      #   user.as_json
      #   # => {"id": 1, "name": "Konata Izumi", "age": 16,
      #         "created_at": "2006/08/01", "awesome": true}
      #
      # This behavior can also be achieved by setting the <tt>:root</tt> option to +false+ as in:
      #
      #   user = User.find(1)
      #   user.as_json(root: false)
      #   # =>  {"id": 1, "name": "Konata Izumi", "age": 16,
      #          "created_at": "2006/08/01", "awesome": true}
      #
      # The remainder of the examples in this section assume include_root_in_json is set to
      # <tt>false</tt>.
      #
      # Without any +options+, the returned Hash will include all the model's
      # attributes. For example:
      #
      #   user = User.find(1)
      #   user.as_json
      #   # => {"id": 1, "name": "Konata Izumi", "age": 16,
      #         "created_at": "2006/08/01", "awesome": true}
      #
      # The <tt>:only</tt> and <tt>:except</tt> options can be used to limit the attributes
      # included, and work similar to the +attributes+ method. For example:
      #
      #   user.as_json(:only => [ :id, :name ])
      #   # => {"id": 1, "name": "Konata Izumi"}
      #
      #   user.as_json(:except => [ :id, :created_at, :age ])
      #   # => {"name": "Konata Izumi", "awesome": true}
      #
      # To include the result of some method calls on the model use <tt>:methods</tt>:
      #
      #   user.as_json(:methods => :permalink)
      #   # => {"id": 1, "name": "Konata Izumi", "age": 16,
      #         "created_at": "2006/08/01", "awesome": true,
      #         "permalink": "1-konata-izumi"}
      #
      # To include associations use <tt>:include</tt>:
      #
      #   user.as_json(:include => :posts)
      #   # => {"id": 1, "name": "Konata Izumi", "age": 16,
      #         "created_at": "2006/08/01", "awesome": true,
      #         "posts": [{"id": 1, "author_id": 1, "title": "Welcome to the weblog"},
      #                   {"id": 2, author_id: 1, "title": "So I was thinking"}]}
      #
      # Second level and higher order associations work as well:
      #
      #   user.as_json(:include => { :posts => {
      #                                  :include => { :comments => {
      #                                                :only => :body } },
      #                                  :only => :title } })
      #   # => {"id": 1, "name": "Konata Izumi", "age": 16,
      #         "created_at": "2006/08/01", "awesome": true,
      #         "posts": [{"comments": [{"body": "1st post!"}, {"body": "Second!"}],
      #                    "title": "Welcome to the weblog"},
      #                   {"comments": [{"body": "Don't think too hard"}],
      #                    "title": "So I was thinking"}]}
      def as_json(options = nil)
        root = include_root_in_json
        root = options[:root] if options.try(:key?, :root)
        if root
          root = self.class.model_name.element if root == true
          { root => serializable_hash(options) }
        else
          serializable_hash(options)
        end
      end

      def from_json(json, include_root=include_root_in_json)
        hash = ActiveSupport::JSON.decode(json)
        hash = hash.values.first if include_root
        self.attributes = hash
        self
      end
    end
  end
end
