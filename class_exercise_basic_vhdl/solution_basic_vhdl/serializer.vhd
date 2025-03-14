-- Serializer
library ieee; use ieee.std_logic_1164.all;

-- Given the start command, serialize the input data_in to the output, adding
-- a start bit at 1 and a stop bit at 0. Set busy to 1 during serialization
entity serializer is
  port (
    clk, res : in std_logic;
    start : in std_logic;
    data_in : in std_logic_vector( 3 downto 0 );
    serial_out : out std_logic;
    busy : out std_logic
  );
end entity serializer;

architecture behavioral of serializer is

  -- State. The start bit is sent directly during the idle state if the start
  -- command is asserted, bit0-bit3 place the correct bit to the output,
  -- send_stop is used to send the stop bit
  type stato is (idle, bit0, bit1, bit2, bit3, send_stop);
  signal present_state : stato;

begin
  
  -- Sequential process. Update the present state directly
  seq: process (res, clk) is begin

    if res = '0' then
      present_state <= idle;
    elsif rising_edge(clk) then

      case present_state is
        when idle =>
          if start = '1' then present_state <= bit0;
          end if;
        when bit0 => present_state <= bit1;
        when bit1 => present_state <= bit2;
        when bit2 => present_state <= bit3;
        when bit3 => present_state <= send_stop;
        when send_stop => present_state <= idle;
      end case;

    end if;
  end process seq;

  -- Output process.
  uscite: process (present_state, start, data_in) is begin

    -- By default, we are not serializing, busy is off and serial_out is at the
    -- default 0 value
    busy <= '0';
    serial_out <= '0';
    -- Update the output according to the present state
    case present_state is
      when idle =>
        if start = '1' then
          -- Output the start bit
          serial_out <= '1';
          -- Handle the busy signal
          -- Case 1: we set busy to '1' immediately. This generates a 0 delay
          -- combinational cycle with the recognizer, and simulation does not
          -- proceed
          busy <= '1';

          -- Case 2: we assume there is some delay in setting busy due to the
          -- logic. There still is a combinational cycle, but not a 0 delay.
          -- Simulation proceeds, but outcome is not always correct
          -- busy <= '1' after 1 ns;
          -- Different delays give different results
          -- busy <= '1' after 1.6 ns;

          -- Case 3: we wait the next cycle before setting busy to '1'. This
          -- avoids the combinational cycle, since the serializer is no longer
          -- a Mealy machine
          -- busy <= '0';
        end if;
      when bit0 => serial_out <= data_in( 0 ); busy <= '1';
      when bit1 => serial_out <= data_in( 1 ); busy <= '1';
      when bit2 => serial_out <= data_in( 2 ); busy <= '1';
      when bit3 => serial_out <= data_in( 3 ); busy <= '1';
      when send_stop => serial_out <= '0'; busy <= '1';
    end case;

  end process uscite;

end architecture behavioral;
