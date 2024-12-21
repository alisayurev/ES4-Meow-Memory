library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
	port(
		fromPLL : in std_logic;
		valid   : out std_logic;
		row     : out unsigned(9 downto 0);
		col     : out unsigned(9 downto 0);
		
		HSYNC   : out std_logic;
		VSYNC   : out std_logic
	
	);
end vga;

architecture synth of vga is

signal row_t :  unsigned(9 downto 0) := (others => '0');
signal col_t     : unsigned(9 downto 0) := (others => '0');





begin
	process(fromPLL) begin
		if rising_edge(fromPLL) then 
			--column logic
		if col_t <  799  then
		
			col_t <= col_t + 1;
		else
			col_t <= (others => '0');
			if row_t < 524 then
				row_t <= row_t + 1;
			else
				row_t <= (others => '0');
			end if ;
		end if;
			--sync logic (using countC + countR so back porch, front porch, sync same)
		
	
		end if;
	end process;
			HSYNC <= '0' when (col_t >= 656 and col_t < 752) else '1';  -- 656 to 751
            VSYNC <= '0' when (row_t >= 490 and row_t < 492) else '1';  -- 490 to 491

            -- Valid signal logic
            valid <= '1' when (col_t < 640 and row_t < 480) else '0';  -- 640 x 480
	
	row <= row_t;
	col <= col_t;
end;