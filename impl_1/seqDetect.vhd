library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity seqDetect is
   port (
		  clk		: in std_logic;
		  noIn		: in std_logic;						-- no user input
		  ranSeq	: in std_logic_vector(15 downto 0); -- grabbed sequence from playSeq
		  input		: in std_logic_vector(1 downto 0);	-- user inputted cat
		  seqDone	: in std_logic;						-- sequence completed from game
		  playCount : in unsigned(3 downto 0);			-- how much of the sequence has been played
		  
		  nextRound : out std_logic;					-- user correct seq -> go to next round
		  gOver		: out std_logic := '0'				-- game over , incorrect seq
   );
end seqDetect;

architecture synth of seqDetect is
	type State is (START, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, GAMEOVER); -- i think get rid of start make it mealy fsm instead of moore
    signal cat : STATE := START;
    signal bigcounter : unsigned(24 downto 0);
	--signal prevCount : unsigned(3 downto 0) := "0000";
begin
	process (clk) is
	begin
	if rising_edge(clk) then

		case cat is
			 when START => -- beginning of round
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(15 downto 14) and noIn = '0' and seqDone = '1') then 
						   cat <= ONE; --first cat read
						   gOver <= '0';
					elsif (noIn = '0' and seqDone = '1') then -- if wrong input
						   cat <= GAMEOVER;
							gOver <= '1';
					--else
						--cat <= START;
					end if;
					nextRound <= '0';
					--cat <= START;
			 when ONE => -- when first cat has been read
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(13 downto 12) and noIn = '0') then
						   cat <= TWO;
							gOver <= '0';
					elsif (noIn = '0') then
						   cat <= GAMEOVER;
							gOver <= '1';
					end if;
					nextRound <= '0';
			 when TWO =>
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(11 downto 10) and noIn = '0') then
						   cat <= THREE;
							gOver <= '0';
					elsif (noIn = '0') then
							cat <= GAMEOVER;
							gOver <= '1';
					end if;
					nextRound <= '0';
			 when THREE =>
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(9 downto 8) and noIn = '0') then
						   cat <= FOUR;
							gOver <= '0';
					elsif (noIn = '0') then
						   cat <= GAMEOVER;
							gOver <= '1';
					end if;
					nextRound <= '0';
			 when FOUR =>
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(7 downto 6) and noIn = '0') then
						   cat <= FIVE;
							gOver <= '0';
					elsif (noIn = '0') then
						   cat <= GAMEOVER;
							gOver <= '1';
					end if;
					nextRound <= '0';
			 when FIVE =>
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(5 downto 4) and noIn = '0') then
						   cat <= SIX;
							gOver <= '0';
					elsif (noIn = '0') then
						   cat <= GAMEOVER;
							gOver <= '1';
					end if;
					nextRound <= '0';
			 when SIX =>
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(3 downto 2) and noIn = '0') then
						   cat <= SEVEN;
							gOver <= '0';
					elsif (noIn = '0') then
						   cat <= GAMEOVER;
							gOver <= '1';
					end if;
					nextRound <= '0';
			 when SEVEN =>
			   --gOver <= '0'; -- continue game
					if (input = ranSeq(1 downto 0) and noIn = '0') then
						   cat <= START;
						   nextRound <= '1';
							gOver <= '0';
					elsif (noIn = '0') then
						   cat <= GAMEOVER;
							gOver <= '1';
					end if;
			 --when ROUNDOVER =>
					--if (seqDone = '1' and playCount = 4d"0") then
						   --cat <= START;
						   --gOver <= '0';
						   --nextRound <= '0';
					--end if;
			 when GAMEOVER => -- done reading in cats
			   gOver <= '1';
					-- send a signal to vga for pab!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					if (noIn = '0') then --click anthing to go back to start
						   cat <= START;
							gOver <= '0';
					end if;
					nextRound <= '0';
			 when others => 
					cat <= START;
					gOver <= '0';
			 end case;
        end if;
      
	   
	   end process;
end synth;