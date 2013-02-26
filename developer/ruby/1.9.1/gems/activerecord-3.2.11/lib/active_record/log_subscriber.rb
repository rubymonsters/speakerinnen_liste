module ActiveRecord
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.runtime=(value)
      Thread.current["active_record_sql_runtime"] = value
    end

    def self.runtime
      Thread.current["active_record_sql_runtime"] ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end

    def initialize
      super
      @odd_or_even = false
    end

    def sql(event)
      self.class.runtime += event.duration
      return unless logger.debug?

      payload = event.payload

      return if 'SCHEMA' == payload[:name]

      name  = '%s (%.1fms)' % [payload[:name], event.duration]
      sql   = payload[:sql].squeeze(' ')
      binds = nil

      unless (payload[:binds] || []).empty?
        binds = "  " + payload[:binds].map { |col,v|
          [col.name, v]
        }.inspect
      end

      if odd?
        name = color(name, CYAN, true)
        sql  = color(sql, nil, true)
      else
        name = color(name, MAGENTA, true)
      end

      debug "  #{name}  #{sql}#{binds}"
    end

    def identity(event)
      return unless logger.debug?

      name = color(event.payload[:name], odd? ? CYAN : MAGENTA, true)
      line = odd? ? color(event.payload[:line], nil, true) : event.payload[:line]

      debug "  #{name}  #{line}"
    end

    def odd?
      @odd_or_even = !@odd_or_even
    end

    def logger
      ActiveRecord::Base.logger
    end
  end
end

ActiveRecord::LogSubscriber.attach_to :active_record
