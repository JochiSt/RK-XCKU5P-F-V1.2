LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY delay_ref_clock IS
  PORT (
    clk_in_200MHz  : IN STD_LOGIC;
    clk_out_200MHz : OUT STD_LOGIC;
    clk_out_300MHz : OUT STD_LOGIC;

    locked : OUT STD_LOGIC;
    reset  : IN STD_LOGIC
  );
END delay_ref_clock;

ARCHITECTURE behaviour OF delay_ref_clock IS

  SIGNAL clk_out_200MHz_internal : STD_LOGIC;
  SIGNAL clk_out_300MHz_internal : STD_LOGIC;

  SIGNAL clk_fbout : STD_LOGIC;

  SIGNAL locked_int : STD_LOGIC;

BEGIN
  locked <= locked_int;

  MMCME4_ADV_0 : ENTITY work.MMCME4_ADV
    GENERIC MAP(
      BANDWIDTH            => "OPTIMIZED",
      CLKOUT4_CASCADE      => "FALSE",
      COMPENSATION         => "AUTO",
      STARTUP_WAIT         => "FALSE",
      DIVCLK_DIVIDE        => 1,
      CLKFBOUT_MULT_F      => 6.000,
      CLKFBOUT_PHASE       => 0.000,
      CLKFBOUT_USE_FINE_PS => "FALSE",
      CLKOUT0_DIVIDE_F     => 6.000,
      CLKOUT0_PHASE        => 0.000,
      CLKOUT0_DUTY_CYCLE   => 0.500,
      CLKOUT0_USE_FINE_PS  => "FALSE",
      CLKOUT1_DIVIDE       => 4,
      CLKOUT1_PHASE        => 0.000,
      CLKOUT1_DUTY_CYCLE   => 0.500,
      CLKOUT1_USE_FINE_PS  => "FALSE",
      CLKIN1_PERIOD        => 10.000
    )
    PORT MAP(
      CLKFBOUT  => clk_fbout,
      CLKFBOUTB => OPEN,
      CLKOUT0   => clk_out_200MHz_internal,
      CLKOUT0B  => OPEN,
      CLKOUT1   => clk_out_300MHz_internal,
      CLKOUT1B  => OPEN,
      CLKOUT2   => OPEN,
      CLKOUT2B  => OPEN,
      CLKOUT3   => OPEN,
      CLKOUT3B  => OPEN,
      CLKOUT4   => OPEN,
      CLKOUT5   => OPEN,
      CLKOUT6   => OPEN,
      -- Input clock control
      CLKFBIN => clk_fbout,
      CLKIN1  => clk_in_200MHz,
      CLKIN2  => '0',
      -- Tied to always select the primary input clock
      CLKINSEL => '1',
      -- Ports for dynamicreconfiguration
      DADDR    => "0000000",
      DCLK     => '0',
      DEN      => '0',
      DI       => "0000000000000000",
      DO       => OPEN,
      DRDY     => OPEN,
      DWE      => '0',
      CDDCDONE => '0',
      CDDCREQ  => '0',
      -- Ports for dynamic phase shift
      PSCLK    => '0',
      PSEN     => '0',
      PSINCDEC => '0',
      PSDONE   => OPEN,
      -- Other control and status signals
      LOCKED       => locked_int,
      CLKINSTOPPED => OPEN,
      CLKFBSTOPPED => OPEN,
      PWRDWN       => '0',
      RST          => reset
    );

  -- BUFGCE_100MHz : ENTITY work.BUFGCE
  --   PORT MAP(
  --     CE => '1',
  --     I  => clk_out_100MHz_internal,
  --     O  => clk_out_100MHz
  --   );
    clk_out_200MHz <= clk_out_200MHz_internal;

  -- BUFGCE_200MHz : ENTITY work.BUFGCE
  --   PORT MAP(
  --     CE => '1',
  --     I  => clk_out_200MHz_internal,
  --     O  => clk_out_200MHz
  --   );
    clk_out_300MHz <= clk_out_300MHz_internal;

END ARCHITECTURE; -- arch
