library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package array_type is
    type input_array is array(integer range <>) of integer;
    type mtx is array(integer range <>, integer range <>) of integer;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.array_type.all;

-- Systolic array
-- Inputs:
--      std_logic:
--          clr: This signal is passed down from the state machine (SysControl) to signal the systolic array to clear all its outputs to 0. This preps the array for calculations
--          clk: This signal is just a basic clock signal, it is present in all components within this project
--          Calc_Start: This signal is passed down from SysControl to signal the systolic array to begin calculations 
--      mtx:
--          weights: This signal is a matrix of integers that takes the weights matrix read from a file in the parent device. This is directly mapped to the processing elements in the systolic array
--          activations: This signal is another matrix of integers that takes the activations matrix read from a file in the parent device. This is processed with the B_row and staggering algorithm
-- Outputs:
--      std_logic:
--          StoreDone: This signal outputs 1 when the result matrix is filled with the resultant values from the matrix calculation, otherwise it remains 0.
--          Calc_Done: This signal outputs 1 when the result matrix is finished calculating and stored in the Accumulators and before it is stored into the result matrix.
--      mtx:
--          result: This signal is an integer matrix that stores the result of the matrix multiplication and passes it back out to the parent device to be handled by those devices.
-- Functionality:
--      This device will accept two matrices, weights and activations, then compute the product of the two matrices. This is done by feeding them both into a systolic array of 
--      processing elements. Each element does a multiply and accumulate operation. The theoretical maximum number of cycles for the calculation to complete should be (3*n-1) where
--      n is the width and height of the matrix. 
entity SystolicArray is
    generic(N: integer range 0 to 256);
    port(
        clr, clk, Calc_Start: in std_logic;
        weights: in mtx(0 to N-1,0 to N-1);
        activations: in mtx(0 to N-1,0 to N-1);
        result: out mtx(0 to (N-1), 0 to (N-1));
        StoreDone: out std_logic;
        Calc_Done: out std_logic
            );
end SystolicArray;

architecture Structure of SystolicArray is
component PE is
    port(clr, clk: in std_logic;
    Mcand, Mlier: in integer;
    addIn: in integer;
    Mout: out integer;
    Sout: out integer);
end component;

component accumulator is
    generic(index: integer range 0 to 256;
            N: integer range 0 to 256);
    port(
        clr, clk, CalcDone, Calc_Start, ShiftOnce: in std_logic;
        InValue: in integer;
        OutValue: out integer;
        StoreDone: out std_logic
    );
end component;

signal addsig: mtx(0 to N-1, 0 to N-1);                        -- This set of signals connects all of the addin/sum out signals for each processing element. this can be seen as a grid of signals that the systolic array rests within
signal mliers: mtx(0 to N-1, 0 to N-1);                        -- This set of signals connects all of the Multiplier in/Multiplier out signals for each processing element. This can also be seen as a grid of signals that the systolic array rests within
signal B_row: input_array(0 to N-1) := (others => 0);           -- This is a buffer row that takes the multipliers from the staggering algorithm. This feeds the systolic array with new multipliers every clock cycle
signal SD_Array: std_logic_vector(0 to N-1) := (others => '0'); -- This is a row of std_logic values that signals the device when the storing algorithm has completed
signal out_row: input_array(0 to N-1) := (others => 0);         -- This is a buffer row like B_row that takes the outputs of all the accumulators and feeds them into the storing algorithm every clock cyle that storing is needed
signal CalcDone, AccStoreDone: std_logic;                       -- CalcDone signals the parent device when the actual calculation of the matrix is done, then AccStoreDone signals the parent device when the accumulators have shifted their values to the proper locations for storage
signal shift_Once: std_logic := '0';                            -- This signal allows the accumulators to shift one row at a time to allow for out_row to be filled properly

