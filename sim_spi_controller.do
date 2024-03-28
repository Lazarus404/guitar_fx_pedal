vcom -work work ../spi_controller.vhd
vcom -work work -O0 ./tb_spi_controller.vhd

vsim work.tb_spi_controller \
	-novopt

do wave.do