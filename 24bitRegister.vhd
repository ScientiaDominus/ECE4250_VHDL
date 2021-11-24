library IEEE;
use IEEE.std_logic_1164.all;

entity register8 is
	port(d: in std_logic_vector (23 downto 0);
	ld, clr, clk: in std_logic;
	q: out std_logic_vector (23 downto 0));
end register8;

Architecture Structure of register8 is
begin
process(clk, clr)
	begin
		if clr = '1' then
			q <= "000000000000000000000000";
		elsif rising_edge(clk) then
			if ld = '1' then 
				q <= d;
			end if;	
		end if;
	end process;
end Structure;