begin
    process(clk)
    variable store_counter: integer := 0;                       -- This variable is used to keep track of the iterations of the loop that checks that the accumulators have finished shifting their values.
    variable shiftstore: integer := 0;                          -- This variable is used to iterate through each element of the result matrix and store each out_row as the corresponding row in C (the result matrix)
    variable in_cnt: integer := 0;                              -- This variable is used to keep track of the cycles that are used to feed B_row into the systolic array
    variable Cycle_Count: integer range 0 to (3*N) := 0;        -- Cycle count counts the cycles after the calculation was started (Calc_Start went to 1)
    begin
        if(rising_edge(clk)) then
            if(in_cnt <= (2*N - 1) and clr = '0' and Calc_Start = '1') then -- This works in place of a for loop. This overarching if statement includes the algorithm for staggering the input matrix.
                    if(in_cnt <= (N - 1)) then --check if the in_cnt variable is below a certain point in the algorithm (It switches to another for loop when this occurs)
                        for j in 0 to in_cnt  loop
                            B_row(j) <= activations(j, in_cnt - j); --updated version of this line properly staggers and inserts the matrix
                        end loop;

                    elsif(in_cnt <= (2*N - 1) and in_cnt > (N-1)) then --check if the in_cnt variable has counted N cycles, here the algorithm shifts
                        for k in (N-1) downto (in_cnt-(N-1)) loop
                            B_row(k) <= activations( k, in_cnt - k); --updated version of this line properly staggers and inserts the matrix
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

                for i in 0 to (N-1) loop                        -- This for loop ensures that the accumulators have shifted all of the information from the systolic array 
                    if(SD_Array(i) = '0') then                  -- To do this the program has an array of std_logic values called SD_Array, this is short for StoreDone array.
                        AccStoreDone <= '0';                    -- Each element of SD_Array is mapped directly to the storedone output in its corresponding accumulator.
                    elsif (SD_Array(i) = '1') then              -- This for loop then checks if all of those values have gone to 1. When this occurs the loop sets the shift once
                        store_counter := store_counter +1;      -- signal to 1, This signals the accumulators to shift the values by a single value. This will
                    elsif (store_counter = (N-1)) then          -- ensure that the result matrix from multiplication is in the proper format for reading out later. 
                        AccStoreDone <= '1';                    -- This loop will only change AccStoreDone value and shift_Once when it detects that all accumulators have shifted.
                        shift_Once <= '1';
                    end if;
                end loop;

                if(AccStoreDone = '1') then                     -- Check that the accumulators have finished storing. Then shift all accumulators by one every clock cycle until  
                    shift_Once <= '1';                          -- the result matrix has been filled with the proper values. 

                    if(shiftstore <= N and shiftstore > 0) then -- Store all of the elements in the accumulators into the result matrix row by row until N cycles have passed. 
                        shift_Once <= '1';                      
                        for j in 0 to (N-1) loop
                            result(j,(shiftstore-1)) <= out_row(j);
                        end loop;

                    elsif(shiftstore >= N) then                 -- then signal all of the accumulators to stop shifting and remain empty.
                        shift_Once <= '0';
                    end if;

                    shiftstore := shiftstore + 1;
                end if;

            elsif (clr = '0' and Calc_Start = '1') then --if the total number of cycles is less than the required amount then set CalcDone to 0 and increment cycle count
                CalcDone <= '0';
                Cycle_Count := Cycle_Count + 1;
            end if;

            Calc_Done <= CalcDone;
        end if;

	if(shiftstore >= N) then -- ensure that storedone does not go to 1 until the matrix has been properly stored within the result matrix (C)
		StoreDone <= '1';
	else
		StoreDone <= '0';
	end if;

    end process;

    -- Generation of PE's based on the value of N. port map is as follows:
    -- PEXX: PE port map ( clr, clk, Mcand , Multiplier , Add IN     , Multiplyout, Sum out    );
    PE00: PE port map (clr, clk, weights(0,0), B_row(0), 0, mliers(0,0), addsig(0,0));                                  -- PE 0,0

    PEI: for i in 1 to (N-1) generate
        PE_i_0: PE port map (clr, clk, weights(0,i), B_row(i), addsig((i-1),0), mliers(i,0), addsig(i,0));              -- PE i,0
        PE_0_j: PE port map (clr, clk, weights(i,0), mliers(0,(i-1)), 0, mliers(0,i), addsig(0,i));                     -- PE 0,j

        PEJ: for j in 1 to (N-1) generate
            PE_i_j: PE port map (clr, clk, weights(j,i), mliers(i,(j-1)), addsig((i-1),j), mliers(i,j), addsig(i,j));   -- PE i,j
        end generate PEJ;
    end generate PEI;


    --Accumulators for Matrix Storage.
    AC: for x in 0 to (N-1) generate
        AC_x: accumulator generic map(x, N) port map (clr, clk, CalcDone, Calc_Start, shift_Once, addsig((N-1),x), out_row(x), SD_Array(x));
    end generate AC;

end Structure;
