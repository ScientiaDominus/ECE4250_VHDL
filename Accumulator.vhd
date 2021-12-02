library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- The accumulator accumulates values over time as the result matrix is calculated
entity accumulator is
    generic(index: integer range 0 to 256;
            N: integer range 0 to 256);
    port(
        clr, clk, CalcDone, Calc_Start, ShiftOnce: in std_logic;
        InValue: in integer;
        OutValue: out integer;
        StoreDone: out std_logic
    );
end accumulator;

architecture Structure of accumulator is

type int_array is array(0 to (2*N -1)) of integer;
signal AccArray: int_array;                         -- (needs description)

begin
process(clk)
    variable run_counter: integer := 0;         -- (needs description)
    variable shift_counter: integer := 0;       -- (needs description)

    begin
    if (run_counter = 0) then
        for i in (2*N -1) downto 0 loop
            AccArray(i) <= 0;
        end loop;
        run_counter := run_counter + 1;

    elsif clk'event and clk = '1' then
        if(CalcDone = '1' and ShiftOnce /= '1') then
            if (shift_counter < index) then
                for i in (2*N -1) downto 0 loop
                    if(i = 0) then
                        AccArray(i) <= 0;
                    else
                        AccArray(i) <= AccArray(i - 1);
                    end if;
                end loop; -- shiftloop
                shift_counter := shift_counter + 1;

            elsif(shift_counter = index) then
                StoreDone <= '1';
            end if;

        elsif(Calc_Start = '1' and CalcDone = '0') then
            for i in (2*N - 1) downto 0 loop
                if(i = 0) then
                    AccArray(i) <= InValue;
                else
                    AccArray(i) <= AccArray(i - 1);
                end if;
            end loop; -- clocked loop for calculations

        elsif(shiftOnce = '1') then
            for i in (2*N - 1) downto 0 loop
                if(i = 0) then
                    AccArray(i) <= InValue;
                else
                    AccArray(i) <= AccArray(i - 1);
                end if;
            end loop;
        end if;

        OutValue <= AccArray((2*N-1));
        run_counter := 1;
    end if;
end process;
end Structure;
