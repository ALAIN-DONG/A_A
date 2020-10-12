# Runtime Tcl commands to interact with - AD_9637_SPI_v1_0

# Sourcing design address info tcl
set bd_path [get_property DIRECTORY [current_project]]/[current_project].srcs/[current_fileset]/bd
source ${bd_path}/AD_9637_SPI_v1_0_include.tcl

# jtag axi master interface hardware name, change as per your design.
set jtag_axi_master hw_axi_1
set ec 0

# hw test script
# Delete all previous axis transactions
if { [llength [get_hw_axi_txns -quiet]] } {
	delete_hw_axi_txn [get_hw_axi_txns -quiet]
}


# Test all lite slaves.
set wdata_1 abcd1234

# Test: AD_9637_SPI
# Create a write transaction at ad_9637_spi_addr address
create_hw_axi_txn w_ad_9637_spi_addr [get_hw_axis $jtag_axi_master] -type write -address $ad_9637_spi_addr -data $wdata_1
# Create a read transaction at ad_9637_spi_addr address
create_hw_axi_txn r_ad_9637_spi_addr [get_hw_axis $jtag_axi_master] -type read -address $ad_9637_spi_addr
# Initiate transactions
run_hw_axi r_ad_9637_spi_addr
run_hw_axi w_ad_9637_spi_addr
run_hw_axi r_ad_9637_spi_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_ad_9637_spi_addr]]
# Compare read data
if { $rdata_tmp == $wdata_1 } {
	puts "Data comparison test pass for - AD_9637_SPI"
} else {
	puts "Data comparison test fail for - AD_9637_SPI, expected-$wdata_1 actual-$rdata_tmp"
	inc ec
}

# Check error flag
if { $ec == 0 } {
	 puts "PTGEN_TEST: PASSED!" 
} else {
	 puts "PTGEN_TEST: FAILED!" 
}

