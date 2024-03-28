-- ******************************************************************** 
-- ******************************************************************** 
-- 
-- Coding style summary:
--
--  i_   Input signal 
--  o_   Output signal 
--  b_   Bi-directional signal 
--  r_   Register signal 
--  w_   Wire signal (no registered logic) 
--  t_   User-Defined Type 
--  p_   pipe
--  pad_ PAD used in the top level
--  G_   Generic (UPPER CASE)
--  C_   Constant (UPPER CASE)
--  ST_  FSM state definition (UPPER CASE)
--
-- ******************************************************************** 
--
-- Copyright ©2024 Jahred Love
--
-- ******************************************************************** 
--
-- Fle Name: tb_mcp3008_adc.vhd
-- 
-- scope: test bench for mcp3008_adc.vhd
--
-- rev 1.00.2024.03.22
-- 
-- ******************************************************************** 
-- ******************************************************************** 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_guitar_fx_pedal is
end tb_guitar_fx_pedal;

architecture rtl of tb_guitar_fx_pedal is

component guitar_fx_pedal
port (
  i_clk                    : in  std_logic;
  i_rstb                   : in  std_logic;
  i_miso                   : in  std_logic;
  o_mosi                   : out std_logic;
  o_sclk                   : out std_logic;
  o_cs                     : out std_logic;
  o_led_00                 : out std_logic;
  o_led_01                 : out std_logic;
  o_led_02                 : out std_logic;
  o_led_03                 : out std_logic;
  o_led_04                 : out std_logic;
  o_led_05                 : out std_logic;
  o_led_06                 : out std_logic;
  o_led_07                 : out std_logic;
  o_led_08                 : out std_logic;
  o_led_09                 : out std_logic
);
end component;


signal i_clk               : std_logic := '0';
signal i_rstb              : std_logic := '0';
signal i_miso              : std_logic := '0';
signal o_mosi              : std_logic;
signal o_sclk              : std_logic;
signal o_cs                : std_logic;
signal o_led_00            : std_logic;
signal o_led_01            : std_logic;
signal o_led_02            : std_logic;
signal o_led_03            : std_logic;
signal o_led_04            : std_logic;
signal o_led_05            : std_logic;
signal o_led_06            : std_logic;
signal o_led_07            : std_logic;
signal o_led_08            : std_logic;
signal o_led_09            : std_logic;
signal mosi_test           : std_logic_vector(9 downto 0);  -- tx data
signal miso_test           : std_logic_vector(9 downto 0);  -- received data

signal count_rise          : integer;
signal count_fall          : integer;
signal finished            : std_logic := '0';

begin

i_clk     <= not i_clk after 10 ns when finished /= '1' else '0';
i_rstb    <= '0', '1' after 163 ns;
finished  <= '1' after 1 ms;


u_guitar_fx_pedal : guitar_fx_pedal
port map(
  i_clk            => i_clk,
  i_rstb           => i_rstb,
  i_miso           => i_miso,
  o_mosi           => o_mosi,
  o_sclk           => o_sclk,
  o_cs             => o_cs,
  o_led_00         => o_led_00,
  o_led_01         => o_led_01,
  o_led_02         => o_led_02,
  o_led_03         => o_led_03,
  o_led_04         => o_led_04,
  o_led_05         => o_led_05,
  o_led_06         => o_led_06,
  o_led_07         => o_led_07,
  o_led_08         => o_led_08,
  o_led_09         => o_led_09
);


--------------------------------------------------------------------
-- FSM
p_control_sclk : process(o_sclk)
begin
  if(i_rstb='0') then
    miso_test   <= "0110000000";
    mosi_test   <= "0000000000";
    i_miso      <= '0';
    count_rise  <= 0;
    count_fall  <= 0;
  else
    if(rising_edge(o_sclk)) then
      if(o_cs='0') then
        mosi_test   <= mosi_test(8 downto 0)&o_mosi;
        count_rise     <= count_rise+1;
      else
        count_rise     <= 0;
      end if;
    end if;

    if(falling_edge(o_sclk)) then
      if(o_cs='0') then
        miso_test   <= std_logic_vector(rotate_right(unsigned(miso_test),1));
        i_miso      <= miso_test(9) after 63 ns;
        count_fall     <= count_fall+1;
      else
        count_fall     <= 0;
      end if;
    end if;
  end if;
end process p_control_sclk;


end rtl;
