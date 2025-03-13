library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
entity top is 
    Port (  
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        command     : in  STD_LOGIC_VECTOR(3 downto 0);
        data_in     : in  STD_LOGIC_VECTOR(3 downto 0);
        serial_out  : out STD_LOGIC     
    ); 
end top; 
        
        
architecture structural of top is 
    -- Internal signals to connect the two components
    signal start_signal : STD_LOGIC;
    signal busy_signal  : STD_LOGIC; 
    begin
     -- Instantiate the recognizer
     recognizer_inst: entity work.recognizer
        port map (             
            clk     => clk,
            reset   => reset,
            command => command,
            busy    => busy_signal,
            start   => start_signal 
        );
    -- Instantiate the serializer
    serializer_inst: entity work.serializer
        port map (
            clk        => clk,
            reset      => reset,
            start      => start_signal,
            data_in    => data_in,
            busy       => busy_signal,
            serial_out => serial_out             
        );
end structural;