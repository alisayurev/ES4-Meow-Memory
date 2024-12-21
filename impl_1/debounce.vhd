library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


--four bit register
entity debounce_input is
port(
    clk				: in std_logic;
    input			: in std_logic_vector(3 downto 0);
    clock_enable		: in std_logic;
    output			: out std_logic_vector(3 downto 0)
);
end debounce_input;


architecture behavioral of debounce_input is 

signal bigcounter : unsigned(24 downto 0);

begin
process(clk) 
begin 
    if rising_edge(clk) then 

	if (clock_enable = '1') then
		output <= input;
	end if;

    end if;
end process;
end behavioral;
