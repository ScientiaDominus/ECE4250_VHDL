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

    -- this bit modified from slide 13 http://osorio.wait4.org/SSC0113/AULA02/eecs_317_adder.pdf
    signal C: std_logic_vector(24 downto 0);    -- 24 downto 0 for Cin and Cout cases
    begin
        C(0) <= Ci;         -- Cin
        Co <= C(24);        -- Cout
        FA: for i in 0 to 23 generate
            FA_i: FullAdder port map( X(i), Y(i), C(i), C(i+1), S(i) );
        end generate;
end arch;