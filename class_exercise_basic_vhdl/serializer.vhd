--serializer

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serializer is
    Port ( clk          :       in  STD_LOGIC;
           reset        :       in  STD_LOGIC;
           start        :       in  STD_LOGIC;
           data_in      :       in STD_LOGIC_VECTOR(3 downto 0);
           busy         :       out STD_LOGIC;
           serial_out   :       out STD_LOGIC
    );
end serializer;

architecture behavioral of serializer is
    type states is (idle,S0,S1,S2,S3,S4);
    signal present_state,next_state:states;
begin
    process (clk,reset) begin
        if reset='1' then
            present_state<=idle;
        elsif rising_edge(clk) then
            present_state<=next_state;
        end if;
    end process;
    process(present_state,start) begin
        case present_state is
            when idle =>
                if start='1' then
                    next_state<=S0;
                else
                    next_state<=idle;
                end if;
            when S0 =>
                next_state<=S1;
            when S1 =>
                next_state<=S2;
            when S2 =>
                next_state<=S3;
            when S3 =>
                next_state<=S4;
            when S4 =>
                next_state<=idle;
        end case;
    end process;
    process(present_state,start) begin
        busy<='0';
        serial_out<='0';
        case present_state is 
            when idle=>
                busy <= '0';
                serial_out <= '0';
                if start='1' then 
                    busy<='1';
                    serial_out<='1';
                end if;
            when S0=>
                    busy<='1';
                    serial_out<=data_in(0);
            when S1=>
                    busy<='1';
                    serial_out<=data_in(1);
            when S2=>
                    busy<='1';
                    serial_out<=data_in(2);
            when S3=>
                    busy<='1';
                    serial_out<=data_in(3);
            when S4=>
                    busy<='1';
                    serial_out<='0';

        end case;
    end process;
end behavioral;