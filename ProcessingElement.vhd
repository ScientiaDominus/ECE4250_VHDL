library IEEE;
use IEEE.std_logic_1164.all;

-- The processing element is the basic building block of the systolic array.
-- It performs multiplication and accumulation
-- Processing Element:
--      inputs:
--          std_logic:
--              clr: This is passed down from the parent device to signal clearing operations
--              clk: This is a simple clock signal to regulate operations in a logical manner
--          integer:
--              Mcand: This signal is the input integer for the multiplicand from the weights of the program. This value doesn't change.
--              Mlier: This signal is the input integer for the multiplier from the activations of the program. This value updates every clock cycle.
--              addIn: This signal is the input integer for the Add in value from the sum out of the processing element above it. This changes every clock cycle.
--      outputs: 
--          integer:
--              Mout: This value is the Mlier that is passed out of the processing element to its neighbor every clock cycle.                
--              Sout: This value is the result of the multiply accumulate operation that is passed to the add in signal of the neighboring processing element (or the invalue of an accumulator)
-- Functionality:
--      The processing element is very simple and only performs the multiply and accumulate operation. It operates purely off of clock cycles and updates values on each rising edge.
--      This serves as the most basic and important element of the systolic array.  
entity PE is
    port(clr, clk: in std_logic;
        Mcand, Mlier: in integer;
        addIn: in integer;
        Mout: out integer;
        Sout: out integer);
end PE;

architecture Structure of PE is
begin
    process(clk, clr, Mlier)
    variable AddReg: integer := 0;      -- This value stores the results of the multiply and accumulate receiving the result of the multiplication and the addin value.

    begin
        if clr = '1' then -- Set all values to zero
            AddReg := 0;
            Mout <= 0;
            Sout <= 0;

        elsif rising_edge(clk) then --This multiplies and accumulates and passes the multiplier out to other functions
            Mout <= Mlier;
            AddReg := addIn + (Mcand * Mlier);
            Sout <= AddReg;
        end if;
end process;

end Structure;
