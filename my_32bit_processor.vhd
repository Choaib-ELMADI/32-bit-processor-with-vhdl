library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity my_32bit_processor is
    generic(n : integer := 32);
	

    Port (
	 
	 --test
	
	 r1,r2,out_alu,p_coun: out std_logic_vector(n-1 downto 0);
	 
	
	
	 
	 
        clock, run, reset : in std_logic;
        done_exe : buffer std_logic
    );
end my_32bit_processor;

architecture Behavioral of my_32bit_processor is
   type state_type is (T0,fetch,decode,excute,rm,wb);
	signal state :state_type;
    --signals for fetch
    signal pc ,pc_j,instruction,offset: std_logic_vector(n-1 downto 0);
	 signal imm_i :std_logic_vector(13 downto 0);
	 signal imm_j :std_logic_vector(28 downto 0);
	 signal sel_pc:std_logic_vector(1 downto 0);
	 --signals for decode
	 signal rs, rt, rd:std_logic_vector(4 downto 0);
	 signal w_regm,r_regm:std_logic;
	 signal sel_adr_wreg:std_logic_vector(1downto 0);
	 signal data_wreg,out1_wreg,out2_wreg: std_logic_vector(n-1 downto 0);
	 --signals for excute
	 signal in_alu1,in_alu2,out_alu1,out_alu2: std_logic_vector(n-1 downto 0);
	 signal sel_data_reg,sel_in_alu1,sel_in_alu2:std_logic_vector(1 downto 0);
	 signal op_code:std_logic_vector(4 downto 0);
	 --signals for RM
	 signal w_mem,r_mem:std_logic;
	 signal data_wmem,adress_mem,out_mem: std_logic_vector(n-1 downto 0);
	 signal sel_data_mem,sel_adress_mem:std_logic_vector(1 downto 0);
	 --signal for control
	 signal i: std_logic_vector(7 downto 0);
     
--  component
component Memoire_registres is 
    port (
        clk: in std_logic;
        reset: in std_logic;  
        write_bit,read_bit: in std_logic;              
        read_reg_1, read_reg_2, write_reg: in std_logic_vector(4 downto 0); 
        write_data: in std_logic_vector(31 downto 0);   
        read_data_1, read_data_2: out std_logic_vector(31 downto 0)      
    );
end  component;
component memoire_principale IS 
   
    PORT (
        clk,reset,RE ,   WE   : IN  std_logic;                              
        data_in , address  : IN  std_logic_vector(31 DOWNTO 0);       
        data_out : OUT std_logic_vector(31 DOWNTO 0)        
    );
END component;
component alu_main is
    port (
        clk, reset : in std_logic;
        OP_code   : in std_logic_vector(4 downto 0);
        in1, in2  : in std_logic_vector(31 downto 0);
        hi, lo    : out std_logic_vector(31 downto 0)
    );
end component;

begin

-- PC
p_coun<=PC;

imm_i<=instruction(13 downto 0);
offset <= (31 downto 14 => imm_i(13)) & imm_i; 
imm_j<=instruction(28 downto 0);
pc_j<=pc(31 downto 29) & imm_j;

