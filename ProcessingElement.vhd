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
    signal MandReg: integer;
    signal MierReg: integer;
    signal Multiplied: integer;
    signal AddReg: integer;
    begin
    process(clk, clr)
        begin
        if clr = '1' then
            MandReg <= 0;
            MierReg <= 0;
        elsif rising_edge(clk) then
            if load = '1' then
                MandReg <= Mcand;
                MierReg <= Mlier;
            end if;
            Mout <= MandReg;
            Multiplied <= MandReg * MierReg;
            AddReg <= addIn + Multiplied;
            Sout <= AddReg;
        end if; 
        Mout <= Mcand;
    end process;
end Structure;