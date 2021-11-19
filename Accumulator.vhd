library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity accumulator is 
    generic(index: integer range 0 to 255;
            N: integer range 0 to 255);
    port(
        load, clr, clk, CalcDone, Calc_Start: in std_logic;
        InValue: in integer;
        OutValue: out integer
    );
end accumulator;

architecture Structure of accumulator is
type int_array is array(0 to (3*N - 2)) of integer;
signal AccArray: int_array;
begin
process(clk)
    variable shift_amount: integer := 0;
    variable run_counter: integer := 0;
    --variable shift_counter: integer range 1 to N := 1;
    --variable AccArray: int_array;
    begin
    if (run_counter = 0) then
        for i in (3*N -2) downto 0 loop
            AccArray(i) <= 0;
        end loop; 
        run_counter := run_counter + 1;
    elsif clk'event and clk = '1' then 
        shift_amount := (N+1 -((N+1) - index)); 

        if(CalcDone = '1') then 
            for j in 0 to shift_amount loop
                if (shift_amount /= 0) then
                for i in (3*N - 2) downto 0 loop
                    if(i = 0) then 
                        AccArray(i) <= 0;
                    else 
                        AccArray(i) <= AccArray(i - 1);
                    end if;
                end loop; -- shiftloop
                end if;
            end loop; --external shift loop
        elsif(Calc_Start = '1' and CalcDone = '0') then
            for i in (3*N - 2) downto 0 loop
                if(i = 0) then
                    AccArray(i) <= InValue;
                else 
                    AccArray(i) <= AccArray(i - 1);
                end if;
            end loop; -- clocked loop for calculations
        end if;
        OutValue <= AccArray((3*N-2));
        run_counter := 1;
    end if;
end process;
end Structure;