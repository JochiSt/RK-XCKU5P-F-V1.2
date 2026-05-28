LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

library unisim;
use UNISIM.vcomponents.all;

ENTITY EthernetRGMII IS
    PORT (
        eth_txd    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        eth_tx_ctl : OUT STD_LOGIC;
        eth_txc    : OUT STD_LOGIC;

        eth_rxd    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        eth_rxc    : IN STD_LOGIC;
        eth_rx_ctl : IN STD_LOGIC;

        sys_clk_p : IN STD_LOGIC;
        sys_clk_n : IN STD_LOGIC;

        LED : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END EthernetRGMII;

ARCHITECTURE behaviour OF EthernetRGMII IS
    ----------------------------------------------------------------------------
    COMPONENT liteeth_core IS
        PORT (
            rgmii_clocks_rx   : IN STD_LOGIC;
            rgmii_clocks_tx   : OUT STD_LOGIC;
            rgmii_int_n       : IN STD_LOGIC;
            rgmii_mdc         : OUT STD_LOGIC;
            rgmii_mdio        : INOUT STD_LOGIC;
            rgmii_rst_n       : OUT STD_LOGIC;
            rgmii_rx_ctl      : IN STD_LOGIC;
            rgmii_rx_data     : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            rgmii_tx_ctl      : OUT STD_LOGIC;
            rgmii_tx_data     : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            sys_clock         : IN STD_LOGIC;
            sys_reset         : IN STD_LOGIC;
            udp0_ip_address   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            udp0_sink_data    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            udp0_sink_last    : IN STD_LOGIC;
            udp0_sink_ready   : OUT STD_LOGIC;
            udp0_sink_valid   : IN STD_LOGIC;
            udp0_source_data  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            udp0_source_error : OUT STD_LOGIC;
            udp0_source_last  : OUT STD_LOGIC;
            udp0_source_ready : IN STD_LOGIC;
            udp0_source_valid : OUT STD_LOGIC;
            udp0_udp_port     : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            udp1_ip_address   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            udp1_sink_data    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            udp1_sink_last    : IN STD_LOGIC;
            udp1_sink_ready   : OUT STD_LOGIC;
            udp1_sink_valid   : IN STD_LOGIC;
            udp1_source_data  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            udp1_source_error : OUT STD_LOGIC;
            udp1_source_last  : OUT STD_LOGIC;
            udp1_source_ready : IN STD_LOGIC;
            udp1_source_valid : OUT STD_LOGIC;
            udp1_udp_port     : IN STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT; -- liteeth_core
    ----------------------------------------------------------------------------
    SIGNAL sys_reset   : STD_LOGIC := '0';
    SIGNAL rgmii_mdc   : STD_LOGIC;
    SIGNAL rgmii_mdio  : STD_LOGIC;
    SIGNAL rgmii_rst_n : STD_LOGIC := '1';
    SIGNAL rgmii_int_n : STD_LOGIC := '0';

    SIGNAL udp0_ip_address   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL udp0_sink_data    : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL udp0_sink_last    : STD_LOGIC                     := '0';
    SIGNAL udp0_sink_ready   : STD_LOGIC                     := '0';
    SIGNAL udp0_sink_valid   : STD_LOGIC                     := '0';
    SIGNAL udp0_source_data  : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL udp0_source_error : STD_LOGIC                     := '0';
    SIGNAL udp0_source_last  : STD_LOGIC                     := '0';
    SIGNAL udp0_source_ready : STD_LOGIC                     := '0';
    SIGNAL udp0_source_valid : STD_LOGIC                     := '0';
    SIGNAL udp0_udp_port     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SIGNAL udp1_ip_address   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL udp1_sink_data    : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL udp1_sink_last    : STD_LOGIC                     := '0';
    SIGNAL udp1_sink_ready   : STD_LOGIC                     := '0';
    SIGNAL udp1_sink_valid   : STD_LOGIC                     := '0';
    SIGNAL udp1_source_data  : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL udp1_source_error : STD_LOGIC                     := '0';
    SIGNAL udp1_source_last  : STD_LOGIC                     := '0';
    SIGNAL udp1_source_ready : STD_LOGIC                     := '0';
    SIGNAL udp1_source_valid : STD_LOGIC                     := '0';
    SIGNAL udp1_udp_port     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    ----------------------------------------------------------------------------
    -- PLL
    SIGNAL sys_clk_200MHz : STD_LOGIC;        -- system clock 200MHz
    SIGNAL pll_200MHz     : STD_LOGIC := '0'; -- PLL clock 200 MHz
    SIGNAL pll_300MHz     : STD_LOGIC := '0'; -- PLL clock 300 MHz

    SIGNAL pll_locked : STD_LOGIC := '0';
    SIGNAL pll_reset  : STD_LOGIC := '0';
    ----------------------------------------------------------------------------
    -- IDELAYCTRL
    SIGNAL idelayctrl_ready : STD_LOGIC := '0';
    SIGNAL idelayctrl_reset : STD_LOGIC := '0';
BEGIN

    -- create differential clock buffer
    IBUFGDS_0 : IBUFGDS
        PORT MAP(
            I  => sys_clk_p,     -- normal input
            IB => sys_clk_n,     -- inverted input
            O  => sys_clk_200MHz -- output
        );

    delay_ref_clock_0 : ENTITY work.delay_ref_clock
        PORT MAP(
            clk_in_200MHz  => sys_clk_200MHz,
            clk_out_200MHz => pll_200MHz,
            clk_out_300MHz => pll_300MHz,

            locked => pll_locked,
            reset  => pll_reset
        );

    ----------------------------------------------------------------------------
    -- IDELAYCTRL
    ----------------------------------------------------------------------------
    PROCESS
    BEGIN
        WAIT UNTIL rising_edge(pll_300MHz);
        idelayctrl_reset <= NOT pll_locked;
    END PROCESS;

    IDELAYCTRL_inst : IDELAYCTRL
        GENERIC MAP(
            SIM_DEVICE => "ULTRASCALE"
        )
        PORT MAP(
            RDY    => idelayctrl_ready, -- 1-bit output: Ready-Signal
            REFCLK => pll_300MHz,       -- 1-bit input: Referenztakt (stabile Frequenz erforderlich)
            RST    => idelayctrl_reset  -- 1-bit input: Reset
        );

    ----------------------------------------------------------------------------
    -- RGMII Ethernet
    ----------------------------------------------------------------------------
    sys_reset <= NOT pll_locked;
    liteeth_core_0 : liteeth_core
    PORT MAP(
        rgmii_clocks_rx => eth_rxc,
        rgmii_clocks_tx => eth_txc,

        rgmii_int_n => rgmii_int_n,

        rgmii_mdc   => rgmii_mdc,
        rgmii_mdio  => rgmii_mdio,
        rgmii_rst_n => rgmii_rst_n,

        rgmii_rx_ctl  => eth_rx_ctl,
        rgmii_rx_data => eth_rxd,

        rgmii_tx_ctl  => eth_tx_ctl,
        rgmii_tx_data => eth_txd,

        sys_clock => pll_200MHz,
        sys_reset => sys_reset,

        udp0_ip_address   => udp0_ip_address,
        udp0_sink_data    => udp0_sink_data,
        udp0_sink_last    => udp0_sink_last,
        udp0_sink_ready   => udp0_sink_ready,
        udp0_sink_valid   => udp0_sink_valid,
        udp0_source_data  => udp0_source_data,
        udp0_source_error => udp0_source_error,
        udp0_source_last  => udp0_source_last,
        udp0_source_ready => udp0_source_ready,
        udp0_source_valid => udp0_source_valid,
        udp0_udp_port     => udp0_udp_port,

        udp1_ip_address   => udp1_ip_address,
        udp1_sink_data    => udp1_sink_data,
        udp1_sink_last    => udp1_sink_last,
        udp1_sink_ready   => udp1_sink_ready,
        udp1_sink_valid   => udp1_sink_valid,
        udp1_source_data  => udp1_source_data,
        udp1_source_error => udp1_source_error,
        udp1_source_last  => udp1_source_last,
        udp1_source_ready => udp1_source_ready,
        udp1_source_valid => udp1_source_valid,
        udp1_udp_port     => udp1_udp_port
    );
END ARCHITECTURE; -- behaviour
