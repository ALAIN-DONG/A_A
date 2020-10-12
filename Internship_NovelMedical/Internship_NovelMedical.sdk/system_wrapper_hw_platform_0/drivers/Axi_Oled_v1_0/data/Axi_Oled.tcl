

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "Axi_Oled" "NUM_INSTANCES" "DEVICE_ID"  "C_Axi_OLED_BASEADDR" "C_Axi_OLED_HIGHADDR"
}
