--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:49:42 01/09/2024
-- Design Name:   
-- Module Name:   C:/Users/alireza/Desktop/Un_fpga/fskDemodulator/myDDS_TB.vhd
-- Project Name:  fskDemodulator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: myDDS
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
use IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY myDDS_TB IS
END myDDS_TB;
 
ARCHITECTURE behavior OF myDDS_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT myDDS
    PORT(
         clk : IN  std_logic;
         freq : IN  unsigned(7 downto 0);
         PhSt : OUT  unsigned(21 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal freq : unsigned(7 downto 0) := (others => '0');

 	--Outputs
   signal PhSt : unsigned(21 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: myDDS PORT MAP (
          clk => clk,
          freq => freq,
          PhSt => PhSt
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
