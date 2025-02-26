library ieee;
use ieee.std_logic_1164.all;

entity add_one_bit is
    port (
        a, b, c_in : in  std_logic;
        s, c_out   : out std_logic
    );
end entity;

architecture add_one_bit_arch of add_one_bit is
begin:

    s     <= (a xor b) xor c_in;
    c_out <= (a and b) or (c_in and (a xor b));

end architecture;
