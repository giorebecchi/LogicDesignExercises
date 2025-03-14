-- Sequence recognizer
library ieee; use ieee.std_logic_1164.all;

entity test_recognizer is
end entity;

architecture behavioral of test_recognizer is

  component recognizer is
    port (
      clk, res : in std_logic;
      command : in std_logic;
      start : out std_logic;
      busy : in std_logic
    );
  end component recognizer;

  signal clk, res : std_logic;
  signal command : std_logic;
  signal start : std_logic;
  signal busy : std_logic;

begin
  -- Instanzia il componente da testare
  dut : recognizer port map (
    clk => clk,
    res => res,
    command => command,
    start => start,
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

  -- Input process. We set busy initially to 0, then we send a sequence on
  -- command. The sequence is "1011010110111100000". The correct "1101" sequence
  -- appears twice
  process is begin
    command <= '0';
    busy <= '0';
    wait for 100 ns;
    wait for 21 ns;
    -- Send '1'
    command <= '1';
    wait for 10 ns;
    -- Send '0'
    command <= '0';
    wait for 10 ns;
    -- Send '11' (notice we wait 20 ns, not 10!)
    command <= '1';
    wait for 20 ns;
    -- Send '0'
    command <= '0';
    wait for 10 ns;
    -- Send '1'
    command <= '1';
    wait for 10 ns;
    -- Send '0'
    command <= '0';
    wait for 10 ns;
    -- Set busy to '1'
    busy <= '1';
    -- Send '11'
    command <= '1';
    wait for 20 ns;
    -- Send '0'
    command <= '0';
    wait for 10 ns;
    -- Send '1111' (we wait 30 ns, and another 10 ns after we set busy to '0')
    command <= '1';
    wait for 30 ns;
    busy <= '0';
    wait for 10 ns;
    -- Send '00000'
    command <= '0';
    wait for 50 ns;
    wait;
  end process;

end architecture;
