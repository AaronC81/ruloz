module Ruloz
  class Connection
    attr_reader :pins

    def initialize
      @pins = []
    end

    def value
      v = value!
      if v == Z
        pull
      else
        v
      end
    end

    protected

    def pull = merge_logic(pins.map(&:own_pull).uniq)
    def value! = merge_logic(pins.map(&:own_value).uniq)

    def merge_logic(logic_values)
      logic_values.delete(Z)
      if logic_values.empty?
        Z
      elsif logic_values.length > 1
        X
      else
        logic_values.first
      end
    end
  end
end
