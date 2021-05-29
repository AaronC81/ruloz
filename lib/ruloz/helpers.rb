module Ruloz
  module Helpers
    def self.byte_to_logic_array(byte)
      raise "parameter larger than a byte" if byte > 255

      byte
        .to_s(2)
        .rjust(8, "0")
        .chars
        .map { |c| LogicValue.from(c == "1") }
    end
  end
end
