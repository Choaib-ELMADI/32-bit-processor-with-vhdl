library ieee;
use ieee.std_logic_1164.all;

entity add_four_bits is
    port (
        a, b      : in  std_logic_vector(3 downto 0);
		op        : in  std_logic;
        s         : out std_logic_vector(3 downto 0);
		cout, ovf : out std_logic
    );
end entity;

architecture add_four_bits_arch of add_four_bits is
    component add_one_bit
        port (
            a, b, c_in : in  std_logic;
            s, c_out   : out std_logic
        );
    end component;

	signal carry : std_logic_vector(3 downto 0);

begin:

    adder0 : add_one_bit port map (a => a(0), b => b(0), c_in => op,       s => s(0), c_out => carry(0));
    adder1 : add_one_bit port map (a => a(1), b => b(1), c_in => carry(0), s => s(1), c_out => carry(1));
    adder2 : add_one_bit port map (a => a(2), b => b(2), c_in => carry(1), s => s(2), c_out => carry(2));
    adder3 : add_one_bit port map (a => a(3), b => b(3), c_in => carry(2), s => s(3), c_out => carry(3));

    cout <= carry(3);
    ovf  <= carry(3) xor carry(2);

end architecture;
