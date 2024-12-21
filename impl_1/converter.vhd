library IEEE;
use IEEE.std_logic_1164.all;

entity converter is
    port (
        userIn		: in std_logic_vector(3 downto 0); --user input 
        userOut		: out std_logic_vector(1 downto 0); --converted input
        noIn        	: out std_logic
    );
end converter;

architecture synth of converter is
begin
	
--conversion of user input into binary-encoding (4 cats)
       userOut <= "00" when userIn = "1000" else
				   "01" when userIn = "0100" else
				   "10" when UserIn = "0010" else 
				   "11" when userIn = "0001" else
				   "00";

--when no edge is registers on any bit of the vector
       noIn <= '1' when userIn = "0000" else '0';
					   
end synth;

 
