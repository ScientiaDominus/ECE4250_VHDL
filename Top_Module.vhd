library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.array_type.all;

-- The top module ties all of the different components together. It takes in the input matricies and ouputs the result
-- It also has a few control signals to indicate when certain actions are complete
entity top is
    generic(N: integer range 0 to 256);
    port(Mem_Check, clk: in std_logic;
        activations, weights: in mtx(0 to (N-1), 0 to (N-1));
        result: out mtx(0 to (N-1), 0 to (N-1));
	    StoreD: out std_logic);
end top;

architecture Structure of top is
--Systolic Array Component
component SystolicArray is
    generic(N: integer range 0 to 256);
    port(
        clr, clk, Calc_Start: in std_logic;
        weights: in mtx(0 to N-1,0 to N-1);
        activations: in mtx(0 to N-1,0 to N-1);
        result: out mtx(0 to (N-1), 0 to (N-1));
        StoreDone: out std_logic;
        Calc_Done: out std_logic
            );
end component;

--FSM component
component StateMachine is
	port(MemCheck, CalcDone, StoreDone, CLK: in std_logic;
		Calc_Start, Store_Mem, clear_mem: out std_logic);
end component;

--Processing Element Component, This is not used in this file but is included for demonstration purposes.
component PE is
    port(clr, clk: in std_logic;
        Mcand, Mlier: in integer;
        addIn: in integer;
        Mout: out integer;
        Sout: out integer);
end component;

--Accumulator component, this is not used in this file but is included for demonstration purposes.
component accumulator is
    generic(index: integer range 0 to 256;
            N: integer range 0 to 256);
    port(clr, clk, CalcDone, Calc_Start: in std_logic;
        InValue: in integer;
        OutValue: out integer;
        StoreDone: out std_logic);
end component;

-- Required signals for proper control of file io and systolic array
signal Calc_Done,               -- Indicates when the calculation is finished
       Store_Done,              -- Indicates when the result has been put in the result matrix
       CalcStart,               -- Start the calculation
       StoreMem,                -- Store result
       ClearMem: std_logic;     -- Clear out values from the PE's
begin
    StoreD <= Store_Done;

    -- ---------- Probably not necessary (?) ----
    process(clk)
    begin
        if clk'event and clk = '1' then
        end if;
    end process;
    ---------------------------------------------

    SC0: StateMachine port map (Mem_Check, Calc_Done, Store_Done, clk, CalcStart, StoreMem, ClearMem);
    SA0: SystolicArray generic map(N) port map (ClearMem, clk, CalcStart, weights, activations, result, Store_Done, Calc_Done);
end Structure;
