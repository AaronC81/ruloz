module Ruloz
  class VcdGenerator
    attr_accessor :system, :stream

    def initialize(system, stream)
      @system = system
      @stream = stream
    end

    def pin_identifier(pin)
      "c#{pin.component.name}p#{pin.name}"
    end

    def logic_value_to_vcd(value)
      case value
      when H
        "1"
      when L
        "0"
      when Z
        "z"
      when X
        "x"
      end
    end

    def generate_header
      stream.puts("$timescale 1ms $end")
      stream.puts("$scope module simulation $end")
      system.components.each do |component|
        stream.puts("$scope module #{component.name} $end")
        component.pins.each do |pin|
          stream.puts("$var wire 1 #{pin_identifier(pin)} #{pin.name} $end")
        end
        stream.puts("$upscope $end")
      end
      stream.puts("$upscope $end")
      stream.puts("$enddefinitions $end")
    end

    def generate_state
      stream.puts("##{system.time}")
      system.components.each do |component|
        component.pins.each do |pin|
          stream.puts("#{logic_value_to_vcd(pin.value)}#{pin_identifier(pin)}")
        end
      end
    end
  end
end