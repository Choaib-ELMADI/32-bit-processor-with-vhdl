library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_1_bit is
    Port (
        a0 : in STD_LOGIC;  
        b0 ,c0: in STD_LOGIC;  
        S0,cout0 : out STD_LOGIC  
    );
end add_1_bit;


architecture Behavioral of add_1_bit is
begin
   s0 <= ( a0 xor b0 )xor c0;
	cout0 <=  (a0 and b0) or (c0 and (a0 xor b0));
end Behavioral;
