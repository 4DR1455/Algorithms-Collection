library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Sell_decider is
end entity;


architecture tb of tb_Sell_decider is
    signal Top_win       : signed(15 downto 0) := (others => '0');
    signal Top_loss      : signed(15 downto 0) := (others => '0');
    signal Acc_change_in : signed(15 downto 0) := (others => '0');
    signal Acc_change_out: signed(15 downto 0) := (others => '0');
    signal change        : signed(15 downto 0) := (others => '0');
    signal GT_loss, LT_loss, EQ_loss : std_logic;
    signal GT_win,  LT_win,  EQ_win  : std_logic;
    signal SF, BF        : std_logic;
    signal clk      : std_logic := '0';
    signal rst_reg, rst_add  : std_logic := '1';
begin
    uut_cmp_win: entity work.cmp16_win
        port map (
            Top_win => Top_win,
            Acc_change => Acc_change_out,
            LT_win => LT_win,
            GT_win => GT_win,
            EQ_win => EQ_win
        );
    uut_cmp_loss: entity work.cmp16_loss
        port map (
            Top_loss => Top_loss,
            Acc_change => Acc_change_out,
            LT_loss => LT_loss,
            GT_loss => GT_loss,
            EQ_loss => EQ_loss
        );
    uut_sf: entity work.sell_flag
        port map (
            GT_win => GT_win,
            EQ_win => EQ_win,
            SF => SF
        );
    uut_lf: entity work.buy_flag
        port map (
            LT_loss => LT_loss,
            EQ_loss => EQ_loss,
            BF => BF
        );
    uut_add: entity work.add
        port map (
            clk => clk,
            rst => rst_add,
            change => change,
            Acc_change_in => Acc_change_in,
            Acc_change_out => Acc_change_out
        );
    uut_reg16: entity work.reg16
        port map (
            clk => clk,
            rst => rst_reg,
            din => Acc_change_out,
            dout => Acc_change_in
        );

    main_stim: process
    begin
        wait for 3 ns;
        Top_win <= to_signed(7, 16);  Top_loss <= to_signed(-2, 16);
        rst_reg <= '0'; rst_add <= '0';
        change <= to_signed(5, 16);  wait for 15 ns;  
        change <= to_signed(2, 16);  wait for 15 ns;  
        change <= to_signed(10, 16);  wait for 15 ns; 
        change <= to_signed(-8, 16); wait for 15 ns;  
        change <= to_signed(-4, 16);  wait for 15 ns;
        change <= to_signed(5, 16); wait for 15 ns;
        wait;
    end process main_stim;
    stim_clk: process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process stim_clk;
end architecture;
