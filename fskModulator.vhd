----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:38:13 01/10/2024 
-- Design Name: 
-- Module Name:    fskModulator - Behavioral 
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

entity fskModulator is
    generic(
        HIGH_FREQ :  positive := 20;
        LOW_FREQ  :  positive := 5
    );
    Port (
        clk : in  STD_LOGIC;
        Rx  : in  STD_LOGIC;
        Tx  : out signed(15 downto 0)
    );
end fskModulator;

architecture Behavioral of fskModulator is
    COMPONENT dds
	Port ( 
      clk  : in   STD_LOGIC;
      freq : in   unsigned(7 downto 0);-- 0bit,8bit,0bit
      sig  : OUT  signed(15 downto 0)
	 );
	END COMPONENT;
   signal ddsOut: signed(15 downto 0):=to_signed(0, 16);
	
	signal currFreq: unsigned(7 downto 0):=to_unsigned(5, 8);
	signal highFreq: unsigned(7 downto 0):=to_unsigned(HIGH_FREQ, 8);
	signal lowFreq:  unsigned(7 downto 0):=to_unsigned(LOW_FREQ,  8);
begin
    
    Inst_dds: dds PORT MAP(
		clk => clk,
		freq => currFreq,
		sig => ddsOut
	);

	Tx <= ddsOut;

    process(clk)
    begin
        if rising_edge(clk) then
            if Rx = '1' then
                currFreq <= highFreq;
            elsif Rx = '0' then
                currFreq <= lowFreq;
            end if;
        end if;
    end process;
end Behavioral;

