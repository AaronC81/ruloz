module Ruloz
  class Pin
    def initialize(component, name)
      @own_value = Z
      @own_pull = Z
      @name = name
      @component = component
      @connection = Connection.new()
      @connection.pins << self
    end

    def value
      connection.value
    end

    def value=(v)
      @own_value = v
    end

    def connect(pin)
      new_connection = Connection.new
      new_connection.pins.push(*connection.pins) if connection
      new_connection.pins.push(*pin.connection.pins) if pin.connection

      new_connection.pins.each do |pin|
        pin.connection = new_connection
      end
    end
    
    attr_accessor :own_value, :own_pull, :connection, :component, :name
  end
end
