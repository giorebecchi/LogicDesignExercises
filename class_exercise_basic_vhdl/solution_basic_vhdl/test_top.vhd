----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2022 02:59:09 PM
-- Design Name: 
-- Module Name: test_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_top is
--  Port ( );
end test_top;

architecture Behavioral of test_top is
  component top is
    Port (
      clk : in std_logic;
      res : in std_logic;
      command : in std_logic;
      data_in : in std_logic_vector( 3 downto 0 );
      serial_out : out std_logic
    );
  end component;
  signal clk, res, command, serial_out : std_logic;
  signal data_in : std_logic_vector( 3 downto 0 );
begin
  
  -- DUT
  dut : top port map (
    clk => clk,
    res => res,
    command => command,
    data_in => data_in,
    serial_out => serial_out
  );
  
  process begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
  end process;

  process begin
    res <= '0'; wait for 100 ns;
    res <= '1'; wait;
  end process;

  process begin
    command <= '0';
    data_in <= "1011";
    wait for 120 ns;
    -- Send the correct input sequence twice
    -- Careful with signals in the test bench which are not synchrnozied with
    -- the clock. If they are not, the simulator doesn't know if they come before
    -- or after the rising edge of the clock. It may assume either way, and lead to
    -- a wrong simulation. This is why we just wait for the rising edge of the
    -- clock here
    wait until rising_edge( clk );
    command <= '1';
    wait until rising_edge( clk );
    command <= '1';
    wait until rising_edge( clk );
    command <= '0';
    wait until rising_edge( clk );
    command <= '1';
    wait until rising_edge( clk );
    command <= '1';
    wait until rising_edge( clk );
    command <= '1';
    wait until rising_edge( clk );
    command <= '0';
    wait until rising_edge( clk );
    command <= '1';
    wait until rising_edge( clk );
    command <= '1';
    wait;
  end process;

--  -- This may not work
--  process begin
--    command <= '0';
--    data_in <= "1011";
--    wait for 120 ns;
--    command <= '1'; wait for 10 ns;
--    command <= '1'; wait for 10 ns;
--    command <= '0'; wait for 10 ns;
--    command <= '1'; wait for 10 ns;
--    command <= '1'; wait for 10 ns;
--    command <= '1'; wait for 10 ns;
--    command <= '0'; wait for 10 ns;
--    command <= '1'; wait for 10 ns;
--    command <= '1';
--    wait;
--  end process;

end Behavioral;
