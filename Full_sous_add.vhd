library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_sous_add is
    Port (
        a : in STD_LOGIC_vector(3 downto 0);  
        b : in STD_LOGIC_vector(3 downto 0);
		  op: in STD_LOGIC;  
        S :out STD_LOGIC_vector(3 downto 0) ;
		  cout,ovf: out STD_LOGIC
    );
end Full_sous_add;


architecture Behavioral of Full_sous_add is
component add_1_bit 
        Port (
        a0 : in STD_LOGIC;  
        b0 ,c0: in STD_LOGIC;  
        S0,cout0 : out STD_LOGIC  
    );
    end component;

	 signal c1 ,c2,c3,c4:std_logic;
begin	 

U1 : add_1_bit port map (a0=>a(0),b0=>b(0),c0=>op,s0=>s(0),cout0=>c1);
U2 : add_1_bit port map (a0=>a(1),b0=>b(1),c0=>c1,s0=>s(1),cout0=>c2);
U3 : add_1_bit port map (a0=>a(2),b0=>b(2),c0=>c2,s0=>s(2),cout0=>c3);
U4 : add_1_bit port map (a0=>a(3),b0=>b(3),c0=>c3,s0=>s(3),cout0=>c4);
cout <= c4;
ovf <= c4 xor c3;
end Behavioral;
