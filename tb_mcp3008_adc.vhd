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

entity tb_mcp3008_adc is
end tb_mcp3008_adc;

architecture rtl of tb_mcp3008_adc is

component mcp3008_adc
generic(
  N                     : integer := 10;  -- number of bit to serialize
  CLK_DIV               : integer := 10
);
port (
  i_clk                 : in  std_logic;
  i_rstb                : in  std_logic;
  i_miso                : in  std_logic;
  o_mosi                : out std_logic;
  o_sclk                : out std_logic;
  o_cs                  : out std_logic;
  o_pot_0               : out std_logic_vector(N-1 downto 0);
  o_pot_1               : out std_logic_vector(N-1 downto 0);
  o_pot_2               : out std_logic_vector(N-1 downto 0);
  o_pot_3               : out std_logic_vector(N-1 downto 0);
  o_pot_4               : out std_logic_vector(N-1 downto 0);
  o_pot_5               : out std_logic_vector(N-1 downto 0)
);
end component;

constant N              : integer := 10;   -- number of bit to serialize
constant CLK_DIV        : integer := 10;

signal i_clk            : std_logic := '0';
signal i_rstb           : std_logic;
signal o_sclk           : std_logic;
signal o_cs             : std_logic;
signal o_mosi           : std_logic;
signal i_miso           : std_logic := 'Z';
signal o_pot_0          : std_logic_vector(N-1 downto 0);
signal o_pot_1          : std_logic_vector(N-1 downto 0);
signal o_pot_2          : std_logic_vector(N-1 downto 0);
signal o_pot_3          : std_logic_vector(N-1 downto 0);
signal o_pot_4          : std_logic_vector(N-1 downto 0);
signal o_pot_5          : std_logic_vector(N-1 downto 0);
signal mosi_test        : std_logic_vector(N-1 downto 0);  -- tx data
signal miso_test        : std_logic_vector(N-1 downto 0);  -- received data

signal count_rise       : integer;
signal count_fall       : integer;
signal finished         : std_logic := '0';

begin

i_clk     <= not i_clk after 10 ns when finished /= '1' else '0';
i_rstb    <= '0', '1' after 163 ns;
finished  <= '1' after 1 ms;


u_mcp3008_adc : mcp3008_adc
generic map(
  N                => N,
  CLK_DIV          => CLK_DIV
)
port map(
  i_clk            => i_clk,
  i_rstb           => i_rstb,
  i_miso           => i_miso,
  o_mosi           => o_mosi,
  o_sclk           => o_sclk,
  o_cs             => o_cs,
  o_pot_0          => o_pot_0,
  o_pot_1          => o_pot_1,
  o_pot_2          => o_pot_2,
  o_pot_3          => o_pot_3,
  o_pot_4          => o_pot_4,
  o_pot_5          => o_pot_5
);

--------------------------------------------------------------------
-- FSM
p_control_sclk : process(o_sclk)
begin
  if(i_rstb='0') then
    miso_test   <= std_logic_vector(to_unsigned(16#C9#,N));
    mosi_test   <= std_logic_vector(to_unsigned(16#00#,N));
    i_miso      <= '0';
    count_rise  <= 0;
    count_fall  <= 0;
  else
    if(rising_edge(o_sclk)) then
      if(o_cs='0') then
        mosi_test   <= mosi_test(N-2 downto 0)&o_mosi;
        count_rise     <= count_rise+1;
      else
        count_rise     <= 0;
      end if;
    end if;

    if(falling_edge(o_sclk)) then
      if(o_cs='0') then
        miso_test   <= std_logic_vector(rotate_right(unsigned(miso_test),1));
        i_miso      <= miso_test(N-1) after 63 ns;
        count_fall     <= count_fall+1;
      else
        count_fall     <= 0;
      end if;
    end if;
  end if;
end process p_control_sclk;


end rtl;
