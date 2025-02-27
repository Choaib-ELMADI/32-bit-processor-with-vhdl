library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity division is
	generic (
        n : positive := 32
    );
    port (
		a, b : in  std_logic_vector(n - 1 downto 0);
		q, r : out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture division_arch of division is
    signal a_un                 : unsigned(31 downto 0);
    signal zeros                : std_logic_vector(n - 2 downto 0);
    signal temp, as, bs, qs, rs : std_logic_vector(n - 1 downto 0);
    signal sign                 : std_logic;

begin

	sign  <= a(a'left) xor b(b'left);
	b_un  <= unsigned(bs);
	zeros <= (others => '0');
	temp  <= zeros & as(n - 1);
	as    <= a  when a(a'left) = '0' else std_logic_vector(signed(not(a)) + 1);
	bs    <= b  when b(b'left) = '0' else std_logic_vector(signed(not(b)) + 1);
    q     <= qs when sign = '0'      else std_logic_vector(signed(not(qs)) + 1);
    r     <= rs when a(a'left) = '0' else std_logic_vector(signed(not(rs)) + 1);

    process(a, b)
        variable a_un  : unsigned(n - 1 downto 0);
        variable tempo : std_logic_vector(n - 1 downto 0);
    begin

        a_un := unsigned(temp);

        for k in n - 1 downto 1 loop
            tempo := zeros & as(k - 1);

            if a_un >= b_un then
                qs(k) <= '1';
                a_un  := ((a_un - b_un) + (a_un - b_un)) + unsigned(tempo);
            else
                qs(k) <= '0';
                a_un  := (a_un + a_un) + unsigned(tempo);
            end if;

        end loop;

        if a_un >= b_un then
            qs(0) <= '1';
            a_un  := (a_un - b_un);
        else
            qs(0) <= '0';
        end if;

        rs <= std_logic_vector(a_un);

    end process;

end architecture;
