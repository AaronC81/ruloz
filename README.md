# Ruloz

This is a reimplementation of my [Hiloz](https://github.com/AaronC81/hiloz)
project as a Ruby framework.

I'd originally written Hiloz as a language and VM due to the timing system
requiring components to be suspended mid-script. However, I was reminded of
Ruby's [Fiber](https://ruby-doc.org/core-2.5.0/Fiber.html) system which makes
continuations very elegant, and it turns out this works really well as a
substitute!

The example on the Hiloz README can be written in Ruloz like:

```ruby
require 'ruloz'
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

clk1 = Clock.new "clk1", period: 100
clk2 = Clock.new "clk2", period: 70
and_gate = AndGate.new "and"

clk1.out.connect(and_gate.a)
clk2.out.connect(and_gate.b)

sys = System.new
sys.components << clk1
sys.components << clk2
sys.components << and_gate

vcd = VcdGenerator.new(sys, File.open("out.vcd", "w"))
vcd.generate_header

until sys.time > 2000
  sys.tick
  vcd.generate_state
end
```
