library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity recognizer_tb is
end recognizer_tb;

architecture simple of recognizer_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal busy : std_logic := '0';
    signal start : std_logic := '0';
    signal command : std_logic_vector(3 downto 0) := (others => 'X');
    
begin
    g1: entity work.recognizer 
        port map(clk => clk, reset => reset, command => command, busy => busy, start => start);
    clk <= not clk after 10 ns;
 
    reset <= '0';
    command <= "XXX1" after 30 ns,"XX11" after 50 ns, "X011" after 70 ns, 
               "1011" after 90 ns,"0000" after 110 ns;
    busy <= '0', '1' after 30 ns, '0' after 90 ns;
    
end simple;