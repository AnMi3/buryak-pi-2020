-- --------------------------------------------------------------------
-- Buriak-Pi Pong firmware
-- v1.0
-- (c) 2020 Andy Karpov
-- --------------------------------------------------------------------

library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all; 

entity firmware_top is
	port(
		-- Clock
		CLK28				: in std_logic;

		-- CPU signals
		CLK_CPU			: out std_logic := '1';
		N_RESET			: inout std_logic := 'Z';
		N_INT				: out std_logic := '1';
		N_RD				: in std_logic;
		N_WR				: in std_logic;
		N_IORQ			: in std_logic;
		N_MREQ			: in std_logic;
		N_M1				: in std_logic;
		A					: in std_logic_vector(15 downto 0);
		D 					: inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";
		N_NMI 			: out std_logic := 'Z';
		N_WAIT 			: out std_logic := 'Z';
		
		-- RAM 
		MA 				: out std_logic_vector(20 downto 0);
		MD 				: inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";
		N_MRD				: out std_logic := '1';
		N_MWR				: out std_logic := '1';
		
		-- VRAM 
		VA					: out std_logic_vector(14 downto 0);
		VD 				: inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";
		N_VWE 			: out std_logic := '1';

		-- ROM
		N_ROMCS			: out std_logic := '1';
		N_ROMWE			: out std_logic := '1';
		ROM_A 			: out std_logic_vector(15 downto 14) := "00";
		
		-- VGA Video
		VGA_VSYNC    		: out std_logic := '1';
		VGA_HSYNC 			: out std_logic := '1';
		VGA_R       		: out std_logic_vector(1 downto 0) := "ZZ";
		VGA_G       		: out std_logic_vector(1 downto 0) := "ZZ";
		VGA_B       		: out std_logic_vector(1 downto 0) := "ZZ";

		-- Interfaces 
		BEEPER			: out std_logic := '1';

		-- AY
		AY_BC1			: out std_logic;
		AY_BDIR			: out std_logic;

		-- SD card
		SD_CLK 			: out std_logic := '0';
		SD_DI 			: out std_logic;
		SD_DO 			: in std_logic;
		N_SD_CS 			: out std_logic := '1';
		SD_DETECT		: in std_logic;
		
		-- Keyboard Atmega
		KEY_SCK 			: in std_logic;
		KEY_SS 			: in std_logic;
		KEY_MOSI 		: in std_logic;
		KEY_MISO 		: out std_logic;
		
		-- Other in signals
		N_BTN_NMI		: in std_logic := '1';
		N_BTN_RESET 	: in std_logic := '1'
	);
end firmware_top;

architecture rtl of firmware_top is

-- Keyboard
signal kb_l_paddle	: std_logic_vector(2 downto 0);
signal kb_r_paddle	: std_logic_vector(2 downto 0);
signal kb_reset 		: std_logic := '0';
signal kb_scanlines  : std_logic := '0';
signal kb_pause 		: std_logic := '0';

-- System
signal reset			: std_logic := '0';

-- Sound 
signal speaker 		: std_logic;

-- Game 
signal pix_div 		: std_logic_vector(3 downto 0) := "0000";
signal dummyclk 		: std_logic := '0';
signal pixtick 		: std_logic;

signal l_human 		: std_logic := '0';
signal l_move 			: std_logic_vector(1 downto 0) := "00";
signal r_human 		: std_logic := '0';
signal r_move 			: std_logic_vector(1 downto 0) := "00";

signal prev_vsync 	: std_logic := '1';

signal hsync 			: std_logic;
signal vsync 			: std_logic;
signal csync 			: std_logic;
signal ball 			: std_logic;
signal left_bat 		: std_logic;
signal right_bat 		: std_logic;
signal field_and_score : std_logic;
signal sound 			: std_logic;
signal sel 				: std_logic_vector(3 downto 0) := "0000";
signal rgb 				: std_logic_vector(5 downto 0) := "000000";

component tennis
port (
	glb_clk				: in std_logic;
	pixtick				: in std_logic;
	reset					: in std_logic;
	lbat_human			: in std_logic;
	lbat_move			: in std_logic_vector(8 downto 0);
	rbat_human			: in std_logic;
	rbat_move			: in std_logic_vector(8 downto 0);
	tv_mode 				: in std_logic;
	scanlines 			: in std_logic;
	pause 				: in std_logic;
	
	hsync					: out std_logic;
	vsync					: out std_logic;
	csync					: out std_logic;
	
	ball					: out std_logic;
	left_bat				: out std_logic;
	right_bat			: out std_logic;
	field_and_score 	: out std_logic;
	sound 				: out std_logic);
