library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.conv_integer;
use IEEE.numeric_std.all;

entity cpld_kbd is
port (
	CLK	     : in std_logic;

	AVR_MOSI    : in std_logic;
	AVR_MISO    : out std_logic;
	AVR_SCK     : in std_logic;
	AVR_SS      : in std_logic;
			
	RESET		: out std_logic := '0';
	SCANLINES  : out std_logic := '0';
	 
	L_PADDLE   : out std_logic_vector(2 downto 0); -- up, down, start - Q,A,S
	R_PADDLE 	: out std_logic_vector(2 downto 0) -- up, down, start - P,L,M
);
end cpld_kbd;

architecture RTL of cpld_kbd is

	 signal kb_data : std_logic_vector(5 downto 0) := "000000";
	 signal rst : std_logic := '0';
	 signal space : std_logic := '0';
	 
	 -- joy state
	 signal joy : std_logic_vector(4 downto 0) := (others => '0');

	 -- spi
	 signal spi_do_valid : std_logic := '0';
	 signal spi_do : std_logic_vector(15 downto 0);
	 
begin

U_SPI: entity work.spi_slave
    generic map(
        N              => 16 -- 2 bytes (cmd + data)       
    )
    port map(
        clk_i          => CLK,
        spi_sck_i      => AVR_SCK,
        spi_ssel_i     => AVR_SS,
        spi_mosi_i     => AVR_MOSI,
        spi_miso_o     => AVR_MISO,

        di_req_o       => open,
        di_i           => open,
        wren_i         => '0',
        do_valid_o     => spi_do_valid,
        do_o           => spi_do,

        do_transfer_o  => open,
        wren_o         => open,
        wren_ack_o     => open,
        rx_bit_reg_o   => open,
        state_dbg_o    => open
        );


		  
process (CLK, spi_do_valid, spi_do)
begin
	if (rising_edge(CLK)) then
		if spi_do_valid = '1' then
			case spi_do(15 downto 8) is 
				-- short keyboard matrix
				when X"01" => kb_data(5) <= spi_do(2); -- Q
								  kb_data(4) <= spi_do(1); -- A 
								  kb_data(2) <= spi_do(5); -- P
								  space <= spi_do(7);
				when X"02" => kb_data(3) <= spi_do(1); -- S
								  kb_data(1) <= spi_do(6); -- L
				when X"03" => kb_data(0) <= spi_do(7); -- M
				when X"06" => rst <= spi_do(0); 
								  scanlines <= spi_do(1); 
								  -- 2 - magic
								  joy(0) <= not spi_do(7); -- right
								  joy(1) <= not spi_do(6); -- left
								  joy(2) <= not spi_do(5); -- down
								  joy(3) <= not spi_do(4); -- up
								  joy(4) <= not spi_do(3); -- fire
				when others => null;
			end case;
		end if;
	end if;
end process;

--    
process( kb_data, rst)
begin
	RESET <= rst or space or joy(4); -- ctrl+alt+del or space or joy fire
	L_PADDLE <= kb_data(5 downto 3); -- Q,A,S
	R_PADDLE <= (kb_data(2) or joy(3)) & (kb_data(1) or joy(2)) & (kb_data(0) or joy(4)); --P,L,M or joy up, joy down, joy fire
	--R_PADDLE <= kb_data(2 downto 0); -- P,L,M 
end process;

end RTL;

