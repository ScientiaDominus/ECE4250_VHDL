library IEEE;
use IEEE.std_logic_1164.all;

entity adder24 is
	port(A, B, in std_logic_vector(23 downto 0);
		Cin: in std_logic;
		Sum: out std_logic_vector(23 downto 0);
		Cout: out std_logic);
end adder24;

Architecture Structure of adder24 is
	component FullAdder 
		port(X, Y, Cin: in std_logic;
		Cout, Sum: out std_logic);
	end component;
	signal C: std_logic_vector(23 downto 1);
	begin 
	FA0: FullAdder port map (A(0), B(0), Cin, C(1), Sum(0));
	FA1: FullAdder port map (A(1), B(1), C(1), C(2), Sum(1));
	FA2: FullAdder port map (A(2), B(2), C(2), C(3), Sum(2));
	FA3: FullAdder port map (A(3), B(3), C(3), C(4), Sum(3));
	FA4: FullAdder port map (A(4), B(4), C(4), C(5), Sum(4));
	FA5: FullAdder port map (A(5), B(5), C(5), C(6), Sum(5));
	FA6: FullAdder port map (A(6), B(6), C(6), C(7), Sum(6));	
	FA7: FullAdder port map (A(7), B(7), C(7), C(8), Sum(7));
	FA8: FullAdder port map (A(8), B(8), C(8), C(9), Sum(8));
	FA9: FullAdder port map (A(9), B(9), C(9), C(10), Sum(9));
	FA10: FullAdder port map (A(10), B(10), C(10), C(11), Sum(10));
	FA11: FullAdder port map (A(11), B(11), C(11), C(12), Sum(11));
	FA12: FullAdder port map (A(12), B(12), C(12), C(13), Sum(12));
	FA13: FullAdder port map (A(13), B(13), C(13), C(14), Sum(13));	
	FA14: FullAdder port map (A(14), B(14), C(14), C(15), Sum(14));
	FA15: FullAdder port map (A(15), B(15), C(15), C(16), Sum(15));
	FA16: FullAdder port map (A(16), B(16), C(16), C(17), Sum(16));
	FA17: FullAdder port map (A(17), B(17), C(17), C(18), Sum(17));
	FA18: FullAdder port map (A(18), B(18), C(18), C(19), Sum(18));
	FA19: FullAdder port map (A(19), B(19), C(19), C(20), Sum(19));
	FA20: FullAdder port map (A(20), B(20), C(20), C(21), Sum(20));
	FA22: FullAdder port map (A(21), B(21), C(21), C(22), Sum(21));
	FA23: FullAdder port map (A(22), B(22), C(22), C(23), Sum(22));
	FA24: FullAdder port map (A(23), B(23), C(23), Cout, Sum(23));
end Structure;

	


