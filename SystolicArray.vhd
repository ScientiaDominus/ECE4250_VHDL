library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package array_type is
    type input_array is array(integer range <>) of integer;
    type input_mtx is array(integer range <>, integer range <>) of integer;
    type output_mtx is array(integer range <>, integer range <>) of integer;
    type ADDS is array (integer range <>, integer range <>) of integer;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.array_type.all;

entity SystolicArray is
    generic(N: integer range 0 to 255 := 4);
    port(
        load, clr, clk, Calc_Start: in std_logic;
        A: in input_mtx(0 to N-1,0 to N-1);
        B: in input_mtx(0 to N-1,0 to N-1)
            );
end SystolicArray;

architecture Structure of SystolicArray is 
component PE is
    port(load, clr, clk: in std_logic;
    Mcand, Mlier: in integer;
    addIn: in integer;
    Mout: out integer;
    Sout: out integer);
end component;

component accumulator is 
    generic(index: integer range 0 to 255;
            N: integer range 0 to 255);
    port(
        load, clr, clk, CalcDone, Calc_Start: in std_logic;
        InValue: in integer;
        OutValue: out integer
    );
end component;

signal addsig: ADDS(0 to N-1, 0 to N-1) := (others => (others => 0)); --Figure out how to get the inititialization for these values down. 
signal mliers: ADDS(0 to N-1, 0 to N-1) := (others => (others => 0));
signal B_row: input_array(0 to N-1) := (others => 0);
signal CalcDone: std_logic;
begin 
    --addsig <= (others => (others => 0));
    --mliers <= (others => (others => 0));
    --ProcElement: for i in 0 to N generate
    --    ProcEl: for j in 0 to N generate

    --        PER1_i: PE port map(load, clr, clk, A(i), B(j), Sout(i-1)(j), Mlier(i)(j+1) , addIn(i+1)(j)); --Figure out how to get this generate statement to work. Maybe have to hard code a couple of them.
        
    --        end generate;  
    --end generate;
    --Need to work on getting the generate statements to work sometime soon. Generic would come in handy for this. 
    --init_loop1: for i in 0 to 3 generate
    --    init_loop2: for j in 0 to 3 generate
    --        addSig(i,j) <= 0;
    --       mliers(i,j) <= 0;
    --    end generate; 
    --end generate;
    process(clk)
    variable in_cnt: integer := 0;
    variable Cycle_Count: integer range 0 to (3*N - 1) := 0;
    --variable run_count: integer := 0;
    begin
        --if(run_count = 0) then
        --for i in 0 to 3 loop
        --        for j in 0 to 3 loop
        --            addSig(i,j) <= 0;
        --            mliers(i,j) <= 0;
        --        end loop; 
        --end loop;
        --    run_count := run_count + 1; 
        --elsif(rising_edge(clk)) then 
        if(rising_edge(clk)) then
            if(Calc_Start = '1' and in_cnt /= N and clr = '0') then
                for i in 0 to N-1 loop
                    B_row(i) <= B(i, in_cnt);
                end loop;
                in_cnt := in_cnt + 1;
            elsif (Calc_Start = '1' and in_cnt >= N and clr = '0') then
                for i in 0 to N-1 loop
                    B_row(i) <= 0;
                end loop;
            end if;
            if(Cycle_Count = (3*N - 1)) then 
                    CalcDone <= '1';
            elsif (clr = '0') then
                    CalcDone <= '0';
                    Cycle_Count := Cycle_Count + 1;
            end if;
            --run_count := 1;
        end if;
    end process;
    
    --PEXX: PE port map (load, clr, clk, Mcand , Multiplier , Add IN     , Multiplyout, Sum out    );
    PE00: PE port map (load, clr, clk, A(0,0), B_row(0), 0, mliers(0,0), addsig(0,0));
    PE01: PE port map (load, clr, clk, A(0,1), mliers(0,0), 0, mliers(0,1), addsig(0,1));
    PE02: PE port map (load, clr, clk, A(0,2), mliers(0,1), 0, mliers(0,2), addsig(0,2));
    PE03: PE port map (load, clr, clk, A(0,3), mliers(0,2), 0, mliers(0,3), addsig(0,3));

    PE10: PE port map (load, clr, clk, A(1,0), B_row(1), addsig(0,0), mliers(1,0), addsig(1,0));
    PE11: PE port map (load, clr, clk, A(1,1), mliers(1,0), addsig(0,1), mliers(1,1), addsig(1,1));
    PE12: PE port map (load, clr, clk, A(1,2), mliers(1,1), addsig(0,2), mliers(1,2), addsig(1,2));
    PE13: PE port map (load, clr, clk, A(1,3), mliers(1,2), addsig(0,3), mliers(1,3), addsig(1,3));

    PE20: PE port map (load, clr, clk, A(2,0), B_row(2), addsig(1,0), mliers(2,0), addsig(2,0));
    PE21: PE port map (load, clr, clk, A(2,1), mliers(2,0), addsig(1,1), mliers(2,1), addsig(2,1));
    PE22: PE port map (load, clr, clk, A(2,2), mliers(2,1), addsig(1,2), mliers(2,2), addsig(2,2));
    PE23: PE port map (load, clr, clk, A(2,3), mliers(2,2), addsig(1,2), mliers(2,3), addsig(2,3));

    PE30: PE port map (load, clr, clk, A(3,0), B_row(3), addsig(2,0), mliers(3,0), addsig(3,0));
    PE31: PE port map (load, clr, clk, A(3,1), mliers(3,0), addsig(2,1), mliers(3,1), addsig(3,1));
    PE32: PE port map (load, clr, clk, A(3,2), mliers(3,1), addsig(2,2), mliers(3,2), addsig(3,2));
    PE33: PE port map (load, clr, clk, A(3,3), mliers(3,2), addsig(2,3), mliers(3,3), addsig(3,3));

    --Accumulators for Matrix Storage. 
    AC0: accumulator generic map(0, 4) port map (load, clr, clk, CalcDone, Calc_Start, addsig(3,0), open);
    AC1: accumulator generic map(1, 4) port map (load, clr, clk, CalcDone, Calc_Start, addsig(3,1), open);
    AC2: accumulator generic map(2, 4) port map (load, clr, clk, CalcDone, Calc_Start, addsig(3,2), open);
    AC3: accumulator generic map(3, 4) port map (load, clr, clk, CalcDone, Calc_Start, addsig(3,3), open);

end Structure;