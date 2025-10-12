library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Sell_decider is
end entity;

architecture tb of tb_Sell_decider is
    signal Top_win, Acc_change, Top_loss : signed(15 downto 0) := (others => '0');
    signal GT_loss, LT_loss, EQ_loss : std_logic;
    signal GT_win, LT_win, EQ_win : std_logic;
    signal SF : std_logic;
    signal BF : std_logic;
begin
    uut1: entity work.cmp16_win
        port map (
            Top_win => Top_win,
            Acc_change => Acc_change,
            LT_win => LT_win,
            GT_win => GT_win,
            EQ_win => EQ_win
        );
    uut2: entity work.cmp16_loss
        port map (
            Top_loss => Top_loss,
            Acc_change => Acc_change,
            LT_loss => LT_loss,
            GT_loss => GT_loss,
            EQ_loss => EQ_loss
        );
    uut3: entity work.sell_flag
        port map (
            GT_win => GT_win,
            EQ_win => EQ_win,
            SF => SF
        );
    uut4: entity work.buy_flag
        port map (
            LT_loss => LT_loss,
            EQ_loss => EQ_loss,
            BF => BF
        );

    stim: process
    begin
        Top_win <= to_signed(7, 16);  Top_loss <= to_signed(-2, 16);
        Acc_change <= to_signed(5, 16);  wait for 10 ns;  
        Acc_change <= to_signed(2, 16);  wait for 10 ns;  
        Acc_change <= to_signed(10, 16);  wait for 10 ns; 
        Acc_change <= to_signed(-8, 16); wait for 10 ns;  
        Acc_change <= to_signed(-4, 16);  wait for 10 ns;
        Acc_change <= to_signed(5, 16); wait for 10 ns;
        wait;
    end process;
end architecture;
