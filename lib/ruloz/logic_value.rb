module Ruloz
  class LogicValue
    module InnerValues
      H = :high
      L = :low
      Z = :high_impedance
      X = :invalid
    end

    def initialize(value)
      @value = value
    end
    
    def truthy? = high?

    def high?           = value == InnerValues::H
    def low?            = value == InnerValues::L
    def high_impedance? = value == InnerValues::Z
    def invalid?        = value == InnerValues::X

    H = LogicValue.new(InnerValues::H).freeze
    L = LogicValue.new(InnerValues::L).freeze
    Z = LogicValue.new(InnerValues::Z).freeze
    X = LogicValue.new(InnerValues::X).freeze
              
    def |(other)
      return X if invalid? || other.invalid?
      return Z if high_impedance? && other.high_impedance?
      
      if truthy? || other.truthy?
        H
      else
        L
      end
    end

    def &(other)
      return X if invalid? || other.invalid?
      return Z if high_impedance? && other.high_impedance?
      
      if truthy? && other.truthy?
        H
      else
        L
      end
    end

    def ==(other) = value == other.value

    def inspect = "#<LogicValue #{value}>"
    alias to_s inspect

    protected

    attr_reader :value
  end

  H = LogicValue::H
  L = LogicValue::L
  Z = LogicValue::Z
  X = LogicValue::X
end
