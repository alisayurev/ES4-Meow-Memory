library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	port(
		buttons	: in std_logic_vector(3 downto 0);	-- user inputs
		exOsc 	: in std_logic;
		rgb 	: out unsigned(5 downto 0);
		hsync	: out std_logic;
		vsync	: out std_logic
	);
end top;

architecture synth of top is

-- SIGNALS -----------------------------------------------------------------------------
signal PLLop : std_logic;
signal fromPLL : std_logic;
signal stateOut : std_logic_vector(3 downto 0); 
signal slow_clk_enable : std_logic;

signal Q0, Q1, Q2, Q3 : std_logic_vector(3 downto 0);  
signal debounced_buttons : std_logic_vector(3 downto 0);
signal previous_debounced_buttons : std_logic_vector(3 downto 0);
signal edge_detected_buttons : std_logic_vector(3 downto 0);

signal noIn : std_logic;
signal seqDone: std_logic;
signal pause: std_logic;
signal catOut: std_logic_vector(1 downto 0);
signal nextRound : std_logic;
signal gameOver : std_logic;

--signals for playing sequence + comparing sequence
signal catNum 		: std_logic_vector (15 downto 0);
signal catSeq		: std_logic_vector (15 downto 0);
signal catIn 		: std_logic_vector (1 downto 0);
signal playCount	: unsigned(3 downto 0) := "0000";
signal counter		: unsigned(25 downto 0);
signal startTrue	:  std_logic;
signal yourTurnTrue :  std_logic;
signal gameoverTrue : std_logic;
signal yourTurnBool2 : std_logic;
signal gameStart	:  std_logic;

-- COMPONENT DECLARATIONS -------------------------------------------------------------
component topVGA is 
	port(
		fromPLL 	: in std_logic;
		gameoverTrue 	: in std_logic;
		yourTurnBool 	: in std_logic;
		gameStart	: in std_logic;
		seqDone 	: in std_logic; -- sequnece has been completed
		pause		: in std_logic;
		catOut  	: in std_logic_vector(1 downto 0); --cat that is gonna be played
		VSYNC 		: out std_logic;
		HSYNC 		: out std_logic;
		RGB 		: out unsigned (5 downto 0)
	);
end component;
	
--PLL component declaration
component pll2 is
	port(
		ref_clk_i	: in std_logic;
		rst_n_i		: in std_logic;
		outcore_o	: out std_logic;
		outglobal_o	: out std_logic
	);
end component;

component clock_debouncing is --slow clock to enable edboucning registers
	port (
    		clk      	: in std_logic; 
    		slow_clock	: out std_logic
    	);
end component;

component debounce_input is -- registers to debounce the buttons
	port(
	    	clk		: in std_logic;
		clock_enable	: in std_logic;
	    	input		: in std_logic_vector(3 downto 0);
	    	output		: out std_logic_vector(3 downto 0)
	);
end component;
	
component seqDetect is -- state amchine to compare input to random seq cat by cat
	port (
		clk     	: in std_logic;
		noIn		: in std_logic; --zero input
		ranSeq  	: in std_logic_vector(15 downto 0); --grabbed sequence
		input   	: in std_logic_vector(1 downto 0); --user inputted cat
		seqDone 	: in std_logic; -- sequence completed from game
		playCount 	: out unsigned(3 downto 0);
		nextRound 	: out std_logic; -- user correct seq -> go to next round
		gOver		: out std_logic -- game over , incorrect seq
	);
end component;

component playSeq is --state machine to play the random sequence out, to be put into vga top
	port (
		clk     	: in std_logic;
		counter 	: in unsigned(25 downto 0);
		nextRound 	: in std_logic;
		gameOver	: in std_logic;
		noIn		: in std_logic;
		seqDone 	: out std_logic; -- sequnece has been completed
		pause		: out std_logic;
		catOut  	: out std_logic_vector(1 downto 0); --cat that is gonna be played
		gameStart	: out std_logic;
		catSeq  	: out std_logic_vector(15 downto 0);
		yourTurnBool	: out std_logic 
	);
end component;

component converter is -- conversion of button inputs into cat codes
	port (
		userIn  	: in std_logic_vector(3 downto 0);
		userOut 	: out std_logic_vector(1 downto 0);
		noIn		: out std_logic -- an in code of 0000
	);
end component;

begin

vgaport : topVGA port map (
	fromPLL => fromPLL , 
	gameoverTrue => gameOver , 
	yourTurnBool => yourTurnBool2,
	seqDone => seqDone,
	pause=> pause,
	gameStart => gameStart,
	catOut  => catOut ,
	VSYNC => vsync , 
	HSYNC => hsync , 
	RGB => rgb
);
	
pllport : pll2 port map (
	ref_clk_i =>exOsc ,
	rst_n_i => '1' , 
	outcore_o =>PLLop ,
	outglobal_o => fromPLL
);

-- PROCESS USER IN
	
clock_enable_gen : clock_debouncing port map (
	clk => fromPLL, 
	slow_clock => slow_clk_enable
);
		
debounce_r1 : debounce_input port map (
	clk => fromPLL, 
	clock_enable => slow_clk_enable, 
	input => not buttons, 
	output => Q0
);
	
debounce_r2 : debounce_input port map (
	clk => fromPLL, 
	clock_enable => slow_clk_enable, 
	input => Q0, 
	output => Q1
);
	
debounce_r3 : debounce_input port map (
	clk => fromPLL, 
	clock_enable => slow_clk_enable, 
	input => Q1, 
	output => Q2 
);
	
debounced_buttons <=  Q2;

-- GAME LOGIC
	
cat_conv : converter port map (
	userIn => edge_detected_buttons , 
	userOut => catIn, 
	noIn => noIn
);
	
seqDetect1 : seqDetect port map (
	clk => fromPLL,
	noIn => noIn, 
	ranSeq => catSeq, 
	input => catIn, 
	seqDone => seqDone, 
	gOver => gameOver, 
	playCount => playCount, 
	nextRound => nextRound
);
	
playSeq1 : playSeq port map (
	clk => fromPLL, 
	counter => counter, 
	nextRound => nextRound, 
	seqDone => seqDone, 
	catOut => catOut, 
	catSeq => catSeq, 
	pause => pause, 
	noIn => noIn,  
	gameOver => gameOver, 
	yourTurnBool => yourTurnBool2, 
	gameStart => gameStart
);

process (fromPLL) begin
	if rising_edge(fromPLL) then
		for i in 0 to 3 loop --if there is a change in input, edge buttons qill reflecT it. on the nex clock edge, if no change, edge buttons will be 0000
			if (debounced_buttons(i) = '1' and previous_debounced_buttons(i) = '0') then
				edge_detected_buttons(i) <= '1';
			else 
				edge_detected_buttons(i) <= '0';
			end if;
		end loop;
				
		previous_debounced_buttons <= debounced_buttons;

		if (counter = "11111111111111111111111111") then --random number generation for sequence
			counter <= 26d"0";
		else
			counter <= counter + 26d"1";
		end if;	
		
	end if;
end process;
end synth;
