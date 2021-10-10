library IEEE;
use IEEE.std_logic_1164.all;

entity adder8 is
	port(X, Y: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		Sum: out std_logic_vector(7 downto 0);
		Cout: out std_logic);
end adder8;

Architecture Structure of adder8 is
	component FullAdder 
		port(A, B, Cin: in std_logic;
			Sum, Cout: out std_logic);
	end component;
	--This is an edited version of the 24 bit adder. This method can function with any length of adder but we have opted to use the same structure for different
	--adders to simplify the process and save a little bit of time in the future. We really only need two types of adders for the project so this should be 
	--enough.
	signal C: std_logic_vector(9 downto 0);
	begin 
		C(0) <= Cin;
		Cout <= C(9);
		FA: for i in 0 to 7 generate
			FA_i: FullAdder port map(X(i), Y(i), C(i), C(i+1), Sum(i) );
        	end generate;
end Structure;
		