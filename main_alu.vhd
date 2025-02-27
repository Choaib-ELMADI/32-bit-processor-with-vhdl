library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_alu is
    port (
        clk, reset : in  std_logic;
        opcode     : in  std_logic_vector(4 downto 0);
        in1, in2   : in  std_logic_vector(31 downto 0);
        hi, lo     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture main_alu_arch of main_alu is
    signal somme1, somme2  : std_logic_vector(31 downto 0);
    signal diff1, diff2    : std_logic_vector(31 downto 0);
    signal quotient, reste : std_logic_vector(31 downto 0);
    signal cmp_res         : std_logic_vector(31 downto 0);
    signal produit         : std_logic_vector(63 downto 0);
    signal hi_reg, lo_reg  : std_logic_vector(31 downto 0);

    component adder_32_bits is
        port (
            a, b      : in  std_logic_vector(31 downto 0);
            op        : in  std_logic;
            s         : out std_logic_vector(31 downto 0);
            cout, ovf : out std_logic
        );
    end component;

    component multiplier_n_bits is
        port (
            a, b : in  std_logic_vector(31 downto 0);
            prod : out std_logic_vector(63 downto 0)
        );
    end component;

    component divider_n_bits is
        port (
            a, b : in  std_logic_vector(31 downto 0);
            q, r : out std_logic_vector(31 downto 0)
        );
    end component;

    component comparator_32_bits is
        port (
            a, b : in  std_logic_vector(31 downto 0);
            r    : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    adder_32_bits_0    : adder_32_bits      port map (a => in1, b => in2, op   => '0',      s => somme1, cout => somme2(0), ovf => somme2(1));
    adder_32_bits_1    : adder_32_bits      port map (a => in1, b => in2, op   => '1',      s => diff1,  cout => diff2(0),  ovf => diff2(1));
    multiplier_n_bits  : multiplier_n_bits  port map (a => in1, b => in2, prod => produit);
    divider_n_bits     : divider_n_bits     port map (a => in1, b => in2, q    => quotient, r => reste);
    comparator_32_bits : comparator_32_bits port map (a => in1, b => in2, r    => cmp_res);

    process (clk, reset)
        variable shamt : integer;
    begin

        shamt := to_integer(signed(in2(4 downto 0)));  -- Limiting shift amount to 5 bits (0-31)

        if reset = '1' then
            lo_reg <= (others => '0');
            hi_reg <= (others => '0');
        elsif rising_edge(clk) then
            case opcode is
                when "00000" => lo_reg <= somme1; hi_reg <= somme2;                                                         -- Addition
                when "00001" => lo_reg <= diff1; hi_reg <= diff2;                                                           -- Subtraction
                when "00010" => lo_reg <= produit(31 downto 0); hi_reg <= produit(63 downto 32);                            -- Multiplication
                when "00011" => lo_reg <= quotient; hi_reg <= reste;                                                        -- Division
                when "00100" => lo_reg <= cmp_res; hi_reg <= (others => '0');                                               -- Comparison
                when "00101" => lo_reg <= reste; hi_reg <= quotient;                                                        -- Modulo
                when "00110" => lo_reg <= (in1 and in2); hi_reg <= (others => '0');                                         -- AND
                when "00111" => lo_reg <= (in1 or in2); hi_reg <= (others => '0');                                          -- OR
                when "01000" => lo_reg <= (in1 xor in2); hi_reg <= (others => '0');                                         -- XOR
                when "01001" => lo_reg <= not(in1); hi_reg <= not(in2);                                                     -- NOT
                when "01010" => lo_reg <= std_logic_vector(shift_right(unsigned(in1), shamt)); hi_reg <= (others => '0');   -- Shift Right
                when "01011" => lo_reg <= std_logic_vector(shift_left(unsigned(in1), shamt)); hi_reg <= (others => '0');    -- Shift Left
                when others => lo_reg <= (others => '0'); hi_reg <= (others => '0');
            end case;
        end if;

    end process;

    lo <= lo_reg;
    hi <= hi_reg;

end architecture;
