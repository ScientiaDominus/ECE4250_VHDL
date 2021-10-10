library IEEE;
use IEEE.std_logic_1164.all;

entity 8bitMultiplier is
	port(Mand, Mier: in std_logic_vector(7 downto 0);
		Start: in std_logic;
		Result: out std_logic_vector(15 downto 0));
end 8bitMultiplier;

Architecture Structure of 8bitMultiplier is
	component FullAdder 
		port(X, Y, Cin: in std_logic;
			Sum, Cout: std_logic);
	end component;
	component HalfAdder
		port(X, Y: in std_logic;
			Sum, Cout: std_logic);
	end component;
	signal C1, C2, C3: std_logic_vector(7 downto 0);
	signal Sum1, Sum2, Sum3: std_logic_vector(7 downto 0);
	begin
	
end Structure;
		