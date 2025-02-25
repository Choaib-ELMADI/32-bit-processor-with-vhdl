library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Comparaison is
    port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end Comparaison;

architecture comportementale of Comparaison is
    signal as, bs : signed(31 downto 0);
    signal re : std_logic_vector(1 downto 0);    
begin
    -- Convert input to signed values
    as <= signed(A);
    bs <= signed(B);

    process(as, bs)
    begin
        if as = bs then 
            re <= "00"; -- A == B
        elsif as > bs then 
            re <= "01"; -- A > B
        else 
            re <= "10"; -- A < B
        end if;
    end process;

R<= (others => '0') when re = "00" else
(0=> '1', others => '0') when re = "01" else
(others => '1') ;

end comportementale;

