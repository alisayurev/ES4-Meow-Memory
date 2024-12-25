library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity startArrow is 
port(
    clk : in std_logic;
	address : in unsigned (14 downto 0); 
    rgb : out unsigned(5 downto 0)
);
end startArrow;


architecture synth of startArrow is 

signal addressOut : unsigned(14 downto 0); 

begin
    process (clk) is begin
        if rising_edge(clk) then
            case addressOut is
                when "010100101000011" => rgb <= "000000";
                when "010101001000011" => rgb <= "000000";
                when "010101001000100" => rgb <= "000000";
                when "010101101000011" => rgb <= "000000";
                when "010101101000100" => rgb <= "000000";
                when "010101101000101" => rgb <= "000000";
                when "010110001000011" => rgb <= "000000";
                when "010110001000100" => rgb <= "000000";
                when "010110101000011" => rgb <= "000000";
                when others => rgb <= "111111";
            end case;
        end if;
    end process; 
	addressOut <= address;
end;  
