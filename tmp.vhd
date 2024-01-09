library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity testbench is
    port (
        result : out real
    );
end entity testbench;

architecture Behavioral of testbench is
    constant pi : real := 3.1415;
    constant multiplier : real := 2.0;
begin
    process
    begin
        -- Perform multiplication
        result <= pi / multiplier;
        wait; -- Infinite loop 
    end process;
end architecture Behavioral;