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
        B: in input_mtx(0 to N-1,0 to N-1);
        C: out input_mtx(0 to (N-1), 0 to (N-1));
        StoreDone: out std_logic;
        Calc_Done: out std_logic
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
        load, clr, clk, CalcDone, Calc_Start, ShiftOnce: in std_logic;
        InValue: in integer;
        OutValue: out integer;
        StoreDone: out std_logic
    );
end component;

signal addsig: ADDS(0 to N-1, 0 to N-1); --:= (others => (others => 0)); --Figure out how to get the inititialization for these values down.
signal mliers: ADDS(0 to N-1, 0 to N-1); --:= (others => (others => 0));
signal B_row: input_array(0 to N-1) := (others => 0);
signal SD_Array: std_logic_vector(0 to N-1) := (others => '0');
signal out_row: input_array(0 to N-1) := (others => 0);
signal CalcDone, AccStoreDone: std_logic; 
signal shift_Once: std_logic := '0';
begin
    process(clk)
    variable store_counter: integer := 0;
    variable shiftstore: integer := 0;
    variable in_cnt: integer := 0;
    variable Cycle_Count: integer range 0 to (3*N) := 0;
    --variable run_count: integer := 0;
    begin
        if(rising_edge(clk)) then
            if(in_cnt <= (2*N - 1) and clr = '0' and Calc_Start = '1') then -- This works in place of a for loop. This overarching if statement includes the algorithm for staggering the input matrix.
                    if(in_cnt <= (N - 1)) then --check if the in_cnt variable is below a certain point in the algorithm (It switches to another for loop when this occurs)
                        for j in 0 to in_cnt  loop
                            B_row(j) <= B(j, in_cnt - j); --updated version of this line properly staggers and inserts the matrix
                        end loop;
                    elsif(in_cnt <= (2*N - 1) and in_cnt > (N-1)) then --check if the in_cnt variable has counted N cycles, here the algorithm shifts
                        for k in (N-1) downto (in_cnt-(N-1)) loop
                            B_row(k) <= B( k, in_cnt - k); --updated version of this line properly staggers and inserts the matrix
                        end loop;
                        for h in 0 to in_cnt - N loop
                            B_row(h) <= 0; --This statement fills in the zeroes that to allow for proper calculations
                        end loop;
                    end if;
                    in_cnt := in_cnt + 1; --increment in_cnt
                    CalcDone <= '0';
            elsif (in_cnt >= (2*N - 1) and clr = '0') then --once the calculations have completed fill the remaining values with 0.
                for i in 0 to N-1 loop
                    B_row(i) <= 0;
                end loop;
                CalcDone <= '0';
            end if;
            if(Cycle_Count >= (3*N)) then --when the total number of cycles required to calculate the result have passed then switch to CalcDone
                CalcDone <= '1';
                store_counter := 0;
                for i in 0 to (N-1) loop
                    if(SD_Array(i) = '0') then 
                        AccStoreDone <= '0';
                    elsif (SD_Array(i) = '1') then
                        store_counter := store_counter +1;
                    elsif (store_counter = (N-1)) then 
                        AccStoreDone <= '1';
                        shift_Once <= '1';
                    end if;
                end loop; 
                if(AccStoreDone = '1') then
                    shift_Once <= '1';
                    if(shiftstore <= N and shiftstore > 0) then
                        shift_Once <= '1';
                    --for i in 0 to (N-1) loop
                        for j in 0 to (N-1) loop
                            C(j,(shiftstore-1)) <= out_row(j);
                            --j,(N-1) - (shiftstore-1)
                            --shiftstore-1,j
                        end loop;
                    --end loop;
                    elsif(shiftstore >= N) then
                        shift_Once <= '0';
                    end if;
                    shiftstore := shiftstore + 1;
                end if;
            elsif (clr = '0' and Calc_Start = '1') then --if the total number of cycles is less than the required amount then set CalcDone to 0 and increment cycle count
                CalcDone <= '0';
                Cycle_Count := Cycle_Count + 1;
            end if;
            --run_count := 1;
            Calc_Done <= CalcDone;
        end if;
    end process;

    --PEXX: PE port map (load, clr, clk, Mcand , Multiplier , Add IN     , Multiplyout, Sum out    );

    -- PE 0,0
    PE00: PE port map (load, clr, clk, A(0,0), B_row(0), 0, mliers(0,0), addsig(0,0));

    -- PE i,j
    PEI: for i in 1 to (N-1) generate
        PE_i_0: PE port map (load, clr, clk, A(0,i), B_row(i), addsig((i-1),0), mliers(i,0), addsig(i,0));  -- PE i,0
        PE_0_j: PE port map (load, clr, clk, A(i,0), mliers(0,(i-1)), 0, mliers(0,i), addsig(0,i));         -- PE 0,j
        
        PEJ: for j in 1 to (N-1) generate
            PE_i_j: PE port map (load, clr, clk, A(j,i), mliers(i,(j-1)), addsig((i-1),j), mliers(i,j), addsig(i,j));
        end generate PEJ;
    end generate PEI;


    --Accumulators for Matrix Storage.
    AC: for x in 0 to (N-1) generate
        AC_x: accumulator generic map(x, N) port map (load, clr, clk, CalcDone, Calc_Start, shift_Once, addsig((N-1),x), out_row(x), SD_Array(x));
    end generate AC;

end Structure;
