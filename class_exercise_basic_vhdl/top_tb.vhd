library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end top_tb;

architecture integration of top_tb is
    -- Test signals
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal command     : std_logic_vector(3 downto 0) := (others => '0');
    signal data_in     : std_logic_vector(3 downto 0) := (others => '0');
    signal serial_out  : std_logic := '0';
    
    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- Instantiate the top_controller
    dut: entity work.top
        port map (
            clk        => clk,
            reset      => reset,
            command    => command,
            data_in    => data_in,
            serial_out => serial_out
        );
    
    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize and reset
        reset <= '1';
        command <= "0000";
        data_in <= "1010";  -- Data to be serialized
        wait for CLK_PERIOD*2;
        reset <= '0';
        wait for CLK_PERIOD*2;
        
        -- Test case 1: Complete command sequence "1011"
        -- Begin with command bit 0
        command <= "0001";  -- A to B: command(0) = 1
        wait for CLK_PERIOD*2;
        
        -- Command bit 1
        command <= "0011";  -- B to C: command(1) = 1
        wait for CLK_PERIOD*2;
        
        -- Command bit 2
        command <= "0011";  -- C to D: command(2) = 0
        wait for CLK_PERIOD*2;
        
        -- Command bit 3
        command <= "1011";  -- D with command(3) = 1
        
        -- Wait for serialization to complete 
        -- (should take at least 5 clock cycles for all 4 bits of data_in)
        wait for CLK_PERIOD*2;
        
        -- Reset command to start new sequence
        command <= "0000";
        
        wait for CLK_PERIOD*25;
        
        -- End simulation
        wait;
    end process;

end integration;