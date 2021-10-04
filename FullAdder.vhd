library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
	port(A, B, Cin: in std_logic;
		Cout, Sum: out std_logic);
end FullAdder;

Architecture Structure of FullAdder is
begin 
	Sum <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (A AND Cin) OR (B AND Cin);
end Structure;
