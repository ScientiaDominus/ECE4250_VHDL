library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.array_type.all;

entity top is 
    generic(N: integer range 0 to 255);
    port(
        Mem_Check, clk: in std_logic;
        activations, weights: in input_mtx(0 to (N-1), 0 to (N-1));
        result: out input_mtx(0 to (N-1), 0 to (N-1))
    );
end top;

architecture Structure of top is 
--Systolic Array Component
component SystolicArray is
    generic(N: integer range 0 to 255);
    port(
        load, clr, clk, Calc_Start: in std_logic;
        A: in input_mtx(0 to N-1,0 to N-1);
        B: in input_mtx(0 to N-1,0 to N-1);
        C: out input_mtx(0 to N-1,0 to N-1);
        StoreDone: out std_logic;
        Calc_Done: out std_logic
            );
end component;
--FSM component
component StateMachine is 
	port(MemCheck, CalcDone, StoreDone, CLK: in std_logic;
		Load_Mem, Calc_Start, Store_Mem, clear_mem: out std_logic);
end component;
--Processing Element Component, This is not used in this file but is included for demonstration purposes.
component PE is
    port(load, clr, clk: in std_logic;
        Mcand, Mlier: in integer;
        addIn: in integer;
        Mout: out integer;
        Sout: out integer);
end component;
--Accumulator component, this is not used in this file but is included for demonstration purposes. 
component accumulator is 
    generic(index: integer range 0 to 255;
            N: integer range 0 to 255);
    port(
        load, clr, clk, CalcDone, Calc_Start: in std_logic;
        InValue: in integer;
        OutValue: out integer;
        StoreDone: out std_logic
    );
end component;
signal Calc_Done, 
       Store_Done,
       LoadMem, 
       CalcStart,
       StoreMem,
       ClearMem: std_logic;
begin
    process(clk)
    begin
        if clk'event and clk = '1' then
            
        end if;
    end process;

    SC0: StateMachine port map (Mem_Check, Calc_Done, Store_Done, clk, LoadMem, CalcStart, StoreMem, ClearMem);
    SA0: SystolicArray generic map(N) port map (LoadMem, ClearMem, clk, CalcStart, weights, activations, result, Store_Done, Calc_Done);
end Structure;