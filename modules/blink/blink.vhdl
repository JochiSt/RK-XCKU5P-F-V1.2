LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY blink IS
    GENERIC (
        max_count : POSITIVE := 100_000_000
    );
    PORT (
        clk       : IN STD_LOGIC;
        blink_out : OUT STD_LOGIC
    );
END blink;

ARCHITECTURE behaviour OF blink IS

    SIGNAL cnt       : NATURAL RANGE 0 TO max_count := 0;
    SIGNAL blink_int : STD_LOGIC                    := '0';

BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN

            IF cnt = 0 THEN
                blink_int <= NOT blink_int;
            END IF;
            IF cnt = max_count THEN
                cnt <= 0;
            ELSE
                cnt <= cnt + 1;
            END IF;
        END IF;
    END PROCESS;

    blink_out <= blink_int;

END ARCHITECTURE; -- arch
