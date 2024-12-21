library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_debouncing is 
    port(
        clk      	: in std_logic; --25Mhz pll clock
        slow_clock 	: out std_logic --enable signal for debouncing register
    );
end clock_debouncing;

architecture behavioral of clock_debouncing is

-- a button typically takes 20ms to settle mechanically
-- denouce time = 20ms, pll clock is 25Mhz
-- threshold value = 20ms * 25MHZ (number of clock cycles for which signal must be stable to be considered debounced)
-- numbver of clock cycles needed for 20 ms -> 0.02s * 25Mhz = 500,000 cycles

signal counter: unsigned(18 downto 0) := (others => '0'); --19 bits ^ to be able to count to at least 500,000
constant max_count : unsigned(18 downto 0) := to_unsigned(500_000, 19); 
signal bigcounter : unsigned(24 downto 0);


begin
process(clk) is
begin
    if rising_edge(clk) then

        if counter = max_count then  
            counter <= (others => '0');  --reset counter after 500,000
        else
            counter <= counter + 1; 
        end if;

    end if;
end process;

--pulse the slow clock
slow_clock <= '1' when counter = max_count else '0'; 

end behavioral;

 
