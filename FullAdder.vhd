library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
	port(A, B, Cin: in std_logic;
		Cout, Sum: out std_logic);
end FullAdder;

Architecture Structure of FullAdder is
begin 
	Sum <= A XOR B XOR Bin;
	Cout <= (X AND Y) OR (X AND Cin) OR (Y AND Cin);
end Structure;
