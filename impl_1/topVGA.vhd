library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity topVGA is
	port(
		fromPLL 	: in std_logic; -- 25 MHz clock
		ruleTrue 	: in std_logic; 
		gameoverTrue 	: in std_logic;
		gameStart	: in std_logic;
		yourTurnBool 	: in std_logic;
		seqDone 	: in std_logic; -- sequnece has been completed
		pause		: in std_logic;
		catOut  	: in std_logic_vector(1 downto 0); --cat that is gonna be played
		VSYNC 		: out std_logic;
		HSYNC 		: out std_logic;
		RGB 		: out unsigned (5 downto 0)
	);
end topVGA;

architecture synth of topVGA is

--signals
signal valid : std_logic;
signal row : unsigned(9 downto 0);
signal col : unsigned(9 downto 0);
signal address : unsigned(14 downto 0);

--vga compnent declaration
component vga is 
	port(
		fromPLL : in std_logic;
		valid 	: out std_logic;
		row 	: out unsigned(9 downto 0);
		col 	: out unsigned(9 downto 0);
		HSYNC 	: out std_logic;
		VSYNC 	: out std_logic
	);
end component;

--patternGen component declaration
component patternGen is
	port(
		pGclk 		: in std_logic;
		valid 		: in std_logic;
		row 		: in unsigned(9 downto 0);
		col 		: in unsigned (9 downto 0);
		yourTurnBool 	: in std_logic;
		gameStart	: in std_logic;
		gameoverTrue 	: in std_logic;
		seqDone 	: in std_logic; -- sequnece has been completed
		pause		: in std_logic;
		catOut  	: in std_logic_vector(1 downto 0); --cat that is gonna be played
		RGBout 		: out unsigned (5 downto 0)
	);
end component;

begin
	
	--vga port map
	vgaport : vga port map(
		fromPLL => fromPLL ,
		valid => valid ,
		row => row , 
		col => col ,
		HSYNC => HSYNC ,  
		VSYNC => VSYNC
	);

	--patternGen port map 
	patternport : patternGen port map(
		pGclk => fromPLL ,
        	valid => valid , 
		row => row , 
		col => col , 
		gameStart	=> gameStart,
		gameoverTrue => gameoverTrue , 
		yourTurnBool => yourTurnBool,
		seqDone => seqDone,
		pause=> pause,
		catOut  => catOut ,
		RGBout => RGB
	);
	
end;
