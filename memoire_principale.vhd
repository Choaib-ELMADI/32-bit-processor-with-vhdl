LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY memoire_principale IS 
   
    PORT (
        clk,reset,RE ,   WE   : IN  std_logic;                              
        data_in , address  : IN  std_logic_vector(31 DOWNTO 0);       
        data_out : OUT std_logic_vector(31 DOWNTO 0)        
    );
END memoire_principale;

ARCHITECTURE behavioral_mem OF memoire_principale IS
    TYPE mem IS ARRAY (0 TO 31) OF std_logic_vector(31 DOWNTO 0);
    SIGNAL ram : mem;
BEGIN

    PROCESS (clk)
	 variable num_edge: integer:= 0;
    BEGIN
	     if reset = '1' then
            for i in 0 to 31 loop
              ram(i) <= (others => '0');  
            end loop;
        ELSIF rising_edge(clk) THEN
		  if (num_edge mod 5 = 3) then 
            IF (WE = '1' AND RE = '0' AND to_integer(unsigned(address))<31 ) THEN
                ram(to_integer(unsigned(address))) <= data_in;
					 data_out <= ram(to_integer(unsigned(address)));
            END IF;
            IF (WE = '0' AND RE = '1' AND to_integer(unsigned(address))<31) THEN
                data_out <= ram(to_integer(unsigned(address)));
            END IF;
        END IF;
		  num_edge := num_edge + 1;
		  END IF;
    END PROCESS;

END behavioral_mem;

