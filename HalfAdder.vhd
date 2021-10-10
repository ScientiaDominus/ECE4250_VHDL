library IEEE;
use IEEE.std_logic_1164.all;

entity HalfAdder is
	port(A, B, Cin: in std_logic;
		Cout, Sum: out std_logic);
end HalfAdder;

Architecture Structure of FullAdder is
begin 
	Sum <= A XOR B XOR Cin;
	Cout <= (A AND B);
end Structure;