process(clock, reset)
    variable num_edge: integer := 0;
    variable prev_pc_j : std_logic_vector(pc'length-1 downto 0);  
begin
    if reset = '1' then
        pc <= (others => '0');
        prev_pc_j := (others => '0');  
    elsif rising_edge(clock) then
        if done_exe = '0' then
            if run = '1' then
                pc <= (others => '0');  
            elsif (num_edge mod 5 = 0)   then  
                case sel_pc is
                    when "00" => 
                        pc <= std_logic_vector(signed(pc) + 1);  

                    when "01" =>
                        pc <= std_logic_vector(signed(pc) + signed(offset)); 

                    when "10" =>
                        pc <= prev_pc_j; 
						  when "11" =>
						      pc<=out1_wreg;
                end case;
            end if;
            num_edge := num_edge + 1;
        end if;
        prev_pc_j := pc_j; 
    end if;
end process;


done_exe<='1' when  i(7 downto 5)="111" else '0';







    --Controle sel_pc
--Liaision pc et memoire_programme
mem_progrmme: entity work.Memoire_programme  port MAP (read_bit=>'1',read_adress=>pc,read_data=>instruction) ;
		--test
     
--liaison memoire programme et memoire registres
   
rs<=instruction(23 downto 19); rt<=instruction(18 downto 14);

rd<=instruction(13 downto 9) when sel_adr_wreg="00" else 
instruction(18 downto 14)  when sel_adr_wreg="01" else
"11110";

mem_registre:Memoire_registres  port MAP (clk=>clock,
        reset=>reset, 
        write_bit=>w_regm,read_bit=>r_regm,              
        read_reg_1=>rs, read_reg_2=>rt, write_reg=>rd,
        write_data=>data_wreg,
        read_data_1=>out1_wreg, read_data_2=>out2_wreg) ;
		  

r1<=out1_wreg;
r2<=out2_wreg;
--liaison memoire registre et alu


in_alu1<= out1_wreg when sel_in_alu1 = "00" else
          --to be cntinued 
          (others=>'0');
in_alu2<= out2_wreg when sel_in_alu2 = "00" else
          offset  when sel_in_alu2 = "01" else
          --to be cntinued 
          (others=>'0');
			 
			 
alu:alu_main  port MAP (clk=>clock,reset=>reset,OP_code=>op_code,in1=>in_alu1,in2=>in_alu2,
		hi=>out_alu1,lo=>out_alu2) ;
		
data_wreg<= out_alu2 when sel_data_reg = "00" else
         out_mem when sel_data_reg = "01" else
         out_alu1 when sel_data_reg = "10" else
			std_logic_vector(signed(pc) + 1);
  -- control and test  OPCODE  sel_data_reg sel_in_alu2 sel_in_alu1
  	 
   out_alu<=out_alu2;	
	
	
--laison alu et memoire principale	
	
data_wmem <= out2_wreg when sel_data_mem = "00" else
			--to be cntinued 
          (others=>'0');	
adress_mem	 <= out_alu2 when sel_adress_mem = "00" else
			--to be cntinued 
          (others=>'0');	
			 
mem_princupale:memoire_principale  port MAP (clk=>clock,reset=>reset,RE=> R_mem ,WE =>w_mem,                             
        data_in =>data_wmem, address=>adress_mem,data_out=>out_mem ) ;
	
	
	
--CONTROLE 
 --changemment d etat:	
	
process(clock,reset)
begin
    if reset ='1' then 
	    state<=T0;
	 elsif rising_edge(clock) then
		case state is
	      when T0=> state<=fetch;
			when fetch=> state<=decode;
			when decode=> state<=excute;
			when excute=> state<=rm;
			when rm=> state<=wb;
			when wb=> state<=fetch;
		end case;
	 end if;
end process;
i<=instruction(31 downto 24); 
 	

process(state)

begin
   
	if i(i'left)='0' then				
	case state is
		when fetch => r_regm<='1';sel_pc<="00";
               sel_adr_wreg<="00";sel_data_reg<="00";w_regm<='0';
               sel_in_alu1<="00";sel_in_alu2<="00";
					sel_data_mem<="00";sel_adress_mem<="00";
               w_mem<='0';r_mem<='0';
					
 
		when decode => sel_in_alu1<="00";
		        --op_code
		        case i is 
				      when "00000001" | "01000001" | "01001001" | "01001010" => op_code<="00000";
						when "00000010" | "01000010" => op_code<="00001";
					   when "00000011" | "01000011" => op_code<="00010";
						when "00000100" | "01000100" => op_code<="00011";
					   when "00000101" | "01000101" => op_code<="00110";
						when "00000110" | "01000110"=> op_code<="00111";
						when "00000111" | "01000111"=> op_code<="01000";
						when "00001000" => op_code<="01011";
						when "00001001" => op_code<="01010";
						when "01001011" | "01001100"=> op_code<="00100";
						when "01001000"  => op_code<="01001";
						when OTHERS=> op_code<="00000";
						
				  end case;
				  
				  
				  
				  
				 --in_alu2
				 case i is 
						when "00001000" | "00001001" | "00001010" | "00001011" | "01000001" | "01000010" | "01000011" | "01000100" | "01000101" | "01000110" | "01000111" | "01001001" | "01001010" => sel_in_alu2<="01";
						when others  => sel_in_alu2<="00";
				 end case;
		when excute => sel_adress_mem <= "00";sel_data_mem <= "00";
		       case i is
               when "01001001" => r_mem <= '1'; w_mem <= '0';
               when "01001010" => w_mem <= '1'; r_mem <= '0';
               when others     => r_mem <= '0'; w_mem <= '0';
             end case;

		when RM =>
		      case i is 
			      when  "01001001"  =>sel_adr_wreg<="01";sel_data_reg <= "01";
					when "01000001"  | "01000010" | "01000011" | "01000100"   | "01000101" | "01000110"  | "01000111" | "01001000"       =>sel_adr_wreg<="01";sel_data_reg <= "00";
					when others =>sel_adr_wreg<="00";sel_data_reg <= "00";
				end case;
				case i is
				   when  "01001010" | "00001100" | "01001011" | "01001100" => w_regm<='0';
					when others => w_regm<='1';
				end case;
		when WB => 
		     case i is
				when "01001011" => if to_integer(signed(out_alu2))=0   then sel_pc<="01"; else sel_pc<="00"; end if;
				when "01001100" => if to_integer(signed(out_alu2))/=0   then sel_pc<="01"; else sel_pc<="00"; end if;
				when "01001101" =>sel_pc<="11";
				when others =>sel_pc<="00";
			  end case;
			   
			   
		     		
	  when T0=>sel_pc<="00";
               sel_adr_wreg<="00";sel_data_reg<="00";w_regm<='0';r_regm<='0';
					op_code<="00000";
               sel_in_alu1<="00";sel_in_alu2<="00";
					sel_data_mem<="00";sel_adress_mem<="00";
               w_mem<='0';r_mem<='0';
					
 
   end case;
	elsif i(6) = '0' then
	      case i(5) is
			  when '0' => sel_pc<="10";
			  when others => sel_pc<="10";sel_data_reg<="11"; sel_adr_wreg<="10";w_regm<='1';
			 end case;
end if;
end process;





end Behavioral;


--memoire_programme 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity Memoire_programme is 
    port (
        read_bit: in std_logic;              
        read_adress: in std_logic_vector(31 downto 0);    
        read_data: out std_logic_vector(31 downto 0)      
    );
end Memoire_programme;

architecture beh of Memoire_programme is

    type mem_tab is array(0 to 127) of STD_LOGIC_VECTOR (31 downto 0);  
        signal my_mem: mem_tab := (
	  0 => "00000000000000000000000000000000",  
    1 =>  "01000001111110000000000000001010",  
    2 =>  "01000001111110000100000000001111", 
	 3 =>  "10100000000000000000000000000110",
	 4 =>  "00000001111111110100100000000000",
	 5 =>  "10000000000000000000000000001100",
	 
	 6 =>  "00000001000000000111101000000000",
	 7 =>  "01001101111101111111111111111111",
    8 =>  "10000000000000000000000000000100", 
	  9 => "00000001000011111100101000000000", 
	 10 => "10000000000000000000000000001100", 
	 11 => "00000001000101111100101000000000", 
	  12=> "11100000000000000000000000000000", 
	 
    others => "00000000000000000000000000000000" 
    );            
begin

	 process(read_adress)
    begin
        
				if read_bit = '1' then
				    read_data<= my_mem(to_integer(unsigned(read_adress)));
				end if; 
        
    end process;
    

end beh;



















