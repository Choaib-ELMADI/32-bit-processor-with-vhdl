library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Multiplication is
		generic (n : positive := 32 );
port (
		A : in std_logic_vector(n - 1 downto 0);
		B: in std_logic_vector(n - 1 downto 0);
		Pf: out std_logic_vector(2*n - 1 downto 0)
);
end Multiplication;

architecture comportementale of Multiplication is
		signal as ,zeros64,P:std_logic_vector(2*n - 1 downto 0);
		signal  zeros32,BS:std_logic_vector(n - 1 downto 0);
		signal  sign:std_logic;
begin
   sign<= A(A'left) xor B(B'left);
   
	as <= (zeros32 & A) when  A(A'left)= '0'  else (zeros32 & std_logic_vector(signed(not(A))+1));
	
	bs <=  B when  B(B'left)= '0'  else std_logic_vector(signed(not(B))+1);
	
   zeros64<=(others=>'0');
	zeros32<=(others=>'0');
	
	
process(A,B)
variable temp ,mul: std_logic_vector(2*n - 1 downto 0);
begin
temp:=as;
mul:=zeros64;
		for k in N-1 downto 0 loop
			if Bs(N-k-1)	='1' then
			     mul:=std_logic_vector(signed(mul)+signed(temp));
			end if ;
			temp:=std_logic_vector(signed(temp)+signed(temp));
				
		end loop;
	P<=mul;
end process;
Pf<= P when sign='0' else std_logic_vector(signed(not(P))+1);
end comportementale;