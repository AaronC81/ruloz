require_relative 'lib/ruloz'

include Ruloz

class Clock < Component
  has_pins :out

  def step
    loop do
      out.value = H
      suspend_sleep parameters[:period] / 2
      out.value = L
      suspend_sleep parameters[:period] / 2
    end
  end
end

class AndGate < Component
  has_pins :a, :b, :out

  def step
    loop do
      suspend_trigger
      out.value = a.value & b.value
    end
  end
end

class Display < Component
  has_pins :d

  def step
    loop do
      suspend_trigger
      puts "Display trigger! New value: #{d.value}"
    end
  end
end

clock1 = Clock.new "clock1", period: 1000
clock2 = Clock.new "clock2", period: 350
and_gate = AndGate.new "and"
display = Display.new "disp"

clock1.out.connect(and_gate.a)
clock2.out.connect(and_gate.b)
and_gate.out.connect(display.d)

sys = System.new
sys.components << clock1
sys.components << clock2
sys.components << and_gate
sys.components << display

vcd = VcdGenerator.new(sys, File.open("out.vcd", "w"))
vcd.generate_header

until sys.time > 2000
  sys.tick
  vcd.generate_state
end
