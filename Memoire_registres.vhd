library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Memoire_registres is 
    port (
        clk: in std_logic;
        reset: in std_logic;  
        write_bit,read_bit: in std_logic;              
        read_reg_1, read_reg_2, write_reg: in std_logic_vector(4 downto 0); 
        write_data: in std_logic_vector(31 downto 0);   
        read_data_1, read_data_2: out std_logic_vector(31 downto 0)      
    );
end Memoire_registres;

architecture beh of Memoire_registres is

    type mem_tab is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);  
    signal my_mem: mem_tab := (others => (others => '0'));            
begin

    
    process(clk, reset)
	 variable num_edge: integer:= 0;
    begin
        
        if reset = '1' then
            for i in 0 to 31 loop
                my_mem(i) <= (others => '0');  
            end loop;
        elsif rising_edge(clk) then
		   
		    if (num_edge mod 5 = 4) then  
              if write_bit = '1' and to_integer(unsigned(write_reg)) < 31 then
                my_mem(to_integer(unsigned(write_reg))) <= write_data;
              end if;
			 end if;
			 if (num_edge mod 5 = 1) then
				  if read_bit = '1' then
				    read_data_1 <= my_mem(to_integer(unsigned(read_reg_1)));
					 read_data_2 <= my_mem(to_integer(unsigned(read_reg_2)));
			     end if;
			 end if;
		   
			
			
			num_edge := num_edge + 1;	
        end if;
    end process;
    

end beh;
