library IEEE;
use IEEE.std_logic_1164.all;

entity HalfAdder is
	port(A, B: in std_logic;
		Cout, Sum: out std_logic);
end HalfAdder;

Architecture Structure of HalfAdder is
begin 
	Sum <= A XOR B;
	Cout <= (A AND B);
end Structure;