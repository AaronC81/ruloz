module Ruloz
  class System
    attr_accessor :components, :time, :component_states

    def initialize
      @components = []
      @time = 0
      @component_states = {}
    end

    def all_step
      components.reject(&:suspended?).each do |component|
        if component_states[component]
          component_states[component].resume
        else
          component_states[component] = Fiber.new { component.step }
        end
      end
    end

    def tick
      wake_next if all_suspended?

      # All connections should be made before any tick occurs, so we can assume
      # they'll stay the same
      all_connections = components.flat_map(&:pins).map(&:connection).uniq
      before_connection_values = all_connections.to_h { |conn| [conn, conn.value] }

      all_step

      # Trigger whatever changed
      after_connection_values = all_connections.to_h { |conn| [conn, conn.value] }
      before_connection_values.keys.each do |conn|
        next unless before_connection_values[conn] != after_connection_values[conn]
        conn.pins.map(&:component).each do |component|
          component.trigger if component.waiting_for_trigger?
        end
      end
    end

    def all_suspended? = components.all?(&:suspended?)

    def wake_next
      sleeping_components = components.select(&:sleeping?).sort_by(&:sleep_time_remaining)
      raise 'system dead - nothing to wake' if sleeping_components.empty?
      
      time_to_pass = sleeping_components.first.sleep_time_remaining
      all_pass_time(time_to_pass)
    end

    def all_pass_time(time)
      components.each do |component|
        component.pass_time(time)
      end
      @time += time
    end
  end
end
