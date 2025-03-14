----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2022 02:47:22 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
  Port (
    clk : in std_logic;
    reset : in std_logic;
    command : in std_logic;
    data_in : in std_logic_vector( 3 downto 0 );
    serial_out : out std_logic
  );
end top;

architecture Behavioral of top is

  component serializer is
    port (
      clk, reset : in std_logic;
      start : in std_logic;
      data_in : in std_logic_vector( 3 downto 0 );
      serial_out : out std_logic;
      busy : out std_logic
    );
  end component;
  component recognizer is
    port (
      clk, reset : in std_logic;
      command : in std_logic;
      start : out std_logic;
      busy : in std_logic
    );
  end component;
  
  signal start, busy : std_logic;
  
begin

  -- Instantiate and connect the recognizer with the serializer

  ser : serializer port map (
    clk => clk,
    reset => reset,
    start => start,
    data_in => data_in,
    serial_out => serial_out,
    busy => busy
  );
  rec : recognizer port map (
    clk => clk,
    reset => reset,
    command => command,
    start => start,
    busy => busy
  );

end Behavioral;
