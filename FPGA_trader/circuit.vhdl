library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp16_win is
    port (
        Top_win   : in  signed(15 downto 0);
        Acc_change   : in  signed(15 downto 0);
        EQ  : out std_logic;
        GT  : out std_logic;
        LT  : out std_logic
    );
end entity cmp16_win;

architecture arch_cmp16_win of cmp16_win is
begin
    EQ <= '1' when Top_win = Acc_change else '0';
    GT <= '1' when Top_win < Acc_change else '0';
    LT <= '1' when Top_win > Acc_change else '0';
end architecture arch_cmp16_win;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sell_flag is
    port (
        EQ : in std_logic;
        GT : in std_logic;
        SF : out std_logic
    );
end entity sell_flag;

architecture arch_sell_flag of sell_flag is
begin
    SF <= EQ or GT;
end architecture arch_sell_flag;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp16_loose is
    port (
        Top_loose : in  signed(15 downto 0);
        Acc_change : in  signed(15 downto 0);
        EQ  : out std_logic;
        GT  : out std_logic;
        LT  : out std_logic
    );
end entity cmp16_loose;

architecture arch_cmp16_loose of cmp16_loose is
begin
    EQ <= '1' when Top_loose = Acc_change else '0';
    GT <= '1' when Top_loose < Acc_change else '0';
    LT <= '1' when Top_loose > Acc_change else '0';
end architecture arch_cmp16_loose;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buy_flag is
    port (
        EQ : in std_logic;
        LT : in std_logic;
        BF : out std_logic
    );
end entity buy_flag;

architecture arch_buy_flag of buy_flag is
begin
    BF <= EQ or LT;
end architecture arch_buy_flag;