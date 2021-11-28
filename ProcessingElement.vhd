library IEEE;
use IEEE.std_logic_1164.all;

entity PE is
    port(load, clr, clk: in std_logic;
        Mcand, Mlier: in integer;
        addIn: in integer;
        Mout: out integer;
        Sout: out integer);
end PE;

architecture Structure of PE is
    --signal AddReg: integer;
    begin
    process(clk, clr, Mlier)
    variable MandReg: integer := 0;
    variable MierReg: integer := 0;
    --variable Multiplied: integer := 0;
    variable AddReg: integer := 0;
    begin
        if clr = '1' then
            MandReg := 0;
            MierReg := 0;
            --Multiplied := 0;
            AddReg := 0;
            Mout <= 0;
            Sout <= 0;
        elsif rising_edge(clk) then
            MandReg := Mcand;
            MierReg := Mlier;
            Mout <= Mlier;
            --Multiplied := Mcand * Mlier;
            AddReg := addIn + (Mcand * Mlier);
            Sout <= AddReg;
        end if; 
    end process;
end Structure;