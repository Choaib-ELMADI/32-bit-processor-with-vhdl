library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity division is
		generic (n : positive := 32 );
port (
		A ,B: in std_logic_vector(n - 1 downto 0);
		
		Q,R: out std_logic_vector(n - 1 downto 0)
);
end division;

architecture comportementale of division is
signal B_un: unsigned(31 downto 0);
signal zeros: std_logic_vector(n-2 downto 0);
signal temp,as,bs,qs,rs: std_logic_vector(N-1 downto 0);
signal  sign:std_logic;
begin
	sign<= A(A'left) xor B(B'left);
	B_un<=unsigned(Bs);
	zeros<=(others=>'0');
	temp<=zeros & As(N-1);
	as <= A when  A(A'left)= '0'  else std_logic_vector(signed(not(A))+1);
	
	bs <=  B when  B(B'left)= '0'  else std_logic_vector(signed(not(B))+1);
	
process(A,B)
variable A_un :unsigned(n-1 downto 0);
variable tempo: std_logic_vector(n-1 downto 0);
begin

A_un := unsigned(temp);

for k in N-1 downto 1 loop
tempo:=zeros & As(k-1);
if A_un >= B_un then
Qs(k)<='1';
A_un:=((A_un - B_un) + (A_un - B_un)) + unsigned(tempo);
else 
Qs(k)<='0';

A_un:=(A_un + A_un) + unsigned(tempo);


end if;

end loop;
if A_un >= B_un then
Qs(0)<='1';
A_un:=(A_un - B_un);
else 
Qs(0)<='0';

end if;
Rs<=std_logic_vector(A_un);
end process;

Q<= QS when sign='0' else std_logic_vector(signed(not(qs))+1);
R<= RS when A(A'left)= '0' else std_logic_vector(signed(not(Rs))+1);



end comportementale;