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
use STD.textio.all;
use IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_textio.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY myDDS_TB IS
   Generic(
      OUTPUT_FILE_NAME : string := "dds_output.txt";   -- File path and name
      DATA_WIDTH   : integer := 16
    );
END myDDS_TB;
 
ARCHITECTURE behavior OF myDDS_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	COMPONENT fskModulator
	PORT(
		clk : IN std_logic;
		Rx : IN std_logic;
		Tx : OUT signed(15 downto 0)
		);
	END COMPONENT;
    
	signal clk : std_logic := '0';
	signal Rx  : std_logic := '0';
	signal sig : signed(15 downto 0):=to_signed(0, 16);
   -- Clock period definitions
   constant clk_period : time := 100 ns;
	constant Rx_period  : time := 3 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	Inst_fskModulator: fskModulator PORT MAP(
		clk => clk,
		Rx => Rx,
		Tx => sig
	);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	-- Rx process definitions
   Rx_process :process
   begin
		Rx <= '0';
		wait for Rx_period/2;
		Rx <= '1';
		wait for Rx_period/2;
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


   -- out file
   process(clk)   
      file     output_file : text is out OUTPUT_FILE_NAME;
      variable output_line : line;
      variable output_time : time;
   begin
      if rising_edge(clk) then
         -- File operations
         output_time:=now;
         write(output_line, output_time, right);
			write(output_line, " ", right);
         write(output_line, Rx, right);
			write(output_line, " ", right);
         write(output_line, to_integer(sig), right);
         writeline(output_file, output_line);
      end if;
   end process;

END;
