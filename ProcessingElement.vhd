library IEEE;
use IEEE.std_logic_1164.all;

entity PE is
    port(load, clr, clk: in std_logic;
        Mcand, Mlier: in std_logic_vector(7 downto 0);
        addIn: in std_logic_vector(24 downto 0);
        Mout: out std_logic_vector(7 downto 0);
        Sout: out std_logic_vector(24 downto 0));
end PE;

architecture Structure of PE is
    
    component 8bitRegister 
        port(d: in std_logic_vector (7 downto 0);
        ld, clr, clk: in std_logic;
        q: out std_logic_vector (7 downto 0));
    end component;
    component 24bitRegister
    
    end component;
    component 8bitMultiplier

    end component;
    component 24bitAdder
        port(X,Y: in std_logic_vector(23 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(23 downto 0);
        Co: out std_logic);
    end component;
    begin
    signal MResult: std_logic_vector(15 downto 0);
    signal AResult: std_logic_vector(23 downto 0);
    RA1: 8bitRegister port map(Mcand, load, clr, clk, ); --Which port should these be connected to? Perhaps another signal is needed? 
    RA2: 8bitRegister port map(Mlier, load, clr, clk, ); --RA1 should definitely be connected to Mout but how is it also connected to Min for the 8bitMultiplier?
    RA3: 24bitRegister port map()

    FA1: 24bitAdder port map(addIn, ("00000000" & MResult), addIn(24), Aresult(23 downto 0), AResult(24));
    process(clk)
        begin  
            if rising_edge(clk) then
    end;
    Mout <= Mcand;
end Structure;