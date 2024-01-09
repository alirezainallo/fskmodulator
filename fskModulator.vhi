
-- VHDL Instantiation Created from source file fskModulator.vhd -- 00:54:49 01/10/2024
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT fskModulator
	PORT(
		clk : IN std_logic;
		Rx : IN std_logic;          
		Tx : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_fskModulator: fskModulator PORT MAP(
		clk => ,
		Rx => ,
		Tx => 
	);


