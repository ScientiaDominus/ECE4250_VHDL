library IEEE;
use IEEE.std_logic_1164.all;

-- The processing element is the basic building block of the systolic array.
-- It performs multiplication and accumulation
entity PE is
    port(load, clr, clk: in std_logic;
        Mcand, Mlier: in integer;
        addIn: in integer;
        Mout: out integer;
        Sout: out integer);
end PE;

architecture Structure of PE is
begin
    process(clk, clr, Mlier)
    variable MandReg: integer := 0;     -- (needs description)
    variable MierReg: integer := 0;     -- (needs description)
    variable AddReg: integer := 0;      -- (needs description)

    begin
        if clr = '1' then -- Set all values to zero
            MandReg := 0;
            MierReg := 0;
            AddReg := 0;
            Mout <= 0;
            Sout <= 0;

        elsif rising_edge(clk) then
            MandReg := Mcand;
            MierReg := Mlier;
            Mout <= Mlier;
            AddReg := addIn + (Mcand * Mlier);
            Sout <= AddReg;
        end if;
end process;

end Structure;
