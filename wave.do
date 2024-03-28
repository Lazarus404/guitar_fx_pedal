onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_controller/i_clk
add wave -noupdate /tb_spi_controller/i_rstb
add wave -noupdate /tb_spi_controller/i_tx_start
add wave -noupdate /tb_spi_controller/o_tx_end
add wave -noupdate -radix hexadecimal /tb_spi_controller/i_data_parallel
add wave -noupdate -radix hexadecimal /tb_spi_controller/mosi_test
add wave -noupdate /tb_spi_controller/o_sclk
add wave -noupdate /tb_spi_controller/o_mosi
add wave -noupdate /tb_spi_controller/o_ss
add wave -noupdate /tb_spi_controller/count_rise
add wave -noupdate /tb_spi_controller/count_fall
add wave -noupdate /tb_spi_controller/i_miso
add wave -noupdate -radix hexadecimal /tb_spi_controller/o_data_parallel
add wave -noupdate -radix hexadecimal /tb_spi_controller/miso_test
add wave -noupdate /tb_spi_controller/N
add wave -noupdate /tb_spi_controller/CLK_DIV
add wave -noupdate -radix unsigned /tb_spi_controller/p_control/v_control
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /tb_spi_controller/u_spi_controller/N
add wave -noupdate /tb_spi_controller/u_spi_controller/CLK_DIV
add wave -noupdate /tb_spi_controller/u_spi_controller/o_sclk
add wave -noupdate /tb_spi_controller/o_ss
add wave -noupdate /tb_spi_controller/u_spi_controller/o_mosi
add wave -noupdate -radix hexadecimal /tb_spi_controller/u_spi_controller/i_data_parallel
add wave -noupdate -radix hexadecimal /tb_spi_controller/u_spi_controller/o_data_parallel
add wave -noupdate /tb_spi_controller/u_spi_controller/r_counter_clock
add wave -noupdate /tb_spi_controller/u_spi_controller/r_sclk_rise
add wave -noupdate /tb_spi_controller/u_spi_controller/r_sclk_fall
add wave -noupdate /tb_spi_controller/u_spi_controller/r_counter_clock_ena
add wave -noupdate /tb_spi_controller/u_spi_controller/r_counter_data
add wave -noupdate /tb_spi_controller/u_spi_controller/w_tc_counter_data
add wave -noupdate /tb_spi_controller/u_spi_controller/r_st_present
add wave -noupdate /tb_spi_controller/u_spi_controller/w_st_next
add wave -noupdate /tb_spi_controller/u_spi_controller/r_tx_start
add wave -noupdate /tb_spi_controller/u_spi_controller/i_miso
add wave -noupdate -radix hexadecimal /tb_spi_controller/u_spi_controller/r_rx_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {492815 ns} 0}
configure wave -namecolwidth 306
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {491817 ns} {494044 ns}
