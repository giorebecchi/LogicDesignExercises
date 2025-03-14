-- Sequence recognizer
library ieee; use ieee.std_logic_1164.all;

-- Recognizes the sequence 1101 at the input. Once the sequence is received,
-- puts start to 1 unless busy is 1
entity recognizer is
  port (
    clk, res : in std_logic;
    command : in std_logic;
    start : out std_logic;
    busy : in std_logic
  );
end entity recognizer;

architecture behavioral of recognizer is

  -- State. State a is the idle state. States b, c and d are used to recognize
  -- the input sequence
  type stato is (a, b, c, d);
  signal present_state : stato;

begin
  
  -- Sequential process. Determine the next state by updating directly the
  -- present state
  seq: process (res, clk) is begin

    -- Check for reset.
    if res = '0' then
      -- Go to the initial state
      present_state <= a;

    elsif rising_edge(clk) then
      -- Update the present state at the clock edge, depending on the current
      -- state and the input value
      case present_state is

        when a =>
          if command = '1' then present_state <= b;
          end if;

        when b =>
          if command = '0' then present_state <= a;
          else present_state <= c;
          end if;

        when c =>
          if command = '0' then present_state <= d;
          end if;

        when d =>
          if ( command = '0' or (command = '1' and busy = '0') ) then present_state <= a;
          end if;

      end case;

    end if;
  end process seq;

  -- Output process. The start command is activated only if we have recognized
  -- the input sequence (we are in state d) the input is the last bit of the
  -- correct sequence (command = '1') and the serializer is not busy (busy = '0')
  uscite: process (present_state, command, busy) is begin

    start <= '0';
    if present_state = d and command = '1' and busy = '0' then
      -- Start is always set immediately state d if command is 1 and busy is 0
      start <= '1';
      -- Case 2: we assume there is some delay in setting start, compared to busy
      -- start <= '1' after 1 ns;
    end if;

  end process uscite;

end architecture behavioral;