end component;

begin

	-------------------------------------------------------------------------------
-- AVR keyboard

U2: entity work.cpld_kbd
port map (
	 CLK 				=> CLK28,

    AVR_MOSI		=> KEY_MOSI,
    AVR_MISO		=> KEY_MISO,
    AVR_SCK			=> KEY_SCK,
	 AVR_SS 			=> KEY_SS,
	 
	 RESET 			=> kb_reset,
	 SCANLINES 		=> kb_scanlines,
	 PAUSE 			=> kb_pause,
	 
	 L_PADDLE 		=> kb_l_paddle,
	 R_PADDLE 		=> kb_r_paddle);

-------------------------------------------------------------------------------
-- game logic

U4: tennis 
port map (
	glb_clk 			=> CLK28,
	pixtick 			=> pixtick,
	reset 			=> reset,
	lbat_human 		=> l_human,
	lbat_move 		=> l_move(1) & l_move(1) & l_move(1) & l_move(1) & l_move(1) & l_move(1) & l_move(0) & "00",
	rbat_human 		=> r_human,
	rbat_move 		=> r_move(1) & r_move(1) & r_move(1) & r_move(1) & r_move(1) & r_move(1) & r_move(0) & "00",
	tv_mode 			=> '0',
	scanlines 		=> kb_scanlines,
	pause 			=> kb_pause,
	hsync 			=> hsync, 
	vsync 			=> vsync,
	csync 			=> open,
	ball 				=> ball,
	left_bat 		=> left_bat,
	right_bat 		=> right_bat,
	field_and_score => field_and_score,
	sound 			=> sound);
	
-------------------------------------------------------------------------------
-- Global signals

reset <= kb_reset; -- hot reset

-------------------------------------------------------------------------------
-- Disabled hw

CLK_CPU <= '1';
N_RESET <= '0';
D <= (others => 'Z');
N_MRD <= '1';
N_MWR <= '1';
MD <= (others => 'Z');
VD <= (others => 'Z');
N_VWE <= '1';
N_ROMCS <= '1';
N_ROMWE <= '1';
N_SD_CS <= '1';

-------------------------------------------------------------------------------
-- Game

process (CLK28)
begin 
	if rising_edge(CLK28) then 
		if pixtick = '1' then 
			pix_div <= "0000";
			dummyclk <= not dummyclk;
		else 
			pix_div <= pix_div + 1;
		end if;
	end if;
end process;

pixtick <= '1' when  pix_div="0100" else '0';
sel <= ball & left_bat & right_bat & field_and_score;

process (CLK28)
begin 
	if rising_edge(CLK28) then 
		if pixtick = '1' then 
			case sel is 
				when "1000" => rgb <= "111111";
				when "0100" => rgb <= "001111";
				when "0010" => rgb <= "111100";
				when "0001" => rgb <= "001100";
				when others => rgb <= "000000";
			end case;
			VGA_HSYNC <= hsync;
			VGA_VSYNC <= vsync;
			BEEPER <= sound;
		end if;
	end if;
end process;

VGA_R <= rgb(5 downto 4);
VGA_G <= rgb(3 downto 2);
VGA_B <= rgb(1 downto 0);

process (CLK28, reset)
begin 
	if reset = '1' then 
		l_human <= '0';
		l_move <= (others => '0');
	elsif rising_edge(CLK28) then 
		if (kb_l_paddle(2)='1' or kb_l_paddle(1) = '1') then 
			l_human <= '1';
		end if;
		l_move <= (not(kb_l_paddle(2)) and kb_l_paddle(1)) & (kb_l_paddle(2) xor kb_l_paddle(1));
	end if;
end process;

process (CLK28, reset)
begin 
	if reset = '1' then 
		r_human <= '0';
		r_move <= (others => '0');
	elsif rising_edge(CLK28) then 
		if (kb_r_paddle(2)='1' or kb_r_paddle(1) = '1') then 
			r_human <= '1';
		end if;
		r_move <= (not(kb_r_paddle(2)) and kb_r_paddle(1)) & (kb_r_paddle(2) xor kb_r_paddle(1));
	end if;
end process;
	
end;
