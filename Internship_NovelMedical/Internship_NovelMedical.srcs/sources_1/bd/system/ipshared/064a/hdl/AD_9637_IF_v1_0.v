
`timescale 1 ns / 1 ps

	module AD_9637_IF_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
		
		// Add user logic here
		// to 	1: AD_9637_DeSerializer
		//		2: AD_9637_IF_v1_0_S00_AXI
		//		3: out to processing module
		//		4: out to chip
		input	wire				clk_160M,		
		input	wire 	[7:0]		adc0_data_in_p,	
		input	wire 	[7:0]		adc0_data_in_n,	
		input	wire 	[7:0]		adc1_data_in_p,
		input	wire 	[7:0]		adc1_data_in_n,
		input	wire 				adc0_fco_in_p,
		input	wire 				adc0_fco_in_n,
		input	wire 				adc1_fco_in_p,
		input	wire 				adc1_fco_in_n,
		input	wire 				adc0_dco_in_p,
		input	wire 				adc0_dco_in_n,
		input	wire 				adc1_dco_in_p,
		input	wire 				adc1_dco_in_n,
		output	wire				clk_to_adc0_p,
		output	wire				clk_to_adc0_n,
		output	wire				clk_to_adc1_p,
		output	wire				clk_to_adc1_n,
		output	wire	[5:0]		led_data_show,
		
		input 	wire				M_AXIS_tready,
		output	wire	[3:0]		M_AXIS_tkeep,
		output	wire				M_AXIS_tlast,
		output	wire				M_AXIS_tvalid,
		output	wire	[31:0]		M_AXIS_tdata,
		output	wire				M_AXIS_aresetn,
		output	wire				M_AXIS_aclk,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
	// user wire and regs definition
			//from S00_axi
	wire				serdes_rst_r;  		
	wire				serdes_rst_pls; 	
	wire				serdes_rst;  		
	
	wire				delayctrl_rst_r;	
	wire				delayctrl_rst;		
	wire				delayctrl_rst_pls;	
	
	wire	[15:0]		idelay_ld_r;		
	wire	[15:0]		idelay_ld_pls;		
	
	wire	[15:0]		idelay_inc_r;		
	wire	[15:0]		idelay_inc_pls;		
	
	wire	[15:0]		idelay_ce_r; 		
	wire	[15:0]		idelay_ce_pls;		
	
	wire	[79:0]		idelay_cntvaluein_r;
	
	wire	[15:0]		bitslip_r;			
	
	wire	[15:0]		serdes_ce_r;		
	
	wire	[15:0]		bit_order_r;		
	
	wire	[7:0]		adc0_data_ready;	
	wire	[7:0]		adc1_data_ready;	
	
	wire	[79:0]		idelay_cntvalueout_r;	
	wire				delay_locked;			
	
	wire	[95:0]		data_paral_adc0;	
	wire	[95:0]		data_paral_adc1;	
	wire	[7:0]		adc0_clk_to_data_process;	
	wire	[7:0]		adc1_clk_to_data_process;	
	wire	[15:0]		en_data_pross;		
	wire				rst_to_data_process;
	
	wire				debug_choise_r;
	wire				en_trans_r;
	wire	[10:0]		add_times_cfg_r;
	// end user wire and regs
	
//------------------------------------------------------
// Instantiation of Axi Bus Interface S00_AXI
	AD_9637_IF_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) AD_9637_IF_v1_0_S00_AXI_inst (
		.serdes_rst_r						(serdes_rst_r),		//active hight
		.delayctrl_rst_r					(delayctrl_rst_r),  //active hight
		.idelay_ld_r						(idelay_ld_r),
		.idelay_inc_r						(idelay_inc_r),
		.idelay_ce_r						(idelay_ce_r),	
		.bitslip_r							(bitslip_r),
		.serdes_ce_r						(serdes_ce_r),
		.idelay_cntvaluein_r				(idelay_cntvaluein_r),			
		.idelay_cntvalueout_r				(idelay_cntvalueout_r),			
		.delay_locked						(delay_locked),	
		.data_paral_adc0					(data_paral_adc0),		
		.data_paral_adc1					(data_paral_adc1),
		.en_data_process					(en_data_pross),
		.bit_order_r						(bit_order_r),
		
		.debug_choise_r						(debug_choise_r),
		.en_trans_r							(en_trans_r),
		.add_times_cfg_r					(add_times_cfg_r),
	
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);
	
	//------------------------------------------------

	utile_To_Pulse	u_2pls_serdes_rst(
		.clk		(s00_axi_aclk),// 200MHz
		.signal_in	(serdes_rst_r),
		.pulse_out	(serdes_rst_pls));
	assign	serdes_rst = (~s00_axi_aresetn) || serdes_rst_pls; //active hight
	assign	rst_to_data_process = serdes_rst; //active hight
	
	utile_To_Pulse	u_2pls_delayctrl_rst(
		.clk		(s00_axi_aclk),
		.signal_in	(delayctrl_rst_r),
		.pulse_out	(delayctrl_rst_pls));
	assign	delayctrl_rst = (~s00_axi_aresetn) || delayctrl_rst_pls; //active hight
	
	genvar	r2p_idelay_ld;
	generate	
		for(r2p_idelay_ld = 0; r2p_idelay_ld < 16; r2p_idelay_ld = r2p_idelay_ld + 1) begin:	gen_idelay_ld_r2p
			utile_To_Pulse	u_idelay_ld_r2p(
				.clk		(s00_axi_aclk),
				.signal_in	(idelay_ld_r[r2p_idelay_ld]),
				.pulse_out	(idelay_ld_pls[r2p_idelay_ld])
			);
		end
	endgenerate
	
	genvar	r2p_idelay_inc;
	generate	
		for(r2p_idelay_inc = 0; r2p_idelay_inc < 16; r2p_idelay_inc = r2p_idelay_inc + 1) begin:	gen_idelay_inc_r2p
			utile_To_Pulse	u_idelay_inc_r2p(
				.clk		(s00_axi_aclk),
				.signal_in	(idelay_inc_r[r2p_idelay_inc]),
				.pulse_out	(idelay_inc_pls[r2p_idelay_inc])
				);
		end
	endgenerate
	
	genvar	r2p_idelay_ce;
	generate	
		for(r2p_idelay_ce = 0; r2p_idelay_ce < 16; r2p_idelay_ce = r2p_idelay_ce + 1) begin:	gen_idelay_ce_r2p
			utile_To_Pulse	u_idelay_ce_r2p(
				.clk		(s00_axi_aclk),
				.signal_in	(idelay_ce_r[r2p_idelay_ce]),
				.pulse_out	(idelay_ce_pls[r2p_idelay_ce])
				);
		end
	endgenerate
	
	//------------------------------------------------
	AD_9637_DeSerializer u_AD_9367_deserializer(
		.clk_160M                   (clk_160M), 
		.clk_200M                   (s00_axi_aclk), 
		.serdes_rst	            	(serdes_rst),  
		.delayctrl_rst	            (delayctrl_rst), 
		.idelay_ld_in	            (idelay_ld_pls),  
		.idelay_inc_in	            (idelay_inc_pls),
		.idelay_ce_in	            (idelay_ce_pls),
		.idelay_cntvaluein_in	    (idelay_cntvaluein_r),
		.idelay_cntvalueout_out	    (idelay_cntvalueout_r),
		.bitslip_in	                (bitslip_r),
		.serdes_ce_in				(serdes_ce_r),
		.bit_order					(bit_order_r),
		.adc0_data_in_p   			(adc0_data_in_p	),
		.adc0_data_in_n   			(adc0_data_in_n	),
		.adc1_data_in_p   			(adc1_data_in_p	),
		.adc1_data_in_n   			(adc1_data_in_n	),
		.adc0_fco_in_p    	        (adc0_fco_in_p	),
		.adc0_fco_in_n    	        (adc0_fco_in_n	),
		.adc1_fco_in_p    			(adc1_fco_in_p	),
		.adc1_fco_in_n    	        (adc1_fco_in_n	),
		.adc0_dco_in_p    	        (adc0_dco_in_p	),
		.adc0_dco_in_n    	        (adc0_dco_in_n	),
		.adc1_dco_in_p    	        (adc1_dco_in_p	),
		.adc1_dco_in_n	  	        (adc1_dco_in_n	),
		.adc0_data_out              (data_paral_adc0),
		.adc1_data_out              (data_paral_adc1),
		.delay_locked               (delay_locked),
		.clk_to_adc0_p				(clk_to_adc0_p),
		.clk_to_adc0_n				(clk_to_adc0_n),
		.clk_to_adc1_p				(clk_to_adc1_p),
		.clk_to_adc1_n				(clk_to_adc1_n),
		
		.adc0_data_ready			(adc0_data_ready), 
		.adc1_data_ready			(adc1_data_ready),
		.debug_choise				(debug_choise_r),
		.debug_led_show				(led_data_show)
	);
	
		//--------------------------------------------------
	AD_9637_IF_v_1_0_M_AXIS		AD_9637_IF_v_1_0_M_AXIS_inst(
		.M_AXIS_tready(M_AXIS_tready),
		.M_AXIS_tkeep(M_AXIS_tkeep),
		.M_AXIS_tlast(M_AXIS_tlast),
		.M_AXIS_tvalid(M_AXIS_tvalid),
		.M_AXIS_tdata(M_AXIS_tdata),
		.M_AXIS_aresetn(M_AXIS_aresetn),
		.M_AXIS_aclk(M_AXIS_aclk),
		.clk(s00_axi_aclk),
		.data_paral_adc0(data_paral_adc0),
		.data_paral_adc1(data_paral_adc1),
		.adc0_clk_to_data_process(adc0_clk_to_data_process),
		.adc1_clk_to_data_process(adc1_clk_to_data_process),
		.en_data_pross(en_data_pross),
		.rst_data_process(rst_to_data_process),
		.en_trans(en_trans_r),
		.add_times_cfg(add_times_cfg_r)
	);
	

	assign	adc0_clk_to_data_process = adc0_data_ready;
	assign	adc1_clk_to_data_process = adc1_data_ready;
	endmodule
