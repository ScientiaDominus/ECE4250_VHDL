library IEEE;
use IEEE.std_logic_1164.all;

entity adder24 is
    port(X,Y: in std_logic_vector(23 downto 0);
            Ci: in std_logic;
            S: out std_logic_vector(23 downto 0);
            Co: out std_logic);
end adder24;

Architecture arch of adder24 is
    component FullAdder
        port(A, B, Cin: in std_logic;
		        Cout, Sum: out std_logic);
    end component;

    signal C: std_logic_vector(23 downto 1);
    begin
        FA1: FullAdder port map(X(0), Y(0), Ci, C(1), S(0));
        FA2: FullAdder port map(X(1), Y(1), C(1), C(2), S(1));
        FA3: FullAdder port map(X(2), Y(2), C(2), C(3), S(2));
        FA4: FullAdder port map(X(3), Y(3), C(3), C(4), S(3));
        FA5: FullAdder port map(X(4), Y(4), C(4), C(5), S(4));
        FA6: FullAdder port map(X(5), Y(5), C(5), C(6), S(5));
        FA7: FullAdder port map(X(6), Y(6), C(6), C(7), S(6));
        FA8: FullAdder port map(X(7), Y(7), C(7), C(8), S(7));
        FA9: FullAdder port map(X(8), Y(8), C(8), C(9), S(8));
        FA10: FullAdder port map(X(9), Y(9), C(9), C(10), S(9));
        FA11: FullAdder port map(X(10), Y(10), C(10), C(11), S(10));
        FA12: FullAdder port map(X(11), Y(11), C(11), C(12), S(11));
        FA13: FullAdder port map(X(12), Y(12), C(12), C(13), S(12));
        FA14: FullAdder port map(X(13), Y(13), C(13), C(14), S(13));
        FA15: FullAdder port map(X(14), Y(14), C(14), C(15), S(14));
        FA16: FullAdder port map(X(15), Y(15), C(15), C(16), S(15));
        FA17: FullAdder port map(X(16), Y(16), C(16), C(17), S(16));
        FA18: FullAdder port map(X(17), Y(17), C(17), C(18), S(17));
        FA19: FullAdder port map(X(18), Y(18), C(18), C(19), S(18));
        FA20: FullAdder port map(X(19), Y(19), C(19), C(20), S(19));
        FA21: FullAdder port map(X(20), Y(20), C(20), C(21), S(20));
        FA22: FullAdder port map(X(21), Y(21), C(21), C(22), S(21));
        FA23: FullAdder port map(X(22), Y(22), C(22), C(23), S(22));
        FA24: FullAdder port map(X(23), Y(23), C(23), Co, S(23));
end arch;