----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:07:49 01/09/2024 
-- Design Name: 
-- Module Name:    DDS - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using 
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code. 
--library UNISIM;
--use UNISIM.VComponents.all;

entity myDDS is
	 generic (
        DATA_WIDTH:  positive := 8;
        FREG_WIDTH:  positive := 14;
        CLK_FREQ  :  positive := 200
	 );
    Port (
        clk     : in   STD_LOGIC;
        freq    : in   unsigned(DATA_WIDTH-1 downto 0);-- 0bit,8bit,0bit
        PhSt    : out  unsigned(DATA_WIDTH+FREG_WIDTH-1 downto 0):=to_unsigned(0,22) -- 0bit,8bit,14bit
    );
end entity myDDS;


architecture Behavioral of myDDS is
signal phaseFactor: unsigned(FREG_WIDTH-1 downto 0):= to_unsigned(515,14); -- (2*pi*(2^14)/CLK_FREQ) -- 14bit franctional
begin
    process(clk)
    -- variable pi3_14:  unsigned(15 downto 0) := to_unsigned(51470,16);
    begin
        if rising_edge(clk) then
            PhSt <= phaseFactor * freq;
        end if;
    end process;

end Behavioral;

