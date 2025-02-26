library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
    port (
        a, b : in  std_logic_vector(31 downto 0);
        r    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture comparator_arch of comparator is

    signal a_signed, b_signed : signed(31 downto 0);
    signal res                : std_logic_vector(1 downto 0);

begin:

    a_signed <= signed(a);
    b_signed <= signed(b);

    process(a_signed, b_signed)
    begin

        if a_signed = b_signed then
            res <= "00";
        elsif a_signed > b_signed then
            res <= "01";
        else
            res <= "10";
        end if;

    end process;

    r <=
        (others => '0')           when res = "00" else  -- 00000000000000000000000000000000
        (0 => '1', others => '0') when res = "01" else  -- 00000000000000000000000000000001
        (others => '1');                                -- 11111111111111111111111111111111

end architecture;
