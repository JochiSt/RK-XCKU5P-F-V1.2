LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY blink_top IS
    PORT (
        sys_clk_p : IN STD_LOGIC;
        sys_clk_n : IN STD_LOGIC;
        LED       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        KEY       : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END blink_top;

ARCHITECTURE behaviour OF blink_top IS
    SIGNAL sys_clk_200MHz : STD_LOGIC;  -- system clock 200MHz

BEGIN

    -- create differential clock buffer
    IBUFGDS_0 : entity work.IBUFGDS
    PORT MAP (
        I => sys_clk_p,     -- normal input
        IB => sys_clk_n,    -- inverted input
        O => sys_clk_200MHz -- output
    );

    PROCESS (sys_clk_200MHz) BEGIN
        -- Process implementation goes here
        IF rising_edge(sys_clk_200MHz) THEN
            -- Example logic: Toggle LEDs based on switches
            LED <= KEY;
        END IF;
    END PROCESS;

END ARCHITECTURE; -- behaviour
