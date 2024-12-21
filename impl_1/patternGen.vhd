library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity patternGen is
	port(
		pGclk : in std_logic; --25MHz
		valid : in std_logic; --vga VALID
		row : in unsigned(9 downto 0); --row ADDR
		col : in unsigned (9 downto 0); --col ADDR
		
		startTrue	: in std_logic; --start screen
		yourTurnBool : in std_logic; --your turn screen
		gameoverTrue : in std_logic; --game over screen
		gameStart	: in std_logic; --game start screen
		seqDone : in std_logic; --sequnece has been completed
		pause	: in std_logic; --cat pause
		catOut  : in std_logic_vector(1 downto 0); --cat randomly generated 
		RGBout : out unsigned (5 downto 0) --RGB bits
	);
end patternGen;

architecture synth of patternGen is

signal RGBsig : unsigned(5 downto 0);
signal address: unsigned(14 downto 0); 
signal scaled_row : unsigned(6 downto 0);
signal scaled_col : unsigned(7 downto 0);

signal startRGB : unsigned(5 downto 0);
signal startArrowRGB : unsigned(5 downto 0);
signal rulesArrowRGB : unsigned(5 downto 0);
signal meow1RGB : unsigned(5 downto 0);
signal meow2RGB : unsigned(5 downto 0);
signal meow3RGB : unsigned(5 downto 0);
signal meow4RGB : unsigned(5 downto 0);
signal pabRGB : unsigned(5 downto 0);
signal gameoverRGB : unsigned(5 downto 0);
signal oneRGB : unsigned(5 downto 0); 
signal twoRGB : unsigned(5 downto 0);
signal threeRGB : unsigned(5 downto 0);
signal yourturnRGB : unsigned(5 downto 0); 
signal timerRGB : unsigned(5 downto 0); 

signal zilchrgb : unsigned(5 downto 0);
signal onesmallRGB : unsigned(5 downto 0);
signal twosmallRGB : unsigned(5 downto 0);
signal threesmallRGB : unsigned(5 downto 0);
signal fourRGB : unsigned(5 downto 0);
signal fiveRGB : unsigned(5 downto 0);
signal sixRGB : unsigned(5 downto 0);
signal sevenRGB : unsigned(5 downto 0);
signal eightRGB : unsigned(5 downto 0);
signal nineRGB : unsigned(5 downto 0);
signal numRGB : unsigned(5 downto 0);

signal meow1true : std_logic;
signal meow2true : std_logic;
signal meow3true : std_logic;
signal meow4true : std_logic;

signal zerotrue : std_logic;
signal onesmalltrue : std_logic;
signal twosmalltrue : std_logic;
signal threesmalltrue : std_logic;
signal fourtrue : std_logic;
signal fivetrue : std_logic;
signal sixtrue : std_logic;
signal seventrue : std_logic;
signal eighttrue : std_logic;
signal ninetrue : std_logic;

signal stateout : std_logic_vector(3 downto 0); 
signal colout : unsigned(7 downto 0); 
signal zerocoladdr : unsigned(7 downto 0);
signal zerorowaddr : unsigned(6 downto 0);
signal zerorowsig : unsigned(6 downto 0);
signal zerocolsig : unsigned(7 downto 0);
signal zerorowmove : unsigned(6 downto 0);
signal zerocolmove : unsigned(7 downto 0);
signal fourcoladdr : unsigned(7 downto 0);
signal fourrowaddr : unsigned(6 downto 0);

signal adderZero : unsigned(14 downto 0);

--added just so that it synthesizes
signal ruleTrue : std_logic := '0';

component romBg is
	port(
		clk : in std_logic;
		address: in unsigned(14 downto 0);
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component startScreen is 
	port( 
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component startArrow is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component meow1 is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component meow2 is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component meow3 is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component meow4 is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component pab is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;
	
component gameover is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;

component yourturn is 
	port(
		clk : in std_logic;
		address : in unsigned (14 downto 0); 
		rgb : out unsigned(5 downto 0)
	);
end component;


begin

scaled_row <= row(8 downto 2); 
scaled_col <= col(9 downto 2);
-- Combine scaled row and column into a single address (15 bits total)

process(pGclk) 
begin
	if rising_edge(pGclk)  then
		address <= scaled_row & scaled_col;
	end if;
end process;
	romBgport : romBg port map (
		clk => pGclk , 
		address => address , 
		rgb => RGBsig
	);
	startport : startScreen port map(
		clk => pGclk , 
		address => address ,
		rgb => startRGB
	);
	startarrowport : startArrow port map(
		clk => pGclk , 
		address => address ,
		rgb => startArrowRGB
	);
	meow1port : meow1 port map(
		clk => pGclk , 
		address => address ,
		rgb => meow1RGB
	);
	meow2port : meow2 port map(
		clk => pGclk , 
		address => address ,
		rgb => meow2RGB
	);
	meow3port : meow3 port map(
		clk => pGclk , 
		address => address ,
		rgb => meow3RGB
	);
	meow4port : meow4 port map(
		clk => pGclk , 
		address => address ,
		rgb => meow4RGB
	);
	pabport : pab port map(
		clk => pGclk , 
		address => address ,
		rgb => pabRGB
	);
	gameoverPort : gameover port map(
		clk => pGclk , 
		address => address ,
		rgb => gameoverRGB
	);
	yourturnport : yourturn port map(
		clk => pGclk , 
		address => address ,
		rgb => yourturnRGB
	);

	meow1True <= '1' when catOut = "00" and pause = '0' else '0';
	meow2True <= '1' when catOut = "01" and pause = '0' else '0';
	meow3True <= '1' when catOut = "10" and pause = '0' else '0';
	meow4True <= '1' when catOut = "11" and pause = '0' else '0';

	
	RGBout <= "000000" when (rulez = "000000" and valid = '1' and ruleTrue = '1') else
	
			"000000" when (startRGB = "000000" and valid = '1' and gameStart = '1') else
			"100110" when (startRGB = "100110" and valid = '1' and gameStart = '1') else
			"000000" when (startArrowRGB = "000000" and valid = '1' and gameStart = '1') else
			
			"000000" when (gameoverRGB = "000000" and valid = '1' and gameoverTrue = '1' ) else
			"100110" when (gameoverRGB = "100110" and valid = '1' and gameoverTrue = '1' ) else
	
			"000000" when (yourturnRGB = "000000" and valid = '1' and yourTurnBool = '1') else
			"100110" when (yourturnRGB = "100110" and valid = '1' and yourTurnBool = '1') else
			
			"000000" when (meow1RGB = "000000" and valid = '1' and meow1True = '1') else
			"111111" when (meow1rgb = "111111" and valid = '1' and meow1True = '1') else
			"000000" when (meow2RGB = "000000" and valid = '1' and meow2True = '1') else
			"111111" when (meow2rgb = "111111" and valid = '1' and meow2True = '1') else
			"000000" when (meow3RGB = "000000" and valid = '1' and meow3True = '1') else
			"111111" when (meow3rgb = "111111" and valid = '1' and meow3True = '1') else
			"000000" when (meow4RGB = "000000" and valid = '1' and meow4True = '1') else
			"111111" when (meow4rgb = "111111" and valid = '1' and meow4True = '1') else
			
			"000000" when (pabRGB = "000000" and valid = '1' and gameoverTrue = '1') else

			
			RGBsig when valid = '1' else
			"000000";
end;
