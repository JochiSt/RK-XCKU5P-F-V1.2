
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY tb_blink IS
END tb_blink;

ARCHITECTURE behaviour OF tb_blink IS
    SIGNAL clk        : STD_LOGIC := '0';
    SIGNAL blinking_0 : STD_LOGIC := '0';

BEGIN
    blink_0 : entity work.blink
    GENERIC MAP(
        max_count => 10
    )
    PORT MAP(
        clk       => clk,
        blink_out => blinking_0
    );

    p_clk : PROCESS
    BEGIN
        WAIT FOR 2.5 ns;
        clk <= NOT clk;
    END PROCESS p_clk;

END ARCHITECTURE; -- arch
