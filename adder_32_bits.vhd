library ieee;
use ieee.std_logic_1164.all;

entity adder_32_bits is
    port (
        a, b      : in  std_logic_vector(31 downto 0);
		op        : in  std_logic;
        s         : out std_logic_vector(31 downto 0);
		cout, ovf : out std_logic
    );
end entity;

architecture adder_32_bits_arch of adder_32_bits is
    component adder_4_bits is
        port (
            a, b      : in  std_logic_vector(3 downto 0);
            op        : in  std_logic;
            s         : out std_logic_vector(3 downto 0);
            cout, ovf : out std_logic
        );
    end component;

    signal carry : std_logic_vector(7 downto 0);
    signal bs, x : std_logic_vector(31 downto 0);

begin:

    x  <= (others => op);
    bs <= b xor x;

    adder_4_bits_0 : adder_4_bits port map (a => a(3 downto 0),   b => bs(3 downto 0),   op => op,       s => s(3 downto 0),   cout => carry(0));
    adder_4_bits_1 : adder_4_bits port map (a => a(7 downto 4),   b => bs(7 downto 4),   op => carry(0), s => s(7 downto 4),   cout => carry(1));
    adder_4_bits_2 : adder_4_bits port map (a => a(11 downto 8),  b => bs(11 downto 8),  op => carry(1), s => s(11 downto 8),  cout => carry(2));
    adder_4_bits_3 : adder_4_bits port map (a => a(15 downto 12), b => bs(15 downto 12), op => carry(2), s => s(15 downto 12), cout => carry(3));
    adder_4_bits_4 : adder_4_bits port map (a => a(19 downto 16), b => bs(19 downto 16), op => carry(3), s => s(19 downto 16), cout => carry(4));
    adder_4_bits_5 : adder_4_bits port map (a => a(23 downto 20), b => bs(23 downto 20), op => carry(4), s => s(23 downto 20), cout => carry(5));
    adder_4_bits_6 : adder_4_bits port map (a => a(27 downto 24), b => bs(27 downto 24), op => carry(5), s => s(27 downto 24), cout => carry(6));
    adder_4_bits_7 : adder_4_bits port map (a => a(31 downto 28), b => bs(31 downto 28), op => carry(6), s => s(31 downto 28), cout => carry(7));

    cout <= carry(7);
    ovf  <= carry(7) xor carry(6);

end architecture;
