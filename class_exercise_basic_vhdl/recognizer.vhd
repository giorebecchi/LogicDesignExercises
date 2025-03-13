--recognizer

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity recognizer is
    Port ( clk          :       in  STD_LOGIC;
           reset        :       in  STD_LOGIC;
           command      :       in STD_LOGIC_VECTOR(3 downto 0);
           busy         :       in STD_LOGIC;
           start        :       out STD_LOGIC
    );
end recognizer;

architecture behavioral of recognizer is
    type states is (A,B,C,D);
    signal present_state,next_state:states;
begin
    process(clk,reset) begin
        if reset='1' then
            present_state<=A;
        elsif rising_edge(clk) then
            present_state<=next_state;
        end if;
    end process;
    process(present_state,command,busy) begin

        case present_state is
            when A =>
                if command(0) = '1' then
                    next_state<=B;
                else
                    next_state<=A;
                end if;
            when B =>
                if command(1) = '1' then
                    next_state<=C;
                else
                    next_state<=A;
                end if;
            when C =>
                if command(2) = '0' then
                    next_state<=D;
                else
                    next_state<=C;
                end if;
            when D =>
                if (busy='1' and command(3) = '1') then
                    next_state<=D;
                else
                    next_state<=A;
                end if;
        end case;
    end process;
    process(present_state,busy,command) begin
        start<='0';
        case present_state is 
            when A=>
                start <= '0';
            when B=>
                start <= '0';
            when C=>
                start <= '0';
            when D=>
                start <= '0';
                if (busy='0' and command(3) = '1')then 
                    start<='1';
                end if;
        end case;
    end process;
end behavioral;