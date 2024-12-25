library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity playSeq is
        port (
                clk     	: in std_logic;
		counter 	: in unsigned(25 downto 0); 		-- counter passed in to randomize the sequence
		nextRound	: in std_logic;				-- user plays the correct sequence -> move onto the next sequence
		gameOver	: in std_logic;
		noIn		: in std_logic; 			-- no user input
		seqDone		: out std_logic; 			-- sequence from game has been completed
		pause		: out std_logic; 			-- in pause state
                catOut  	: out std_logic_vector(1 downto 0); 	-- cat that is gonna be displayed on VGA
		catSeq  	: out std_logic_vector(15 downto 0); 	-- randomized sequence to be passed to seqDetect
		gameStart	: out std_logic; 			
		yourTurnBool	: out std_logic 
				
        );
end playSeq;

architecture synth of playSeq is
	
        type State is (START, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, DONE, YOURTURN, PAUSED, GAMEOVAH);
        signal cat : STATE := ONE;
        signal bigcounter : unsigned(24 downto 0);
	signal ranSeqLong : std_logic_vector(25 downto 0);
	signal ranSeq : std_logic_vector(15 downto 0);
	signal playCount : unsigned(3 downto 0) := "0000";
	
begin
ranSeqLong <= std_logic_vector(counter + counter mod 16d"16");
	process (clk) is begin
        if rising_edge(clk) then
		ranSeq <= (ranSeqLong(0) xor ranSeqLong(15)) & ranSeqLong(15 downto 1);
			case cat is
				when START =>
					gameStart <= '1';
					pause <= '1';
						if (noIn = '0') then
							playCount <= 4d"0";
							seqDone <= '0';
							pause <= '1';
							yourTurnBool <= '0';
							cat <= ONE;
						end if;
					when ONE =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							catOut <= ranSeq(15 downto 14);
							catSeq(15 downto 14) <= ranSeq(15 downto 14);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when TWO =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(13 downto 12);
							catSeq(13 downto 12) <= ranSeq(13 downto 12);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when THREE =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(11 downto 10);
							catSeq(11 downto 10) <= ranSeq(11 downto 10);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when FOUR =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(9 downto 8);
							catSeq(9 downto 8) <= ranSeq(9 downto 8);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when FIVE =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(7 downto 6);
							catSeq(7 downto 6) <= ranSeq(7 downto 6);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when SIX =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(5 downto 4);
							catSeq(5 downto 4) <= ranSeq(5 downto 4);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when SEVEN =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(3 downto 2);
							catSeq(3 downto 2) <= ranSeq(3 downto 2);
							playCount <= playCount + 1;
							seqDone <= '0';
							pause <= '0';
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when DONE =>
						if (bigcounter = 20000000) then
							bigcounter <= 25d"0";
							gameStart <= '0';
							yourTurnBool <= '0';
							catOut <= ranSeq(1 downto 0);
							catSeq(1 downto 0) <= ranSeq(1 downto 0);
							seqDone <= '0';
							pause <= '0';
							playCount <= playCount + 1;
							cat <= PAUSED;
						else
							bigcounter <= bigcounter + 1;
						end if;
					when YOURTURN =>
						if (nextRound = '1') then --click anthing to go back to start
							yourTurnBool <= '0';
							gameStart <= '0';
							pause <= '0';
							playCount <= 4d"0";
							seqDone <= '0';
							cat <= PAUSED;
						elsif (gameOver = '1') then 
							gameStart <= '0';
							yourTurnBool <= '0';
							seqDone <= '0';
							playCount <= 4d"0";
							pause <= '0';
							cat <= GAMEOVAH;
						end if;
					when PAUSED => 
						if (bigcounter = 20000000) then
							gameStart <= '0';
							bigcounter <= 25d"0";
						if (playCount = 0) then
							pause <= '1';
							cat <= ONE;
							yourTurnBool <= '0';
						elsif(playCount = 1) then 
							pause <= '1';
							cat <= TWO;
						elsif(playCount = 2)then
							pause <= '1';
							cat <= THREE;
						elsif(playCount = 3) then
							pause <= '1';
							cat <= FOUR;	
						elsif(playCount = 4) then
							pause <= '1';
							cat <= FIVE;
						elsif(playCount = 5) then
							pause <= '1';
							cat <= SIX;
						elsif(playCount = 6) then
							pause <= '1';
							cat <= SEVEN;
						elsif(playCount = 7) then
							pause <= '1';
							cat <= DONE;
						elsif(playCount = 8) then
							pause <= '1';
							seqDone <= '1';
							yourTurnBool <= '1';
							cat <= YOURTURN;
						end if;
					else
						bigcounter <= bigcounter + 1;
					end if;
					when GAMEOVAH =>
						gameStart <= '0';
						if (noIn = '0') then
							cat <= START;
						end if;
					when others =>
						seqDone <= '0';
						cat <= ONE;
						yourTurnBool <= '0';
						gameStart <= '0';
					end case;
        end if;
        end process;
		
end synth;
