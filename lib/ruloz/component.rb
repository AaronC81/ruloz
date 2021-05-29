require 'fiber'

module Ruloz
  class Component
    attr_reader :sleep_time_remaining, :pins, :name, :parameters
  
    def initialize(name, **parameters)
      @name = name
      @parameters = parameters
  
      @pins = []
      @sleep_time_remaining = 0
      @waiting_for_trigger = false
    end
  
    def suspended? = sleeping? || waiting_for_trigger?
  
    def suspend_sleep(time)
      @sleep_time_remaining = time
      Fiber.yield
    end
    def sleeping? = sleep_time_remaining > 0
  
    def waiting_for_trigger? = @waiting_for_trigger
    def suspend_trigger
      @waiting_for_trigger = true
      Fiber.yield
    end
    def trigger = @waiting_for_trigger = false
  
    def step; end
  
    def pass_time(time)
      return unless sleeping?
      @sleep_time_remaining -= time
    end
  
    protected
  
    # Convenience method for creating new components, which defines a constructor
    # to set up the "pins" array, and accessors for every pin
    def self.has_pins(*pins_to_define)
      define_method :initialize do |name, **parameters|
        super(name, **parameters)
        pins_to_define.each do |pin_name|
          pins << Pin.new(self, pin_name.to_s)
        end
      end
  
      pins_to_define.each.with_index do |pin_name, i|
        define_method pin_name.to_sym do
          pins[i]
        end
      end
    end
  end
end  