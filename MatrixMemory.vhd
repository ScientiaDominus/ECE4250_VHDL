library IEEE;
use IEEE.std_logic_1164.all;

entity Matrix is    
end Matrix;

architecture Structure of Matrix is
    type matrix is array(0 to 255, 0 to 255) of integer;
    signal mtx1 : matrix := (others => (others => 0));
    signal mtx2 : matrix := (others => (others => 0));
    begin 
    
end Structure; 