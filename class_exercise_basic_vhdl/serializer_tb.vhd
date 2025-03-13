--serializer_tb
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity serializer_tb is
end serializer_tb;

architecture simple of serializer_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal start : std_logic := '0';
    signal data_in : std_logic_vector(3 downto 0) := (others => '0');
    signal busy : std_logic := '0';
    signal serial_out : std_logic := '0';
    begin
    g1: entity work.serializer 
        port map(clk => clk, reset => reset, start => start, data_in => data_in, busy => busy, serial_out => serial_out);
    clk <= not clk after 10 ns;
    reset<= '0';
    start<= '0', '1' after 40 ns, '0' after 60 ns;
    data_in<= "0000", "0001" after  50 ns, "0011" after 70 ns, "1011" after 110 ns, "0000" after 130 ns;
end simple;