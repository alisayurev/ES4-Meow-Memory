library IEEE;
use IEEE.std_logic_1164.all;

entity converter is
    port (
        userIn		: in std_logic_vector(3 downto 0);
        userOut		: out std_logic_vector(1 downto 0);
		
        noIn        : out std_logic
    );
end converter;

architecture synth of converter is
begin
       userOut <= "00" when userIn = "1000" else
				   "01" when userIn = "0100" else
				   "10" when UserIn = "0010" else 
				   "11" when userIn = "0001" else
				   "00";
                          
       noIn <= '1' when userIn = "0000" else '0';
end synth;

 