library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp16 is
    port (
        A   : in  signed(15 downto 0);
        B   : in  signed(15 downto 0);
        EQ  : out std_logic;
        GT  : out std_logic;
        LT  : out std_logic
    );
end entity cmp16;

architecture arch_cmp16 of cmp16 is
begin
    EQ <= '1' when A = B else '0';
    GT <= '1' when A < B else '0';
    LT <= '1' when A > B else '0';
end architecture arch_cmp16;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity or_gate is
    port (
        A : in std_logic;
        B : in std_logic;
        F : out std_logic
    );
end entity or_gate;

architecture arch_or_gate of or_gate is
begin
    F <= A or B;
end architecture arch_or_gate;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        din : in  signed(15 downto 0);
        dout : out signed(15 downto 0)
    );
end entity reg16;

architecture arch_reg16 of reg16 is
    signal reg_data : signed(15 downto 0) := (others => '0');
begin
    process(rst, clk, din)
    begin
        if rst = '1' then
            reg_data <= (others => '0');
        elsif rising_edge(clk) then
            reg_data <= din;
        end if;
    end process;
    dout <= reg_data;
end architecture arch_reg16;



--missing carry out management
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add is
    port (
        clk : in std_logic := '0';
        rst : in std_logic := '0';
        A : in signed(15 downto 0);
        B : in signed(15 downto 0);
        R : out signed(15 downto 0)
    );
end entity add;

architecture arch_add of add is
    signal result : signed(17 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            result <= (others => '0');
        elsif rising_edge(clk) then
            result <= resize(B, result'length) + resize(A, result'length);
        end if;
    end process;
    R <= result(15 downto 0);
end architecture arch_add;
