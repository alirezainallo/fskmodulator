----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:51:07 01/09/2024 
-- Design Name: 
-- Module Name:    dds - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dds is
		
	 generic (
        DATA_WIDTH:  positive := 8;
        FREG_WIDTH:  positive := 14;
        CLK_FREQ  :  positive := 200
	 );
    Port ( 
		clk    : in   STD_LOGIC;
		freq   : in   unsigned(DATA_WIDTH-1 downto 0);-- 0bit,8bit,0bit
		debug  : OUT  unsigned(21 downto 0);
		sDebug : OUT  signed(FREG_WIDTH+1 downto 0)
	 );
end dds;

architecture Behavioral of dds is
    
	COMPONENT phaseStep
    PORT(
         clk  : IN  std_logic;
         freq : IN  unsigned(7 downto 0);
         PhSt : OUT  unsigned(21 downto 0)
        );
    END COMPONENT;

	signal PhSt : unsigned(21 downto 0);
	signal currentPhi: unsigned(9+FREG_WIDTH-1 downto 0):=to_unsigned(0, 9+FREG_WIDTH); -- 9bit(max:360), 14bit
	signal nextPhi   : unsigned(9+FREG_WIDTH-1 downto 0):=to_unsigned(0, 9+FREG_WIDTH); -- 9bit(max:360), 14bit
	signal currPhiInd: unsigned(8 downto 0):=to_unsigned(0, 9); -- 9bit(max:360), 14bit

	type sin_array is array(0 to 359) of signed(FREG_WIDTH+1 downto 0); -- 1bit,1bit,14bit
	constant sin_LUT: sin_array :=(
		to_signed(0,FREG_WIDTH+2), to_signed(285,FREG_WIDTH+2), to_signed(570,FREG_WIDTH+2), to_signed(857,FREG_WIDTH+2), to_signed(1142,FREG_WIDTH+2), to_signed(1427,FREG_WIDTH+2), to_signed(1712,FREG_WIDTH+2), to_signed(1996,FREG_WIDTH+2), to_signed(2279,FREG_WIDTH+2), to_signed(2562,FREG_WIDTH+2),
		to_signed(2844,FREG_WIDTH+2), to_signed(3126,FREG_WIDTH+2), to_signed(3406,FREG_WIDTH+2), to_signed(3685,FREG_WIDTH+2), to_signed(3963,FREG_WIDTH+2), to_signed(4240,FREG_WIDTH+2), to_signed(4515,FREG_WIDTH+2), to_signed(4789,FREG_WIDTH+2), to_signed(5063,FREG_WIDTH+2), to_signed(5333,FREG_WIDTH+2), to_signed(5603,FREG_WIDTH+2),
		to_signed(5870,FREG_WIDTH+2), to_signed(6137,FREG_WIDTH+2), to_signed(6401,FREG_WIDTH+2), to_signed(6663,FREG_WIDTH+2), to_signed(6924,FREG_WIDTH+2), to_signed(7181,FREG_WIDTH+2), to_signed(7437,FREG_WIDTH+2), to_signed(7691,FREG_WIDTH+2), to_signed(7943,FREG_WIDTH+2), to_signed(8192,FREG_WIDTH+2), to_signed(8438,FREG_WIDTH+2),
		to_signed(8682,FREG_WIDTH+2), to_signed(8923,FREG_WIDTH+2), to_signed(9160,FREG_WIDTH+2), to_signed(9396,FREG_WIDTH+2), to_signed(9629,FREG_WIDTH+2), to_signed(9860,FREG_WIDTH+2), to_signed(10086,FREG_WIDTH+2), to_signed(10310,FREG_WIDTH+2), to_signed(10530,FREG_WIDTH+2), to_signed(10748,FREG_WIDTH+2), to_signed(10963,FREG_WIDTH+2),
		to_signed(11172,FREG_WIDTH+2), to_signed(11380,FREG_WIDTH+2), to_signed(11585,FREG_WIDTH+2), to_signed(11785,FREG_WIDTH+2), to_signed(11982,FREG_WIDTH+2), to_signed(12175,FREG_WIDTH+2), to_signed(12365,FREG_WIDTH+2), to_signed(12550,FREG_WIDTH+2), to_signed(12732,FREG_WIDTH+2), to_signed(12911,FREG_WIDTH+2), to_signed(13084,FREG_WIDTH+2),
		to_signed(13255,FREG_WIDTH+2), to_signed(13420,FREG_WIDTH+2), to_signed(13582,FREG_WIDTH+2), to_signed(13740,FREG_WIDTH+2), to_signed(13894,FREG_WIDTH+2), to_signed(14043,FREG_WIDTH+2), to_signed(14189,FREG_WIDTH+2), to_signed(14329,FREG_WIDTH+2), to_signed(14465,FREG_WIDTH+2), to_signed(14598,FREG_WIDTH+2), to_signed(14724,FREG_WIDTH+2),
		to_signed(14849,FREG_WIDTH+2), to_signed(14967,FREG_WIDTH+2), to_signed(15081,FREG_WIDTH+2), to_signed(15190,FREG_WIDTH+2), to_signed(15294,FREG_WIDTH+2), to_signed(15394,FREG_WIDTH+2), to_signed(15491,FREG_WIDTH+2), to_signed(15581,FREG_WIDTH+2), to_signed(15668,FREG_WIDTH+2), to_signed(15748,FREG_WIDTH+2), to_signed(15825,FREG_WIDTH+2),
		to_signed(15896,FREG_WIDTH+2), to_signed(15963,FREG_WIDTH+2), to_signed(16025,FREG_WIDTH+2), to_signed(16083,FREG_WIDTH+2), to_signed(16135,FREG_WIDTH+2), to_signed(16181,FREG_WIDTH+2), to_signed(16223,FREG_WIDTH+2), to_signed(16261,FREG_WIDTH+2), to_signed(16294,FREG_WIDTH+2), to_signed(16320,FREG_WIDTH+2),
		to_signed(16343,FREG_WIDTH+2), to_signed(16361,FREG_WIDTH+2), to_signed(16373,FREG_WIDTH+2), to_signed(16381,FREG_WIDTH+2), to_signed(16384,FREG_WIDTH+2), to_signed(16381,FREG_WIDTH+2), to_signed(16373,FREG_WIDTH+2), to_signed(16361,FREG_WIDTH+2), to_signed(16343,FREG_WIDTH+2),
		to_signed(16320,FREG_WIDTH+2), to_signed(16294,FREG_WIDTH+2), to_signed(16261,FREG_WIDTH+2), to_signed(16223,FREG_WIDTH+2), to_signed(16181,FREG_WIDTH+2), to_signed(16135,FREG_WIDTH+2), to_signed(16083,FREG_WIDTH+2), to_signed(16025,FREG_WIDTH+2), to_signed(15963,FREG_WIDTH+2), to_signed(15896,FREG_WIDTH+2),
		to_signed(15825,FREG_WIDTH+2), to_signed(15748,FREG_WIDTH+2), to_signed(15668,FREG_WIDTH+2), to_signed(15581,FREG_WIDTH+2), to_signed(15491,FREG_WIDTH+2), to_signed(15394,FREG_WIDTH+2), to_signed(15294,FREG_WIDTH+2), to_signed(15190,FREG_WIDTH+2), to_signed(15081,FREG_WIDTH+2), to_signed(14967,FREG_WIDTH+2),
		to_signed(14849,FREG_WIDTH+2), to_signed(14724,FREG_WIDTH+2), to_signed(14598,FREG_WIDTH+2), to_signed(14465,FREG_WIDTH+2), to_signed(14329,FREG_WIDTH+2), to_signed(14189,FREG_WIDTH+2), to_signed(14043,FREG_WIDTH+2), to_signed(13894,FREG_WIDTH+2), to_signed(13740,FREG_WIDTH+2), to_signed(13582,FREG_WIDTH+2),
		to_signed(13420,FREG_WIDTH+2), to_signed(13255,FREG_WIDTH+2), to_signed(13084,FREG_WIDTH+2), to_signed(12911,FREG_WIDTH+2), to_signed(12732,FREG_WIDTH+2), to_signed(12550,FREG_WIDTH+2), to_signed(12365,FREG_WIDTH+2), to_signed(12175,FREG_WIDTH+2), to_signed(11982,FREG_WIDTH+2), to_signed(11785,FREG_WIDTH+2),
		to_signed(11585,FREG_WIDTH+2), to_signed(11380,FREG_WIDTH+2), to_signed(11172,FREG_WIDTH+2), to_signed(10963,FREG_WIDTH+2), to_signed(10748,FREG_WIDTH+2), to_signed(10530,FREG_WIDTH+2), to_signed(10310,FREG_WIDTH+2), to_signed(10086,FREG_WIDTH+2), to_signed(9860,FREG_WIDTH+2), to_signed(9629,FREG_WIDTH+2),
		to_signed(9396,FREG_WIDTH+2), to_signed(9160,FREG_WIDTH+2), to_signed(8923,FREG_WIDTH+2), to_signed(8682,FREG_WIDTH+2), to_signed(8438,FREG_WIDTH+2), to_signed(8192,FREG_WIDTH+2), to_signed(7943,FREG_WIDTH+2), to_signed(7691,FREG_WIDTH+2), to_signed(7437,FREG_WIDTH+2), to_signed(7181,FREG_WIDTH+2),
		to_signed(6924,FREG_WIDTH+2), to_signed(6663,FREG_WIDTH+2), to_signed(6401,FREG_WIDTH+2), to_signed(6137,FREG_WIDTH+2), to_signed(5870,FREG_WIDTH+2), to_signed(5603,FREG_WIDTH+2), to_signed(5333,FREG_WIDTH+2), to_signed(5063,FREG_WIDTH+2), to_signed(4789,FREG_WIDTH+2), to_signed(4515,FREG_WIDTH+2),
		to_signed(4240,FREG_WIDTH+2), to_signed(3963,FREG_WIDTH+2), to_signed(3685,FREG_WIDTH+2), to_signed(3406,FREG_WIDTH+2), to_signed(3126,FREG_WIDTH+2), to_signed(2844,FREG_WIDTH+2), to_signed(2562,FREG_WIDTH+2), to_signed(2279,FREG_WIDTH+2), to_signed(1996,FREG_WIDTH+2), to_signed(1712,FREG_WIDTH+2),
		to_signed(1427,FREG_WIDTH+2), to_signed(1142,FREG_WIDTH+2), to_signed(857,FREG_WIDTH+2), to_signed(570,FREG_WIDTH+2), to_signed(285,FREG_WIDTH+2), to_signed(0,FREG_WIDTH+2), to_signed(-285,FREG_WIDTH+2), to_signed(-570,FREG_WIDTH+2), to_signed(-857,FREG_WIDTH+2), to_signed(-1142,FREG_WIDTH+2),
		to_signed(-1427,FREG_WIDTH+2), to_signed(-1712,FREG_WIDTH+2), to_signed(-1996,FREG_WIDTH+2), to_signed(-2279,FREG_WIDTH+2), to_signed(-2562,FREG_WIDTH+2), to_signed(-2844,FREG_WIDTH+2), to_signed(-3126,FREG_WIDTH+2), to_signed(-3406,FREG_WIDTH+2), to_signed(-3685,FREG_WIDTH+2), to_signed(-3963,FREG_WIDTH+2),
		to_signed(-4240,FREG_WIDTH+2), to_signed(-4515,FREG_WIDTH+2), to_signed(-4789,FREG_WIDTH+2), to_signed(-5063,FREG_WIDTH+2), to_signed(-5333,FREG_WIDTH+2), to_signed(-5603,FREG_WIDTH+2), to_signed(-5870,FREG_WIDTH+2), to_signed(-6137,FREG_WIDTH+2), to_signed(-6401,FREG_WIDTH+2), to_signed(-6663,FREG_WIDTH+2),
		to_signed(-6924,FREG_WIDTH+2), to_signed(-7181,FREG_WIDTH+2), to_signed(-7437,FREG_WIDTH+2), to_signed(-7691,FREG_WIDTH+2), to_signed(-7943,FREG_WIDTH+2), to_signed(-8192,FREG_WIDTH+2), to_signed(-8438,FREG_WIDTH+2), to_signed(-8682,FREG_WIDTH+2), to_signed(-8923,FREG_WIDTH+2), to_signed(-9160,FREG_WIDTH+2),
		to_signed(-9396,FREG_WIDTH+2), to_signed(-9629,FREG_WIDTH+2), to_signed(-9860,FREG_WIDTH+2), to_signed(-10086,FREG_WIDTH+2), to_signed(-10310,FREG_WIDTH+2), to_signed(-10530,FREG_WIDTH+2), to_signed(-10748,FREG_WIDTH+2), to_signed(-10963,FREG_WIDTH+2), to_signed(-11172,FREG_WIDTH+2), to_signed(-11380,FREG_WIDTH+2),
		to_signed(-11585,FREG_WIDTH+2), to_signed(-11785,FREG_WIDTH+2), to_signed(-11982,FREG_WIDTH+2), to_signed(-12175,FREG_WIDTH+2), to_signed(-12365,FREG_WIDTH+2), to_signed(-12550,FREG_WIDTH+2), to_signed(-12732,FREG_WIDTH+2), to_signed(-12911,FREG_WIDTH+2), to_signed(-13084,FREG_WIDTH+2), to_signed(-13255,FREG_WIDTH+2),
		to_signed(-13420,FREG_WIDTH+2), to_signed(-13582,FREG_WIDTH+2), to_signed(-13740,FREG_WIDTH+2), to_signed(-13894,FREG_WIDTH+2), to_signed(-14043,FREG_WIDTH+2), to_signed(-14189,FREG_WIDTH+2), to_signed(-14329,FREG_WIDTH+2), to_signed(-14465,FREG_WIDTH+2), to_signed(-14598,FREG_WIDTH+2), to_signed(-14724,FREG_WIDTH+2),
		to_signed(-14849,FREG_WIDTH+2), to_signed(-14967,FREG_WIDTH+2), to_signed(-15081,FREG_WIDTH+2), to_signed(-15190,FREG_WIDTH+2), to_signed(-15294,FREG_WIDTH+2), to_signed(-15394,FREG_WIDTH+2), to_signed(-15491,FREG_WIDTH+2), to_signed(-15581,FREG_WIDTH+2), to_signed(-15668,FREG_WIDTH+2), to_signed(-15748,FREG_WIDTH+2),
		to_signed(-15825,FREG_WIDTH+2), to_signed(-15896,FREG_WIDTH+2), to_signed(-15963,FREG_WIDTH+2), to_signed(-16025,FREG_WIDTH+2), to_signed(-16083,FREG_WIDTH+2), to_signed(-16135,FREG_WIDTH+2), to_signed(-16181,FREG_WIDTH+2), to_signed(-16223,FREG_WIDTH+2), to_signed(-16261,FREG_WIDTH+2), to_signed(-16294,FREG_WIDTH+2),
		to_signed(-16320,FREG_WIDTH+2), to_signed(-16343,FREG_WIDTH+2), to_signed(-16361,FREG_WIDTH+2), to_signed(-16373,FREG_WIDTH+2), to_signed(-16381,FREG_WIDTH+2), to_signed(-16384,FREG_WIDTH+2), to_signed(-16381,FREG_WIDTH+2), to_signed(-16373,FREG_WIDTH+2), to_signed(-16361,FREG_WIDTH+2), to_signed(-16343,FREG_WIDTH+2),
		to_signed(-16320,FREG_WIDTH+2), to_signed(-16294,FREG_WIDTH+2), to_signed(-16261,FREG_WIDTH+2), to_signed(-16223,FREG_WIDTH+2), to_signed(-16181,FREG_WIDTH+2), to_signed(-16135,FREG_WIDTH+2), to_signed(-16083,FREG_WIDTH+2), to_signed(-16025,FREG_WIDTH+2), to_signed(-15963,FREG_WIDTH+2), to_signed(-15896,FREG_WIDTH+2),
		to_signed(-15825,FREG_WIDTH+2), to_signed(-15748,FREG_WIDTH+2), to_signed(-15668,FREG_WIDTH+2), to_signed(-15581,FREG_WIDTH+2), to_signed(-15491,FREG_WIDTH+2), to_signed(-15394,FREG_WIDTH+2), to_signed(-15294,FREG_WIDTH+2), to_signed(-15190,FREG_WIDTH+2), to_signed(-15081,FREG_WIDTH+2), to_signed(-14967,FREG_WIDTH+2),
		to_signed(-14849,FREG_WIDTH+2), to_signed(-14724,FREG_WIDTH+2), to_signed(-14598,FREG_WIDTH+2), to_signed(-14465,FREG_WIDTH+2), to_signed(-14329,FREG_WIDTH+2), to_signed(-14189,FREG_WIDTH+2), to_signed(-14043,FREG_WIDTH+2), to_signed(-13894,FREG_WIDTH+2), to_signed(-13740,FREG_WIDTH+2), to_signed(-13582,FREG_WIDTH+2),
		to_signed(-13420,FREG_WIDTH+2), to_signed(-13255,FREG_WIDTH+2), to_signed(-13084,FREG_WIDTH+2), to_signed(-12911,FREG_WIDTH+2), to_signed(-12732,FREG_WIDTH+2), to_signed(-12550,FREG_WIDTH+2), to_signed(-12365,FREG_WIDTH+2), to_signed(-12175,FREG_WIDTH+2), to_signed(-11982,FREG_WIDTH+2), to_signed(-11785,FREG_WIDTH+2),
		to_signed(-11585,FREG_WIDTH+2), to_signed(-11380,FREG_WIDTH+2), to_signed(-11172,FREG_WIDTH+2), to_signed(-10963,FREG_WIDTH+2), to_signed(-10748,FREG_WIDTH+2), to_signed(-10530,FREG_WIDTH+2), to_signed(-10310,FREG_WIDTH+2), to_signed(-10086,FREG_WIDTH+2), to_signed(-9860,FREG_WIDTH+2), to_signed(-9629,FREG_WIDTH+2),
		to_signed(-9396,FREG_WIDTH+2), to_signed(-9160,FREG_WIDTH+2), to_signed(-8923,FREG_WIDTH+2), to_signed(-8682,FREG_WIDTH+2), to_signed(-8438,FREG_WIDTH+2), to_signed(-8192,FREG_WIDTH+2), to_signed(-7943,FREG_WIDTH+2), to_signed(-7691,FREG_WIDTH+2), to_signed(-7437,FREG_WIDTH+2), to_signed(-7181,FREG_WIDTH+2),
		to_signed(-6924,FREG_WIDTH+2), to_signed(-6663,FREG_WIDTH+2), to_signed(-6401,FREG_WIDTH+2), to_signed(-6137,FREG_WIDTH+2), to_signed(-5870,FREG_WIDTH+2), to_signed(-5603,FREG_WIDTH+2), to_signed(-5333,FREG_WIDTH+2), to_signed(-5063,FREG_WIDTH+2), to_signed(-4789,FREG_WIDTH+2), to_signed(-4515,FREG_WIDTH+2),
		to_signed(-4240,FREG_WIDTH+2), to_signed(-3963,FREG_WIDTH+2), to_signed(-3685,FREG_WIDTH+2), to_signed(-3406,FREG_WIDTH+2), to_signed(-3126,FREG_WIDTH+2), to_signed(-2844,FREG_WIDTH+2), to_signed(-2562,FREG_WIDTH+2), to_signed(-2279,FREG_WIDTH+2), to_signed(-1996,FREG_WIDTH+2), to_signed(-1712,FREG_WIDTH+2),
		to_signed(-1427,FREG_WIDTH+2), to_signed(-1142,FREG_WIDTH+2), to_signed(-857,FREG_WIDTH+2), to_signed(-570,FREG_WIDTH+2), to_signed(-285,FREG_WIDTH+2)
	);
begin

	Inst_PhSt: phaseStep PORT MAP (
         clk  => clk,
         freq => freq,
         PhSt => PhSt
        );
	
	-- prepare phi index
	currPhiInd <= currentPhi(9+FREG_WIDTH-1 downto FREG_WIDTH);
	debug  <= resize(currPhiInd, 22);
	sDebug <= sin_LUT(to_integer(currPhiInd));
	process(clk)
	variable deg360:  unsigned(9+FREG_WIDTH-1 downto 0):=to_unsigned(5898240,9+FREG_WIDTH);
	begin
		if rising_edge(clk) then
			 nextPhi    <= currentPhi+resize(PhSt, 9+FREG_WIDTH)+resize(PhSt, 9+FREG_WIDTH);
			 currentPhi <= currentPhi+resize(PhSt, 9+FREG_WIDTH);
			 if(nextPhi > deg360) then
				currentPhi <= to_unsigned(0, 9+FREG_WIDTH);
				nextPhi    <= resize(PhSt, 9+FREG_WIDTH);
			 end if;
			 
			 
		end if;
	end process;

end Behavioral;

