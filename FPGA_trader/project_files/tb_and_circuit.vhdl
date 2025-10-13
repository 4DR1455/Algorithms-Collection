library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FPGA_trader is
end entity;


architecture tb of tb_FPGA_trader is
    signal Top_win : signed(15 downto 0) := (others => '0');
    signal Top_loss : signed(15 downto 0) := (others => '0');
    signal Acc_change_in : signed(15 downto 0) := (others => '0');
    signal Acc_change_out : signed(15 downto 0) := (others => '0');
    signal change : signed(15 downto 0) := (others => '0');
    signal GT_loss, LT_loss, EQ_loss : std_logic;
    signal GT_win,  LT_win,  EQ_win : std_logic;
    signal SF, BF : std_logic;
    signal SF_raw, BF_raw : std_logic;
    signal clk : std_logic := '0';
    signal rst_reg, rst_add : std_logic := '1';
    signal flag : std_logic := '0';
    signal p_change : signed(15 downto 0) := (others => '0');
    signal lt_change, gt_change, no_change : std_logic;
    signal valid_flags : std_logic := '0'; --validation mask. Maybe usefull when implementing overflow management.
begin
    uut_cmp_win: entity work.cmp16
        port map (
            A => Top_win,
            B => Acc_change_out,
            LT => LT_win,
            GT => GT_win,
            EQ => EQ_win
        );
    uut_cmp_loss: entity work.cmp16
        port map (
            A => Top_loss,
            B => Acc_change_out,
            LT => LT_loss,
            GT => GT_loss,
            EQ => EQ_loss
        );
    uut_sf: entity work.or_gate
        port map (
            A => GT_win,
            B => EQ_win,
            F => SF_raw
        );
    uut_lf: entity work.or_gate
        port map (
            A => LT_loss,
            B => EQ_loss,
            F => BF_raw
        );
    uut_add: entity work.add
        port map (
            clk => flag,
            rst => rst_add,
            A => change,
            B => Acc_change_in,
            R => Acc_change_out
        );
    uut_reg_ac: entity work.reg16
        port map (
            clk => clk,
            rst => rst_reg,
            din => Acc_change_out,
            dout => Acc_change_in
        );
    uut_reg_prevchange: entity work.reg16
        port map (
            clk => clk,
            rst => rst_reg,
            din => change,
            dout => p_change
        );
    --Maybe I can use this comparer to manage overflow at add.
    uut_change_cmp: entity work.cmp16
        port map (
            A => change,
            B => p_change,
            LT => lt_change,
            GT => gt_change,
            EQ => no_change
        );
    uut_add_flag: entity work.or_gate
        port map (
            A => lt_change,
            B => gt_change,
            F => flag
        );
    BF <= BF_raw when valid_flags = '1' else '0';
    SF <= SF_raw when valid_flags = '1' else '0';
    main_stim: process
    begin
        wait for 3 ns;
        Top_win <= to_signed(7, 16);  Top_loss <= to_signed(-2, 16);
        rst_reg <= '0'; rst_add <= '0';
        wait for 1 ns;
        valid_flags <= '1';
        change <= to_signed(5, 16);  wait for 15 ns;  
        change <= to_signed(2, 16);  wait for 15 ns;  
        change <= to_signed(0, 16);  wait for 15 ns; 
        change <= to_signed(-8, 16); wait for 15 ns;  
        change <= to_signed(-6, 16);  wait for 15 ns;
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
