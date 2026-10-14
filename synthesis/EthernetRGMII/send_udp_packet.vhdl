-- send_udp_packet.vhd
-- Erzeugt periodisch ein UDP-Paket mit PAYLOAD_BYTES Bytes und gibt es per
-- AXI-Stream-ähnlichem Handshake (valid/ready/last) an den LiteEth-Streamer.
--
-- Payload: Byte 0 = Paketzähler (low byte), Byte n = n (Index im Paket).
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY send_udp_packet IS
  GENERIC (
    CLK_FREQ_HZ   : POSITIVE := 200_000_000; -- needs to match sys_clk of core
    PAYLOAD_BYTES : POSITIVE := 64;
    PACKETS_PER_S : POSITIVE := 1000
  );
  PORT (
    clk      : IN  STD_LOGIC;
    rst      : IN  STD_LOGIC; -- synchronous, active high
    tx_valid : OUT STD_LOGIC;
    tx_ready : IN  STD_LOGIC;
    tx_last  : OUT STD_LOGIC;
    tx_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE rtl OF send_udp_packet IS
  CONSTANT PERIOD_CYCLES : POSITIVE := CLK_FREQ_HZ / PACKETS_PER_S;

  TYPE state_t IS (S_WAIT, S_SEND);
  SIGNAL state : state_t := S_WAIT;
  SIGNAL timer : NATURAL RANGE 0 TO PERIOD_CYCLES := 0;
  SIGNAL idx : NATURAL RANGE 0 TO PAYLOAD_BYTES - 1 := 0;
  SIGNAL pkt_cnt : unsigned(7 DOWNTO 0) := (OTHERS => '0');
BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        state <= S_WAIT;
        timer <= 0;
        idx <= 0;
        pkt_cnt <= (OTHERS => '0');
      ELSE
        CASE state IS
          WHEN S_WAIT =>
            IF timer = PERIOD_CYCLES - 1 THEN
              timer <= 0;
              idx <= 0;
              state <= S_SEND;
            ELSE
              timer <= timer + 1;
            END IF;

          WHEN S_SEND =>
            -- Ein Byte wird übernommen, wenn valid='1' und ready='1'
            IF tx_ready = '1' THEN
              IF idx = PAYLOAD_BYTES - 1 THEN
                pkt_cnt <= pkt_cnt + 1;
                state <= S_WAIT;
              ELSE
                idx <= idx + 1;
              END IF;
            END IF;
        END CASE;
      END IF;
    END IF;
  END PROCESS;

  tx_valid <= '1' WHEN state = S_SEND ELSE
              '0';
  tx_last <= '1' WHEN state = S_SEND AND idx = PAYLOAD_BYTES - 1 ELSE
             '0';
  tx_data <= STD_LOGIC_VECTOR(pkt_cnt) WHEN idx = 0
             ELSE
             STD_LOGIC_VECTOR(to_unsigned(idx, 8));

END ARCHITECTURE;
