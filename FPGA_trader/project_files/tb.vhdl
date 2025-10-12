library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Sell_decider is
end entity;

architecture tb of tb_Sell_decider is
    signal A, B, C : signed(15 downto 0) := (others => '0');
    signal GT, LT, EQ : std_logic;
    signal SF : std_logic;
    signal BF : std_logic;
begin
    uut1: entity work.cmp16_win
        port map (
            Top_win => A,
            Acc_change => B,
            LT => LT,
            GT => GT,
            EQ => EQ
        );
    uut2: entity work.cmp16_loose
        port map (
            Top_loose => C,
            Acc_change => B,
            LT => LT,
            GT => GT,
            EQ => EQ
        );
    uut3: entity work.sell_flag
        port map (
            GT => GT,
            EQ => EQ,
            SF => SF
        );
    uut4: entity work.buy_flag
        port map (
            LT => LT,
            EQ => EQ,
            BF => BF
        );

    stim: process
    begin
        A <= to_signed(7, 16);  C <= to_signed(2, 16);
        B <= to_signed(5, 16);  wait for 10 ns;  
        B <= to_signed(2, 16);  wait for 10 ns;  
        B <= to_signed(10, 16);  wait for 10 ns; 
        B <= to_signed(-8, 16); wait for 10 ns;  
        B <= to_signed(-4, 16);  wait for 10 ns;
        B <= to_signed(5, 16); wait for 10 ns;
        wait;
    end process;
end architecture;
