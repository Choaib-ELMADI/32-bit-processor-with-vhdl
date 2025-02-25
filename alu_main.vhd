library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_main is
    port (
        clk, reset : in std_logic;
        OP_code   : in std_logic_vector(4 downto 0);
        in1, in2  : in std_logic_vector(31 downto 0);
        hi, lo    : out std_logic_vector(31 downto 0)
    );
end alu_main;

architecture comportementale of alu_main is

    signal somme1, somme2, diff1, diff2, quotient, reste, r_cmp: std_logic_vector(31 downto 0);
    signal produit: std_logic_vector(63 downto 0);
    signal lo_reg, hi_reg: std_logic_vector(31 downto 0);

    component full_adder_32 is
        Port (
            as, ba : in STD_LOGIC_vector(31 downto 0);  
            op : in STD_LOGIC;  
            Ss : out STD_LOGIC_vector(31 downto 0);
            cout, ovf : out STD_LOGIC
        );
    end component;

    component Multiplication is
        port (
            A, B : in std_logic_vector(31 downto 0);
            Pf : out std_logic_vector(63 downto 0)
        );
    end component;

    component division is
        port (
            A, B : in std_logic_vector(31 downto 0);
            Q, R : out std_logic_vector(31 downto 0)
        );
    end component;

    component Comparaison is
        port (
            A, B : in std_logic_vector(31 downto 0);
            R : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    U1: full_adder_32 port map (as => in1, ba => in2, op => '0', Ss => somme1, cout => somme2(0), ovf => somme2(1));
    U2: full_adder_32 port map (as => in1, ba => in2, op => '1', Ss => diff1, cout => diff2(0), ovf => diff2(1));
    U3: Multiplication port map (A => in1, B => in2, Pf => produit);
    U4: division port map (A => in1, B => in2, Q => quotient, R => reste);
    U5: Comparaison port map (A => in1, B => in2, R => r_cmp);

    process (clk, reset)
        variable shamt : integer;
    begin
        shamt := to_integer(signed(in2(4 downto 0)));  -- Limiting shift amount to 5 bits (0-31)

        if reset = '1' then
            lo_reg <= (others => '0');
            hi_reg <= (others => '0');
        elsif rising_edge(clk) then
            case OP_code is
                when "00000" => lo_reg <= somme1; hi_reg <= somme2;  -- Addition
                when "00001" => lo_reg <= diff1; hi_reg <= diff2;    -- Subtraction
                when "00010" => lo_reg <= produit(31 downto 0); hi_reg <= produit(63 downto 32); -- Multiplication
                when "00011" => lo_reg <= quotient; hi_reg <= reste; -- Division
                when "00100" => lo_reg <= r_cmp; hi_reg <= (others => '0'); -- Comparison
                when "00101" => lo_reg <= reste; hi_reg <= quotient; -- Modulo
                when "00110" => lo_reg <= (in1 and in2); hi_reg <= (others => '0'); -- AND
                when "00111" => lo_reg <= (in1 or in2); hi_reg <= (others => '0');  -- OR
                when "01000" => lo_reg <= (in1 xor in2); hi_reg <= (others => '0'); -- XOR
                when "01001" => lo_reg <= not(in1); hi_reg <= not(in2); -- NOT
                when "01010" => lo_reg <= std_logic_vector(shift_right(unsigned(in1), shamt)); hi_reg <= (others => '0'); -- Shift Right
                when "01011" => lo_reg <= std_logic_vector(shift_left(unsigned(in1), shamt)); hi_reg <= (others => '0');  -- Shift Left
                when others => lo_reg <= (others => '0'); hi_reg <= (others => '0');
            end case;
        end if;
    end process;

    lo <= lo_reg;
    hi <= hi_reg;

end comportementale;


























