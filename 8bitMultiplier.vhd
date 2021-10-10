library IEEE;
use IEEE.std_logic_1164.all;

entity Multiplier8 is
	port(X, Y: in std_logic_vector(7 downto 0);
		P: out std_logic_vector(15 downto 0));
end Multiplier8;


-- 8x8 array multiplier has
-- 64 AND's
-- 8 HA's
-- 48 FA's
architecture arch of Multiplier8 is
signal C1, C2, C3, C4, C5, C6, C7: std_logic_vector(7 downto 0);
signal S1, S2, S3, S4, S5, S6, S7: std_logic_vector(7 downto 0);
signal XY0, XY1, XY2, XY3, XY4, XY5, XY6, XY7: std_logic_vector(7 downto 0);

component FullAdder
	port(A, B, Cin: in std_logic;
		Cout, Sum: out std_logic);
end component;

component HalfAdder
	port(A, B: in std_logic;
		Cout, Sum: out std_logic);
end component;

begin

	XY0(0) <= X(0) and Y(0);
	XY0(1) <= X(1) and Y(0);
	XY0(2) <= X(2) and Y(0);
	XY0(3) <= X(3) and Y(0);
	XY0(4) <= X(4) and Y(0);
	XY0(5) <= X(5) and Y(0);
	XY0(6) <= X(6) and Y(0);
	XY0(7) <= X(7) and Y(0);

	XY1(0) <= X(0) and Y(1);
	XY1(1) <= X(1) and Y(1);
	XY1(2) <= X(2) and Y(1);
	XY1(3) <= X(3) and Y(1);
	XY1(4) <= X(4) and Y(1);
	XY1(5) <= X(5) and Y(1);
	XY1(6) <= X(6) and Y(1);
	XY1(7) <= X(7) and Y(1);

	XY2(0) <= X(0) and Y(2);
	XY2(1) <= X(1) and Y(2);
	XY2(2) <= X(2) and Y(2);
	XY2(3) <= X(3) and Y(2);
	XY2(4) <= X(4) and Y(2);
	XY2(5) <= X(5) and Y(2);
	XY2(6) <= X(6) and Y(2);
	XY2(7) <= X(7) and Y(2);

	XY3(0) <= X(0) and Y(3);
	XY3(1) <= X(1) and Y(3);
	XY3(2) <= X(2) and Y(3);
	XY3(3) <= X(3) and Y(3);
	XY3(4) <= X(4) and Y(3);
	XY3(5) <= X(5) and Y(3);
	XY3(6) <= X(6) and Y(3);
	XY3(7) <= X(7) and Y(3);

    	XY4(0) <= X(0) and Y(4);
	XY4(1) <= X(1) and Y(4);
	XY4(2) <= X(2) and Y(4);
	XY4(3) <= X(3) and Y(4);
	XY4(4) <= X(4) and Y(4);
	XY4(5) <= X(5) and Y(4);
	XY4(6) <= X(6) and Y(4);
	XY4(7) <= X(7) and Y(4);

    	XY5(0) <= X(0) and Y(5);
	XY5(1) <= X(1) and Y(5);
	XY5(2) <= X(2) and Y(5);
	XY5(3) <= X(3) and Y(5);
	XY5(4) <= X(4) and Y(5);
	XY5(5) <= X(5) and Y(5);
	XY5(6) <= X(6) and Y(5);
	XY5(7) <= X(7) and Y(5);

    	XY6(0) <= X(0) and Y(6);
	XY6(1) <= X(1) and Y(6);
	XY6(2) <= X(2) and Y(6);
	XY6(3) <= X(3) and Y(6);
	XY6(4) <= X(4) and Y(6);
	XY6(5) <= X(5) and Y(6);
	XY6(6) <= X(6) and Y(6);
	XY6(7) <= X(7) and Y(6);

    	XY7(0) <= X(0) and Y(7);
	XY7(1) <= X(1) and Y(7);
	XY7(2) <= X(2) and Y(7);
	XY7(3) <= X(3) and Y(7);
	XY7(4) <= X(4) and Y(7);
	XY7(5) <= X(5) and Y(7);
	XY7(6) <= X(6) and Y(7);
	XY7(7) <= X(7) and Y(7);

	
	FA1 : FullAdder port map ( XY0(2), XY1(1), C1(0), C1(1), S1(1) );
	FA2 : FullAdder port map ( XY0(3), XY1(2), C1(1), C1(2), S1(2) );
	FA3 : FullAdder port map ( XY0(4), XY1(3), C1(2), C1(3), S1(3) );
	FA4 : FullAdder port map ( XY0(5), XY1(4), C1(3), C1(4), S1(4) );
	FA5 : FullAdder port map ( XY0(6), XY1(5), C1(4), C1(5), S1(5) );
	FA6 : FullAdder port map ( XY0(7), XY1(6), C1(5), C1(6), S1(6) );

	FA7 : FullAdder port map ( S1(2), XY2(1), C2(0), C2(1), S2(1) );
	FA8 : FullAdder port map ( S1(3), XY2(2), C2(1), C2(2), S2(2) );	FA9 : FullAdder port map ( S1(4), XY2(3), C2(2), C2(3), S2(3) );
	FA10: FullAdder port map ( S1(5), XY2(4), C2(3), C2(4), S2(4) );
	FA11: FullAdder port map ( S1(6), XY2(4), C2(4), C2(5), S2(5) );
	FA12: FullAdder port map ( S1(7), XY2(6), C2(5), C2(6), S2(6) );
	FA13: FullAdder port map ( C1(7), XY2(7), C2(6), C2(7), S2(7) );

	FA14: FullAdder port map ( S2(2), XY3(1), C3(0), C3(1), S3(1) );
	FA15: FullAdder port map ( S2(3), XY3(2), C3(1), C3(2), S3(2) );
	FA16: FullAdder port map ( S2(4), XY3(3), C3(2), C3(3), S3(3) );
	FA17: FullAdder port map ( S2(5), XY3(4), C3(3), C3(4), S3(4) );
	FA18: FullAdder port map ( S2(6), XY3(5), C3(4), C3(5), S3(5) );
	FA19: FullAdder port map ( S2(7), XY3(6), C3(5), C3(6), S3(6) );
	FA20: FullAdder port map ( C2(7), XY3(7), C3(6), C3(7), S3(7) );

	FA21: FullAdder port map ( S3(2), XY4(1), C4(0), C4(1), S4(1) );
	FA22: FullAdder port map ( S3(3), XY4(2), C4(1), C4(2), S4(2) );
	FA23: FullAdder port map ( S3(4), XY4(3), C4(2), C4(3), S4(3) );
	FA24: FullAdder port map ( S3(5), XY4(4), C4(3), C4(4), S4(4) );
	FA25: FullAdder port map ( S3(6), XY4(5), C4(4), C4(5), S4(5) );
	FA26: FullAdder port map ( S3(7), XY4(6), C4(5), C4(6), S4(6) );
	FA27: FullAdder port map ( C3(7), XY4(7), C4(6), C4(7), S4(7) );

	FA28: FullAdder port map ( S4(2), XY5(1), C5(0), C5(1), S5(1) );
	FA29: FullAdder port map ( S4(3), XY5(2), C5(1), C5(2), S5(2) );
	FA30: FullAdder port map ( S4(4), XY5(3), C5(2), C5(3), S5(3) );
	FA31: FullAdder port map ( S4(5), XY5(4), C5(3), C5(4), S5(4) );
	FA32: FullAdder port map ( S4(6), XY5(5), C5(4), C5(5), S5(5) );
	FA33: FullAdder port map ( S4(7), XY5(6), C5(5), C5(6), S5(6) );
	FA34: FullAdder port map ( C4(7), XY5(7), C5(6), C5(7), S5(7) );

	FA35: FullAdder port map ( S5(2), XY6(1), C6(0), C6(1), S6(1) );
	FA36: FullAdder port map ( S5(3), XY6(2), C6(1), C6(2), S6(2) );
	FA37: FullAdder port map ( S5(4), XY6(3), C6(2), C6(3), S6(3) );
	FA38: FullAdder port map ( S5(5), XY6(4), C6(3), C6(4), S6(4) );
	FA39: FullAdder port map ( S5(6), XY6(5), C6(4), C6(5), S6(5) );
	FA40: FullAdder port map ( S5(7), XY6(6), C6(5), C6(6), S6(6) );
	FA41: FullAdder port map ( C5(7), XY6(7), C6(6), C6(7), S6(7) );

	FA42: FullAdder port map ( S6(2), XY7(1), C7(0), C7(1), S7(1) );
	FA43: FullAdder port map ( S6(3), XY7(2), C7(1), C7(2), S7(2) );
	FA44: FullAdder port map ( S6(4), XY7(3), C7(2), C7(3), S7(3) );
	FA45: FullAdder port map ( S6(5), XY7(4), C7(3), C7(4), S7(4) );
	FA46: FullAdder port map ( S6(6), XY7(5), C7(4), C7(5), S7(5) );
	FA47: FullAdder port map ( S6(7), XY7(6), C7(5), C7(6), S7(6) );
	FA48: FullAdder port map ( C6(7), XY7(7), C7(6), C7(7), S7(7) );


	HA1: HalfAdder port map( XY0(1), XY1(0), C1(0), S1(0));
	HA2: HalfAdder port map( XY1(7), C1(6), C1(7), S1(7));
	HA3: HalfAdder port map( XY2(0), S1(1), C2(0), S2(0));
	HA4: HalfAdder port map( XY3(0), S2(1), C3(0), S3(0));
	HA5: HalfAdder port map( XY4(0), S3(1), C4(0), S4(0));
	HA6: HalfAdder port map( XY5(0), S4(1), C5(0), S5(0));
	HA7: HalfAdder port map( XY6(0), S5(1), C6(0), S6(0));
	HA8: HalfAdder port map( XY7(0), S6(1), C7(0), S7(0));

	P(0) <= XY0(0);
	P(1) <= S1(0);
	P(2) <= S2(0);
	P(3) <= S3(0);
	P(4) <= S4(0);
	P(5) <= S5(0);
	P(6) <= S6(0);
	P(7) <= S7(0);
	P(8) <= S7(1);
	P(9) <= S7(2);
	P(10) <= S7(3);
	P(11) <= S7(4);
	P(12) <= S7(5);
	P(13) <= S7(6);
	P(14) <= S7(7);	P(15) <= C7(7);
	
end arch;