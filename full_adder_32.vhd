library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_32 is
    Port (
        as : in STD_LOGIC_vector(31 downto 0);  
        ba : in STD_LOGIC_vector(31 downto 0);
		  op: in STD_LOGIC;  
        Ss :out STD_LOGIC_vector(31 downto 0) ;
		  cout,ovf: out STD_LOGIC
    );
end full_adder_32;



architecture Behavioral of Full_adder_32 is
component Full_sous_add is
    Port (
        a : in STD_LOGIC_vector(3 downto 0);  
        b : in STD_LOGIC_vector(3 downto 0);
		  op: in STD_LOGIC;  
        S :out STD_LOGIC_vector(3 downto 0) ;
		  cout,ovf: out STD_LOGIC
    );
end component;
 signal c1 ,c2,c3,c4,c5,c6,c7,c8:std_logic;
 signal bs ,X:STD_LOGIC_vector(31 downto 0);
 begin
X<= (others=> op);
bs<= ba xor X;
U1 : Full_sous_add port map (a=>as(3 downto 0),b=>bs(3 downto 0),op=>op,s=>ss(3 downto 0),cout=>c1);
U2 : Full_sous_add port map (a=>as(7 downto 4),b=>bs(7 downto 4),op=>c1,s=>ss(7 downto 4),cout=>c2);
U3 : Full_sous_add port map (a=>as(11 downto 8),b=>bs(11 downto 8),op=>c2,s=>ss(11 downto 8),cout=>c3);
U4 : Full_sous_add port map (a=>as(15 downto 12),b=>bs(15 downto 12),op=>c3,s=>ss(15 downto 12),cout=>c4);


U5 : Full_sous_add port map (a=>as(19 downto 16),b=>bs(19 downto 16),op=>c4,s=>ss(19 downto 16),cout=>c5);
U6 : Full_sous_add port map (a=>as(23 downto 20),b=>bs(23 downto 20),op=>c5,s=>ss(23 downto 20),cout=>c6);
U7 : Full_sous_add port map (a=>as(27 downto 24),b=>bs(27 downto 24),op=>c6,s=>ss(27 downto 24),cout=>c7);
U8 : Full_sous_add port map (a=>as(31 downto 28),b=>bs(31 downto 28),op=>c7,s=>ss(31 downto 28),cout=>c8);

cout <= c8;
ovf <= c8 xor c7;


end Behavioral;
