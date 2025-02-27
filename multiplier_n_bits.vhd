library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_n_bits is
	generic (
        n : positive := 32
    );
    port (
		a, b : in  std_logic_vector(n - 1 downto 0);
		prod : out std_logic_vector(2*n - 1 downto 0)
    );
end entity;

architecture multiplier_n_bits_arch of multiplier_n_bits is
	signal zeros_64, as, p : std_logic_vector(2*n - 1 downto 0);
    signal zeros_32, bs    : std_logic_vector(n - 1 downto 0);
    signal sign            : std_logic;

begin

    sign     <= a(a'left) xor b(b'left);
    zeros_64 <= (others => '0');
	zeros_32 <= (others => '0');
	as       <= (zeros_32 & a) when a(a'left) = '0' else (zeros_32 & std_logic_vector(signed(not(a)) + 1));
	bs       <= b              when b(b'left) = '0' else std_logic_vector(signed(not(b)) + 1);

    process(a, b)
        variable temp, mul : std_logic_vector(2*n - 1 downto 0);
    begin

        temp := as;
        mul  := zeros_64;

        for k in n - 1 downto 0 loop
            if bs(n - k-1) = '1' then
                mul := std_logic_vector(signed(mul) + signed(temp));
            end if;

            temp := std_logic_vector(signed(temp) + signed(temp));
        end loop;

        p <= mul;

    end process;

    prod <= p when sign = '0' else std_logic_vector(signed(not(p)) + 1);

end architecture;
