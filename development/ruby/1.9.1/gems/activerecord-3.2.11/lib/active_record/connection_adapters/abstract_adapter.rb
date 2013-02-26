require 'date'
require 'bigdecimal'
require 'bigdecimal/util'
require 'active_support/core_ext/benchmark'
require 'active_support/deprecation'
require 'active_record/connection_adapters/schema_cache'
require 'monitor'

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    extend ActiveSupport::Autoload

    autoload :Column

    autoload_under 'abstract' do
      autoload :IndexDefinition,  'active_record/connection_adapters/abstract/schema_definitions'
      autoload :ColumnDefinition, 'active_record/connection_adapters/abstract/schema_definitions'
      autoload :TableDefinition,  'active_record/connection_adapters/abstract/schema_definitions'
      autoload :Table,            'active_record/connection_adapters/abstract/schema_definitions'

      autoload :SchemaStatements
      autoload :DatabaseStatements
      autoload :DatabaseLimits
      autoload :Quoting

      autoload :ConnectionPool
      autoload :ConnectionHandler,       'active_record/connection_adapters/abstract/connection_pool'
      autoload :ConnectionManagement,    'active_record/connection_adapters/abstract/connection_pool'
      autoload :ConnectionSpecification

      autoload :QueryCache
    end

    # Active Record supports multiple database systems. AbstractAdapter and
    # related classes form the abstraction layer which makes this possible.
    # An AbstractAdapter represents a connection to a database, and provides an
    # abstract interface for database-specific functionality such as establishing
    # a connection, escaping values, building the right SQL fragments for ':offset'
    # and ':limit' options, etc.
    #
    # All the concrete database adapters follow the interface laid down in this class.
    # ActiveRecord::Base.connection returns an AbstractAdapter object, which
    # you can use.
    #
    # Most of the methods in the adapter are useful during migrations. Most
    # notably, the instance methods provided by SchemaStatement are very useful.
    class AbstractAdapter
      include Quoting, DatabaseStatements, SchemaStatements
      include DatabaseLimits
      include QueryCache
      include ActiveSupport::Callbacks
      include MonitorMixin

      define_callbacks :checkout, :checkin

      attr_accessor :visitor, :pool
      attr_reader :schema_cache, :last_use, :in_use, :logger
      alias :in_use? :in_use

      def initialize(connection, logger = nil, pool = nil) #:nodoc:
        super()

        @active              = nil
        @connection          = connection
        @in_use              = false
        @instrumenter        = ActiveSupport::Notifications.instrumenter
        @last_use            = false
        @logger              = logger
        @open_transactions   = 0
        @pool                = pool
        @query_cache         = Hash.new { |h,sql| h[sql] = {} }
        @query_cache_enabled = false
        @schema_cache        = SchemaCache.new self
        @visitor             = nil
      end

      def lease
        synchronize do
          unless in_use
            @in_use   = true
            @last_use = Time.now
          end
        end
      end

      def expire
        @in_use = false
      end

      # Returns the human-readable name of the adapter. Use mixed case - one
      # can always use downcase if needed.
      def adapter_name
        'Abstract'
      end

      # Does this adapter support migrations? Backend specific, as the
      # abstract adapter always returns +false+.
      def supports_migrations?
        false
      end

      # Can this adapter determine the primary key for tables not attached
      # to an Active Record class, such as join tables? Backend specific, as
      # the abstract adapter always returns +false+.
      def supports_primary_key?
        false
      end

      # Does this adapter support using DISTINCT within COUNT? This is +true+
      # for all adapters except sqlite.
      def supports_count_distinct?
        true
      end

      # Does this adapter support DDL rollbacks in transactions? That is, would
      # CREATE TABLE or ALTER TABLE get rolled back by a transaction? PostgreSQL,
      # SQL Server, and others support this. MySQL and others do not.
      def supports_ddl_transactions?
        false
      end

      def supports_bulk_alter?
        false
      end

      # Does this adapter support savepoints? PostgreSQL and MySQL do,
      # SQLite < 3.6.8 does not.
      def supports_savepoints?
        false
      end

      # Should primary key values be selected from their corresponding
      # sequence before the insert statement? If true, next_sequence_value
      # is called before each insert to set the record's primary key.
      # This is false for all adapters but Firebird.
      def prefetch_primary_key?(table_name = nil)
        false
      end

      # Does this adapter support index sort order?
      def supports_index_sort_order?
        false
      end

      # Does this adapter support explain? As of this writing sqlite3,
      # mysql2, and postgresql are the only ones that do.
      def supports_explain?
        false
      end

      # QUOTING ==================================================

      # Override to return the quoted table name. Defaults to column quoting.
      def quote_table_name(name)
        quote_column_name(name)
      end

      # Returns a bind substitution value given a +column+ and list of current
      # +binds+
      def substitute_at(column, index)
        Arel::Nodes::BindParam.new '?'
      end

      # REFERENTIAL INTEGRITY ====================================

      # Override to turn off referential integrity while executing <tt>&block</tt>.
      def disable_referential_integrity
        yield
      end

      # CONNECTION MANAGEMENT ====================================

      # Checks whether the connection to the database is still active. This includes
      # checking whether the database is actually capable of responding, i.e. whether
      # the connection isn't stale.
      def active?
        @active != false
      end

      # Disconnects from the database if already connected, and establishes a
      # new connection with the database.
      def reconnect!
        @active = true
      end

      # Disconnects from the database if already connected. Otherwise, this
      # method does nothing.
      def disconnect!
        @active = false
      end

      # Reset the state of this connection, directing the DBMS to clear
      # transactions and other connection-related server-side state. Usually a
      # database-dependent operation.
      #
      # The default implementation does nothing; the implementation should be
      # overridden by concrete adapters.
      def reset!
        # this should be overridden by concrete adapters
      end

      ###
      # Clear any caching the database adapter may be doing, for example
      # clearing the prepared statement cache. This is database specific.
      def clear_cache!
        # this should be overridden by concrete adapters
      end

      # Returns true if its required to reload the connection between requests for development mode.
      # This is not the case for Ruby/MySQL and it's not necessary for any adapters except SQLite.
      def requires_reloading?
        false
      end

      # Checks whether the connection to the database is still active (i.e. not stale).
      # This is done under the hood by calling <tt>active?</tt>. If the connection
      # is no longer active, then this method will reconnect to the database.
      def verify!(*ignored)
        reconnect! unless active?
      end

      # Provides access to the underlying database driver for this adapter. For
      # example, this method returns a Mysql object in case of MysqlAdapter,
      # and a PGconn object in case of PostgreSQLAdapter.
      #
      # This is useful for when you need to call a proprietary method such as
      # PostgreSQL's lo_* methods.
      def raw_connection
        @connection
      end

      attr_reader :open_transactions

      def increment_open_transactions
        @open_transactions += 1
      end

      def decrement_open_transactions
        @open_transactions -= 1
      end

      def transaction_joinable=(joinable)
        @transaction_joinable = joinable
      end

      def create_savepoint
      end

      def rollback_to_savepoint
      end

      def release_savepoint
      end

      def case_sensitive_modifier(node)
        node
      end

      def case_insensitive_comparison(table, attribute, column, value)
        table[attribute].lower.eq(table.lower(value))
      end

      def current_savepoint_name
        "active_record_#{open_transactions}"
      end

      # Check the connection back in to the connection pool
      def close
        pool.checkin self
      end

      protected

        def log(sql, name = "SQL", binds = [])
          @instrumenter.instrument(
            "sql.active_record",
            :sql           => sql,
            :name          => name,
            :connection_id => object_id,
            :binds         => binds) { yield }
        rescue Exception => e
          message = "#{e.class.name}: #{e.message}: #{sql}"
          @logger.debug message if @logger
          exception = translate_exception(e, message)
          exception.set_backtrace e.backtrace
          raise exception
        end

        def translate_exception(e, message)
          # override in derived class
          ActiveRecord::StatementInvalid.new(message)
        end

    end
  end
end
