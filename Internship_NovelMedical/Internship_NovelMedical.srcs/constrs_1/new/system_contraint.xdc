# // SPI out
set_property PACKAGE_PIN E15 [get_ports {done[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {done[0]}]

set_property PACKAGE_PIN J17 [get_ports spi_cs0]
set_property IOSTANDARD LVCMOS25 [get_ports spi_cs0]
set_property PACKAGE_PIN J16 [get_ports spi_cs1]
set_property IOSTANDARD LVCMOS25 [get_ports spi_cs1]
set_property PACKAGE_PIN K21 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS25 [get_ports spi_sclk]
set_property PACKAGE_PIN J20 [get_ports spi_sdio]
set_property IOSTANDARD LVCMOS25 [get_ports spi_sdio]

set_property PACKAGE_PIN M17 [get_ports AD_PD_out]
set_property IOSTANDARD LVCMOS25 [get_ports AD_PD_out]
set_property PACKAGE_PIN L17 [get_ports AD_SYNC_out]
set_property IOSTANDARD LVCMOS25 [get_ports AD_SYNC_out]



# // Interface In
set_property PACKAGE_PIN L21 [get_ports {adc0_data_in_p[0]}]
set_property PACKAGE_PIN M19 [get_ports {adc0_data_in_p[1]}]
set_property PACKAGE_PIN P17 [get_ports {adc0_data_in_p[2]}]
set_property PACKAGE_PIN N22 [get_ports {adc0_data_in_p[3]}]
set_property PACKAGE_PIN J21 [get_ports {adc0_data_in_p[4]}]
set_property PACKAGE_PIN T16 [get_ports {adc0_data_in_p[5]}]
set_property PACKAGE_PIN R20 [get_ports {adc0_data_in_p[6]}]
set_property PACKAGE_PIN P20 [get_ports {adc0_data_in_p[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc0_data_in_p[0]}]
set_property PACKAGE_PIN G19 [get_ports {adc1_data_in_p[0]}]
set_property PACKAGE_PIN E19 [get_ports {adc1_data_in_p[1]}]
set_property PACKAGE_PIN F18 [get_ports {adc1_data_in_p[2]}]
set_property PACKAGE_PIN D22 [get_ports {adc1_data_in_p[3]}]
set_property PACKAGE_PIN C17 [get_ports {adc1_data_in_p[4]}]
set_property PACKAGE_PIN A16 [get_ports {adc1_data_in_p[5]}]
set_property PACKAGE_PIN C15 [get_ports {adc1_data_in_p[7]}]
set_property PACKAGE_PIN B16 [get_ports {adc1_data_in_p[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc1_data_in_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports adc0_dco_in_p]
set_property PACKAGE_PIN N19 [get_ports adc0_dco_in_p]
set_property PACKAGE_PIN D20 [get_ports adc1_dco_in_p]
set_property IOSTANDARD LVDS_25 [get_ports adc1_dco_in_p]
set_property PACKAGE_PIN A18 [get_ports adc1_fco_in_p]
set_property IOSTANDARD LVDS_25 [get_ports adc1_fco_in_p]
set_property PACKAGE_PIN M21 [get_ports adc0_fco_in_p]
set_property IOSTANDARD LVDS_25 [get_ports adc0_fco_in_p]

# //interface out
set_property PACKAGE_PIN N17 [get_ports clk_to_adc0_p]
set_property PACKAGE_PIN B21 [get_ports clk_to_adc1_p]

set_property IOSTANDARD LVCMOS33 [get_ports {led_data_show[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_data_show[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_data_show[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_data_show[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_data_show[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_data_show[5]}]
set_property PACKAGE_PIN T22 [get_ports {led_data_show[0]}]
set_property PACKAGE_PIN T21 [get_ports {led_data_show[1]}]
set_property PACKAGE_PIN U22 [get_ports {led_data_show[2]}]
set_property PACKAGE_PIN U21 [get_ports {led_data_show[3]}]
set_property PACKAGE_PIN V22 [get_ports {led_data_show[4]}]
set_property PACKAGE_PIN W22 [get_ports {led_data_show[5]}]

#//oled
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_0[0]}]
set_property PACKAGE_PIN U12 [get_ports {OLED_0[5]}]
set_property PACKAGE_PIN U11 [get_ports {OLED_0[4]}]
set_property PACKAGE_PIN AA12 [get_ports {OLED_0[3]}]
set_property PACKAGE_PIN AB12 [get_ports {OLED_0[2]}]
set_property PACKAGE_PIN U9 [get_ports {OLED_0[1]}]
set_property PACKAGE_PIN U10 [get_ports {OLED_0[0]}]

