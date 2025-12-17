LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY blink_top IS
    PORT (
        SYS_CLK : IN STD_LOGIC;
        LED     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SW      : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END blink_top;

ARCHITECTURE behaviour OF blink_top IS

BEGIN

    PROCESS (SYS_CLK) BEGIN
        -- Process implementation goes here
        IF rising_edge(SYS_CLK) THEN
            -- Example logic: Toggle LEDs based on switches
            LED <= SW;
        END IF;
    END PROCESS;

END ARCHITECTURE; -- behaviour
