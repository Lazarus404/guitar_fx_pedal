library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_spi_controller is
end tb_spi_controller;

architecture rtl of tb_spi_controller is

component spi_controller
generic(
  N                     : integer := 10;      -- number of bit to serialize
  CLK_DIV               : integer := 10 );  -- input clock divider to generate output serial clock; o_sclk frequency = i_clk/(2*CLK_DIV)
port (
  i_clk                       : in  std_logic;
  i_rstb                      : in  std_logic;
  i_tx_start                  : in  std_logic;  -- start TX on serial line
  o_tx_end                    : out std_logic;  -- TX data completed; o_data_parallel available
  i_buffer                    : in  std_logic_vector(N-1 downto 0);  -- data to sent
  o_buffer                    : out std_logic_vector(N-1 downto 0);  -- received data
  o_sclk                      : out std_logic;
  o_cs                        : out std_logic;
  o_mosi                      : out std_logic;
  i_miso                      : in  std_logic);
end component;

constant N                     : integer := 10;      -- number of bit to serialize
constant CLK_DIV               : integer := 10;  -- input clock divider to generate output serial clock; o_sclk frequency = i_clk/(2*CLK_DIV)

signal i_clk                       : std_logic:='0';
signal i_rstb                      : std_logic;
signal i_tx_start                  : std_logic;  -- start TX on serial line
signal o_tx_end                    : std_logic;  -- TX data completed; o_data_parallel available
signal i_buffer                    : std_logic_vector(N-1 downto 0);  -- data to sent
signal o_buffer                    : std_logic_vector(N-1 downto 0);  -- received data
signal o_sclk                      : std_logic;
signal o_cs                        : std_logic;
signal o_mosi                      : std_logic;
signal i_miso                      : std_logic;

signal mosi_test                   : std_logic_vector(N-1 downto 0);  -- tx data
signal miso_test                   : std_logic_vector(N-1 downto 0);  -- received data
signal finished                    : std_logic := '0';

begin

i_clk     <= not i_clk after 5 ns when finished /= '1' else '0';
i_rstb    <= '0', '1' after 163 ns;
finished  <= '1' after 1 ms;


u_spi_controller : spi_controller
generic map(
  N                     => N                     ,
  CLK_DIV               => CLK_DIV               )
port map(
  i_clk                       => i_clk                       ,
  i_rstb                      => i_rstb                      ,
  i_tx_start                  => i_tx_start                  ,
  o_tx_end                    => o_tx_end                    ,
  i_buffer                    => i_buffer                    ,
  o_buffer                    => o_buffer                    ,
  o_sclk                      => o_sclk                      ,
  o_cs                        => o_cs                        ,
  o_mosi                      => o_mosi                      ,
  i_miso                      => i_miso                      );


--------------------------------------------------------------------
-- FSM
p_control : process(i_clk,i_rstb)
variable v_control         : unsigned(8 downto 0);
begin
  if (i_rstb = '0') then
    v_control         := (others=>'0');
    i_tx_start        <= '0';
    i_buffer          <= std_logic_vector(to_unsigned(16#92#,N));
  elsif (rising_edge(i_clk)) then
    v_control         := v_control + 1;
    if (v_control = 10) then
      i_tx_start      <= '1';
    else
      i_tx_start      <= '0';
    end if;
    
    if (o_tx_end = '1') then
      i_buffer        <= std_logic_vector(unsigned(i_buffer)+1);
    end if;
  end if;
end process p_control;

p_control_sclk : process(o_sclk)
begin
  if (i_rstb = '0') then
    miso_test         <= std_logic_vector(to_unsigned(16#C9#,N));
    mosi_test         <= std_logic_vector(to_unsigned(16#00#,N));
    i_miso            <= '0';
  else
    if (falling_edge(o_sclk)) then
      if (o_cs = '0') then
        mosi_test     <= mosi_test(N-2 downto 0) & o_mosi;
        miso_test     <= std_logic_vector(rotate_right(unsigned(miso_test),1));
        i_miso        <= miso_test(N-1) after 63 ns;
      end if;
    end if;
  end if;
end process p_control_sclk;


end rtl;
