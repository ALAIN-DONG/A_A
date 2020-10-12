
`timescale 1 ns / 1 ps

	module AD_9637_SPI_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface AD_9637_SPI
		parameter integer C_AD_9637_SPI_DATA_WIDTH	= 32,
		parameter integer C_AD_9637_SPI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		output	wire	spi_cs0,
		output	wire	spi_cs1,
		output	wire	spi_sclk,
		inout			spi_sdio,
		output	wire	done,
		output	wire	AD_PD_out,
		output	wire	AD_SYNC_out,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface AD_9637_SPI
		input wire  ad_9637_spi_aclk,
		input wire  ad_9637_spi_aresetn,
		input wire [C_AD_9637_SPI_ADDR_WIDTH-1 : 0] ad_9637_spi_awaddr,
		input wire [2 : 0] ad_9637_spi_awprot,
		input wire  ad_9637_spi_awvalid,
		output wire  ad_9637_spi_awready,
		input wire [C_AD_9637_SPI_DATA_WIDTH-1 : 0] ad_9637_spi_wdata,
		input wire [(C_AD_9637_SPI_DATA_WIDTH/8)-1 : 0] ad_9637_spi_wstrb,
		input wire  ad_9637_spi_wvalid,
		output wire  ad_9637_spi_wready,
		output wire [1 : 0] ad_9637_spi_bresp,
		output wire  ad_9637_spi_bvalid,
		input wire  ad_9637_spi_bready,
		input wire [C_AD_9637_SPI_ADDR_WIDTH-1 : 0] ad_9637_spi_araddr,
		input wire [2 : 0] ad_9637_spi_arprot,
		input wire  ad_9637_spi_arvalid,
		output wire  ad_9637_spi_arready,
		output wire [C_AD_9637_SPI_DATA_WIDTH-1 : 0] ad_9637_spi_rdata,
		output wire [1 : 0] ad_9637_spi_rresp,
		output wire  ad_9637_spi_rvalid,
		input wire  ad_9637_spi_rready
	);
	
		wire 		clk_to_spi;
		wire [5:0]	div_par_r;
		wire		rst_n_to_spi;
	
// Instantiation of Axi Bus Interface AD_9637_SPI
	AD_9637_SPI_v1_0_AD_9637_SPI # ( 
		.C_S_AXI_DATA_WIDTH(C_AD_9637_SPI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_AD_9637_SPI_ADDR_WIDTH)
	) AD_9637_SPI_v1_0_AD_9637_SPI_inst (
		.spi_cs0(spi_cs0),
		.spi_cs1(spi_cs1),
		.spi_sclk(spi_sclk),
		.spi_sdio(spi_sdio),
		.done(done),
		.AD_PD_out(AD_PD_out),
		.AD_SYNC_out(AD_SYNC_out),
	
		.S_AXI_ACLK(ad_9637_spi_aclk),
		.S_AXI_ARESETN(ad_9637_spi_aresetn),//
		.S_AXI_AWADDR(ad_9637_spi_awaddr),
		.S_AXI_AWPROT(ad_9637_spi_awprot),
		.S_AXI_AWVALID(ad_9637_spi_awvalid),
		.S_AXI_AWREADY(ad_9637_spi_awready),
		.S_AXI_WDATA(ad_9637_spi_wdata),
		.S_AXI_WSTRB(ad_9637_spi_wstrb),
		.S_AXI_WVALID(ad_9637_spi_wvalid),
		.S_AXI_WREADY(ad_9637_spi_wready),
		.S_AXI_BRESP(ad_9637_spi_bresp),
		.S_AXI_BVALID(ad_9637_spi_bvalid),
		.S_AXI_BREADY(ad_9637_spi_bready),
		.S_AXI_ARADDR(ad_9637_spi_araddr),
		.S_AXI_ARPROT(ad_9637_spi_arprot),
		.S_AXI_ARVALID(ad_9637_spi_arvalid),
		.S_AXI_ARREADY(ad_9637_spi_arready),
		.S_AXI_RDATA(ad_9637_spi_rdata),
		.S_AXI_RRESP(ad_9637_spi_rresp),
		.S_AXI_RVALID(ad_9637_spi_rvalid),
		.S_AXI_RREADY(ad_9637_spi_rready)
	);

	// Add user logic here
	// User logic ends

	endmodule
