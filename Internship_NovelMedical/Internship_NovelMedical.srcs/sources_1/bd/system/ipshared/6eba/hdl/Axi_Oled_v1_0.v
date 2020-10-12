
`timescale 1 ns / 1 ps

	module Axi_Oled_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface Axi_OLED
		parameter integer C_Axi_OLED_DATA_WIDTH	= 32,
		parameter integer C_Axi_OLED_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		output wire [5:0] OLED,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface Axi_OLED
		input wire  axi_oled_aclk,
		input wire  axi_oled_aresetn,
		input wire [C_Axi_OLED_ADDR_WIDTH-1 : 0] axi_oled_awaddr,
		input wire [2 : 0] axi_oled_awprot,
		input wire  axi_oled_awvalid,
		output wire  axi_oled_awready,
		input wire [C_Axi_OLED_DATA_WIDTH-1 : 0] axi_oled_wdata,
		input wire [(C_Axi_OLED_DATA_WIDTH/8)-1 : 0] axi_oled_wstrb,
		input wire  axi_oled_wvalid,
		output wire  axi_oled_wready,
		output wire [1 : 0] axi_oled_bresp,
		output wire  axi_oled_bvalid,
		input wire  axi_oled_bready,
		input wire [C_Axi_OLED_ADDR_WIDTH-1 : 0] axi_oled_araddr,
		input wire [2 : 0] axi_oled_arprot,
		input wire  axi_oled_arvalid,
		output wire  axi_oled_arready,
		output wire [C_Axi_OLED_DATA_WIDTH-1 : 0] axi_oled_rdata,
		output wire [1 : 0] axi_oled_rresp,
		output wire  axi_oled_rvalid,
		input wire  axi_oled_rready
	);
// Instantiation of Axi Bus Interface Axi_OLED
	Axi_Oled_v1_0_Axi_OLED # ( 
		.C_S_AXI_DATA_WIDTH(C_Axi_OLED_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_Axi_OLED_ADDR_WIDTH)
	) Axi_Oled_v1_0_Axi_OLED_inst (
		.OLED(OLED),
		.S_AXI_ACLK(axi_oled_aclk),
		.S_AXI_ARESETN(axi_oled_aresetn),
		.S_AXI_AWADDR(axi_oled_awaddr),
		.S_AXI_AWPROT(axi_oled_awprot),
		.S_AXI_AWVALID(axi_oled_awvalid),
		.S_AXI_AWREADY(axi_oled_awready),
		.S_AXI_WDATA(axi_oled_wdata),
		.S_AXI_WSTRB(axi_oled_wstrb),
		.S_AXI_WVALID(axi_oled_wvalid),
		.S_AXI_WREADY(axi_oled_wready),
		.S_AXI_BRESP(axi_oled_bresp),
		.S_AXI_BVALID(axi_oled_bvalid),
		.S_AXI_BREADY(axi_oled_bready),
		.S_AXI_ARADDR(axi_oled_araddr),
		.S_AXI_ARPROT(axi_oled_arprot),
		.S_AXI_ARVALID(axi_oled_arvalid),
		.S_AXI_ARREADY(axi_oled_arready),
		.S_AXI_RDATA(axi_oled_rdata),
		.S_AXI_RRESP(axi_oled_rresp),
		.S_AXI_RVALID(axi_oled_rvalid),
		.S_AXI_RREADY(axi_oled_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
