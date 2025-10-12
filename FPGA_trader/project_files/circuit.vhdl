library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp16_win is
    port (
        Top_win   : in  signed(15 downto 0);
        Acc_change   : in  signed(15 downto 0);
        EQ_win  : out std_logic;
        GT_win  : out std_logic;
        LT_win  : out std_logic
    );
end entity cmp16_win;

architecture arch_cmp16_win of cmp16_win is
begin
    EQ_win <= '1' when Top_win = Acc_change else '0';
    GT_win <= '1' when Top_win < Acc_change else '0';
    LT_win <= '1' when Top_win > Acc_change else '0';
end architecture arch_cmp16_win;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sell_flag is
    port (
        EQ_win : in std_logic;
        GT_win : in std_logic;
        SF : out std_logic
    );
end entity sell_flag;

architecture arch_sell_flag of sell_flag is
begin
    SF <= EQ_win or GT_win;
end architecture arch_sell_flag;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp16_loss is
    port (
        Top_loss : in  signed(15 downto 0);
        Acc_change : in  signed(15 downto 0);
        EQ_loss  : out std_logic;
        GT_loss  : out std_logic;
        LT_loss  : out std_logic
    );
end entity cmp16_loss;

architecture arch_cmp16_loss of cmp16_loss is
begin
    EQ_loss <= '1' when Top_loss = Acc_change else '0';
    GT_loss <= '1' when Top_loss < Acc_change else '0';
    LT_loss <= '1' when Top_loss > Acc_change else '0';
end architecture arch_cmp16_loss;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buy_flag is
    port (
        EQ_loss : in std_logic;
        LT_loss : in std_logic;
        BF : out std_logic
    );
end entity buy_flag;

architecture arch_buy_flag of buy_flag is
begin
    BF <= EQ_loss or LT_loss;
end architecture arch_buy_flag;



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
        change : in signed(15 downto 0);
        Acc_change_in : in signed(15 downto 0);
        Acc_change_out : out signed(15 downto 0)
    );
end entity add;

architecture arch_add of add is
    signal result : signed(17 downto 0);
begin
    process(rst, clk, change, Acc_change_in)
    begin
        if rst = '1' then
            result <= (others => '0');
        elsif rising_edge(clk) then
            result <= resize(Acc_change_in, result'length) + resize(change, result'length);
        end if;
    end process;
    Acc_change_out <= result(15 downto 0);
end architecture arch_add;
