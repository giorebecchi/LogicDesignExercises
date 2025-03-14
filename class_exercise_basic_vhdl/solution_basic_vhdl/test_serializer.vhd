library ieee; use ieee.std_logic_1164.all;

entity test_serializer is
end entity;

architecture behavioral of test_serializer is

  component serializer is
    port (
      clk, res : in std_logic;
      start : in std_logic;
      data_in : in std_logic_vector( 3 downto 0 );
      serial_out : out std_logic;
      busy : out std_logic
    );
  end component serializer;

  signal clk, res : std_logic;
  signal start : std_logic;
  signal data_in : std_logic_vector( 3 downto 0 );
  signal serial_out : std_logic;
  signal busy : std_logic;

begin

  -- Instantiate the device under test
  dut : serializer port map (
    clk => clk,
    res => res,
    start => start,
    data_in => data_in,
    serial_out => serial_out,
    busy => busy
  );

  -- Clock process
  process is begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
  end process;

  -- Reset process
  process is begin
    res <= '0'; wait for 100 ns;
    res <= '1';
    wait;
  end process;

  -- Input process. We set the input data, then set start to '1' for one clock
  -- cycle, then wait 10 more cycle and set start to '1' again
  process is begin
    data_in <= "0101";
    start <= '0';
    wait for 100 ns;
    wait for 31 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 100 ns;
    start <= '1';
    wait for 100 ns;
    wait;
  end process;

end architecture;
