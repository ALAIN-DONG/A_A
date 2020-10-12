
`timescale 1 ns / 1 ps

	module AD_9637_IF_v1_0_S00_AXI # 
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
		output		[15:0]			idelay_ld_r,	//reg[15:0]	-- [0]
		output		[15:0]			idelay_inc_r,	//reg[15:0] -- [1]
		output		[15:0]			idelay_ce_r,	//reg[15:0]	-- [2]
		output		[79:0]			idelay_cntvaluein_r,  //reg[15:0] -- [7:3] 5bits*16
		output		[15:0]			bitslip_r,		//reg[15:0]	-- [8]
		output		[15:0]			serdes_ce_r,	//reg[15:0] -- [9]
		output		[15:0]			bit_order_r,	//reg[15:0]	-- [10]
		
		input		[95:0]			data_paral_adc0, //reg[23:16] -- [11:0] 12bits*8
		input		[95:0]			data_paral_adc1, //reg[31:24] -- [11:0] 12bits*8
		
		input		[79:0]			idelay_cntvalueout_r,//reg[31:16] -- [20:16] 5bits*16
		
		output						serdes_rst_r, //reg[32] -- [0]
		output						delayctrl_rst_r, //reg[32] -- [1]
		output		[15:0]			en_data_process, //reg[32] -- [31:16]
		
		input						delay_locked, // reg[33] -- [0]
		
		output		wire			debug_choise_r,
		output		wire			en_trans_r,
		output		wire	[10:0]	add_times_cfg_r,


		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);


	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 5;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 34
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg18;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg19;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg20;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg21;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg22;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg23;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg24;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg25;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg26;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg27;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg28;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg29;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg30;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg31;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg32;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg33;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( (S_AXI_ARESETN == 1'b0) || (all_regs_rst == 1'b1) )
	    begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      slv_reg2 <= 0;
	      slv_reg3 <= 0;
	      slv_reg4 <= 0;
	      slv_reg5 <= 0;
	      slv_reg6 <= 0;
	      slv_reg7 <= 0;
	      slv_reg8 <= 0;
	      slv_reg9 <= 0;
	      slv_reg10 <= 0;
	      slv_reg11 <= 0;
	      slv_reg12 <= 0;
	      slv_reg13 <= 0;
	      slv_reg14 <= 0;
	      slv_reg15 <= 0;
//	      slv_reg16 <= 0;
//	      slv_reg17 <= 0;
//	      slv_reg18 <= 0;
//	      slv_reg19 <= 0;
//	      slv_reg20 <= 0;
//	      slv_reg21 <= 0;
//	      slv_reg22 <= 0;
//	      slv_reg23 <= 0;
//	      slv_reg24 <= 0;
//	      slv_reg25 <= 0;
//	      slv_reg26 <= 0;
//	      slv_reg27 <= 0;
//	      slv_reg28 <= 0;
//	      slv_reg29 <= 0;
//	      slv_reg30 <= 0;
//	      slv_reg31 <= 0;
	      slv_reg32 <= 0;
//	      slv_reg33 <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          6'h00:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h01:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h02:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 2
	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h03:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 3
	                slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h04:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 4
	                slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h05:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h06:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h07:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 7
	                slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h08:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 8
	                slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h09:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 9
	                slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h0A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 10
	                slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h0B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 11
	                slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h0C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 12
	                slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h0D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 13
	                slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h0E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 14
	                slv_reg14[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h0F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 15
	                slv_reg15[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
//	          6'h10:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 16
//	                slv_reg16[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h11:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 17
//	                slv_reg17[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h12:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 18
//	                slv_reg18[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h13:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 19
//	                slv_reg19[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h14:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 20
//	                slv_reg20[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h15:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 21
//	                slv_reg21[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h16:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 22
//	                slv_reg22[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h17:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 23
//	                slv_reg23[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h18:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 24
//	                slv_reg24[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h19:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 25
//	                slv_reg25[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h1A:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 26
//	                slv_reg26[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h1B:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 27
//	                slv_reg27[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h1C:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 28
//	                slv_reg28[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h1D:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 29
//	                slv_reg29[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h1E:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 30
//	                slv_reg30[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
//	          6'h1F:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 31
//	                slv_reg31[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
	          6'h20:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 32
	                slv_reg32[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
//	          6'h21:
//	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//	                // Respective byte enables are asserted as per write strobes 
//	                // Slave register 33
//	                slv_reg33[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//	              end  
	          default : begin
		                  slv_reg0 <= slv_reg0;
	                      slv_reg1 <= slv_reg1;
	                      slv_reg2 <= slv_reg2;
	                      slv_reg3 <= slv_reg3;
	                      slv_reg4 <= slv_reg4;
	                      slv_reg5 <= slv_reg5;
	                      slv_reg6 <= slv_reg6;
	                      slv_reg7 <= slv_reg7;
	                      slv_reg8 <= slv_reg8;
	                      slv_reg9 <= slv_reg9;
	                      slv_reg10 <= slv_reg10;
	                      slv_reg11 <= slv_reg11;
	                      slv_reg12 <= slv_reg12;
	                      slv_reg13 <= slv_reg13;
	                      slv_reg14 <= slv_reg14;
	                      slv_reg15 <= slv_reg15;
//	                      slv_reg16 <= slv_reg16;
//	                      slv_reg17 <= slv_reg17;
//	                      slv_reg18 <= slv_reg18;
//	                      slv_reg19 <= slv_reg19;
//	                      slv_reg20 <= slv_reg20;
//	                      slv_reg21 <= slv_reg21;
//	                      slv_reg22 <= slv_reg22;
//	                      slv_reg23 <= slv_reg23;
//	                      slv_reg24 <= slv_reg24;
//	                      slv_reg25 <= slv_reg25;
//	                      slv_reg26 <= slv_reg26;
//	                      slv_reg27 <= slv_reg27;
//	                      slv_reg28 <= slv_reg28;
//	                      slv_reg29 <= slv_reg29;
//	                      slv_reg30 <= slv_reg30;
//	                      slv_reg31 <= slv_reg31;
	                      slv_reg32 <= slv_reg32;
//	                      slv_reg33 <= slv_reg33;
	                    end
	        endcase
	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        6'h00   : reg_data_out <= slv_reg0;
	        6'h01   : reg_data_out <= slv_reg1;
	        6'h02   : reg_data_out <= slv_reg2;
	        6'h03   : reg_data_out <= slv_reg3;
	        6'h04   : reg_data_out <= slv_reg4;
	        6'h05   : reg_data_out <= slv_reg5;
	        6'h06   : reg_data_out <= slv_reg6;
	        6'h07   : reg_data_out <= slv_reg7;
	        6'h08   : reg_data_out <= slv_reg8;
	        6'h09   : reg_data_out <= slv_reg9;
	        6'h0A   : reg_data_out <= slv_reg10;
	        6'h0B   : reg_data_out <= slv_reg11;
	        6'h0C   : reg_data_out <= slv_reg12;
	        6'h0D   : reg_data_out <= slv_reg13;
	        6'h0E   : reg_data_out <= slv_reg14;
	        6'h0F   : reg_data_out <= slv_reg15;
	        6'h10   : reg_data_out <= slv_reg16;
	        6'h11   : reg_data_out <= slv_reg17;
	        6'h12   : reg_data_out <= slv_reg18;
	        6'h13   : reg_data_out <= slv_reg19;
	        6'h14   : reg_data_out <= slv_reg20;
	        6'h15   : reg_data_out <= slv_reg21;
	        6'h16   : reg_data_out <= slv_reg22;
	        6'h17   : reg_data_out <= slv_reg23;
	        6'h18   : reg_data_out <= slv_reg24;
	        6'h19   : reg_data_out <= slv_reg25;
	        6'h1A   : reg_data_out <= slv_reg26;
	        6'h1B   : reg_data_out <= slv_reg27;
	        6'h1C   : reg_data_out <= slv_reg28;
	        6'h1D   : reg_data_out <= slv_reg29;
	        6'h1E   : reg_data_out <= slv_reg30;
	        6'h1F   : reg_data_out <= slv_reg31;
	        6'h20   : reg_data_out <= slv_reg32;
	        6'h21   : reg_data_out <= slv_reg33;
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    
	
	// Add user logic here
	wire	all_regs_rst; // active hight // reg[32] -- [2]
	
	//---------------------------------------------
	//	reg0 -- reg7		adc0-ctrl, 	[axi write]
	//  reg8 -- reg15    	adc1-ctrl	[axi write]
	// reg		[0]		idelay 	ld
	//			[1]		idelay	inc
	//			[2]		idelay	ce
	//			[7:3]	idelay	cntvaluein
	//			[8]		iserdes	bitslip
	//			[9]		iserdes ce
	//			[10]	bit order
	//***********************************************
	assign	{bit_order_r[0],  serdes_ce_r[0], bitslip_r[0], idelay_cntvaluein_r[(5*0+4):(5*0)], idelay_ce_r[0], idelay_inc_r[0], idelay_ld_r[0]} = slv_reg0[10:0];
	assign	{bit_order_r[1],  serdes_ce_r[1], bitslip_r[1], idelay_cntvaluein_r[(5*1+4):(5*1)], idelay_ce_r[1], idelay_inc_r[1], idelay_ld_r[1]} = slv_reg1[10:0];
	assign	{bit_order_r[2],  serdes_ce_r[2], bitslip_r[2], idelay_cntvaluein_r[(5*2+4):(5*2)], idelay_ce_r[2], idelay_inc_r[2], idelay_ld_r[2]} = slv_reg2[10:0];
	assign	{bit_order_r[3],  serdes_ce_r[3], bitslip_r[3], idelay_cntvaluein_r[(5*3+4):(5*3)], idelay_ce_r[3], idelay_inc_r[3], idelay_ld_r[3]} = slv_reg3[10:0];
	assign	{bit_order_r[4],  serdes_ce_r[4], bitslip_r[4], idelay_cntvaluein_r[(5*4+4):(5*4)], idelay_ce_r[4], idelay_inc_r[4], idelay_ld_r[4]} = slv_reg4[10:0];
	assign	{bit_order_r[5],  serdes_ce_r[5], bitslip_r[5], idelay_cntvaluein_r[(5*5+4):(5*5)], idelay_ce_r[5], idelay_inc_r[5], idelay_ld_r[5]} = slv_reg5[10:0];
	assign	{bit_order_r[6],  serdes_ce_r[6], bitslip_r[6], idelay_cntvaluein_r[(5*6+4):(5*6)], idelay_ce_r[6], idelay_inc_r[6], idelay_ld_r[6]} = slv_reg6[10:0];
	assign	{bit_order_r[7],  serdes_ce_r[7], bitslip_r[7], idelay_cntvaluein_r[(5*7+4):(5*7)], idelay_ce_r[7], idelay_inc_r[7], idelay_ld_r[7]} = slv_reg7[10:0];
	assign	{bit_order_r[8],  serdes_ce_r[8], bitslip_r[8], idelay_cntvaluein_r[(5*8+4):(5*8)], idelay_ce_r[8], idelay_inc_r[8], idelay_ld_r[8]} = slv_reg8[10:0];
	assign	{bit_order_r[9],  serdes_ce_r[9], bitslip_r[9], idelay_cntvaluein_r[(5*9+4):(5*9)], idelay_ce_r[9], idelay_inc_r[9], idelay_ld_r[9]} = slv_reg9[10:0];
	assign	{bit_order_r[10], serdes_ce_r[10], bitslip_r[10], idelay_cntvaluein_r[(5*10+4):(5*10)], idelay_ce_r[10], idelay_inc_r[10], idelay_ld_r[10]} = slv_reg10[10:0];
	assign	{bit_order_r[11], serdes_ce_r[11], bitslip_r[11], idelay_cntvaluein_r[(5*11+4):(5*11)], idelay_ce_r[11], idelay_inc_r[11], idelay_ld_r[11]} = slv_reg11[10:0];
	assign	{bit_order_r[12], serdes_ce_r[12], bitslip_r[12], idelay_cntvaluein_r[(5*12+4):(5*12)], idelay_ce_r[12], idelay_inc_r[12], idelay_ld_r[12]} = slv_reg12[10:0];
	assign	{bit_order_r[13], serdes_ce_r[13], bitslip_r[13], idelay_cntvaluein_r[(5*13+4):(5*13)], idelay_ce_r[13], idelay_inc_r[13], idelay_ld_r[13]} = slv_reg13[10:0];
	assign	{bit_order_r[14], serdes_ce_r[14], bitslip_r[14], idelay_cntvaluein_r[(5*14+4):(5*14)], idelay_ce_r[14], idelay_inc_r[14], idelay_ld_r[14]} = slv_reg14[10:0];
	assign	{bit_order_r[15], serdes_ce_r[15], bitslip_r[15], idelay_cntvaluein_r[(5*15+4):(5*15)], idelay_ce_r[15], idelay_inc_r[15], idelay_ld_r[15]} = slv_reg15[10:0];
	//-----------------------------------------
	
	//-----------------------------------------
	//	reg16 -- reg23		adc0-data/cntvalueout	[logic write]
	//	reg24 -- reg31		adc1-data/cntvalueout
	//	reg		[11:0]		data_parallel
	//	reg		[20:16]		idelay	cntvalueout
	//************************************************
	always @( posedge S_AXI_ACLK )
	begin
	  if ( (S_AXI_ARESETN == 1'b0) || (all_regs_rst == 1'b1) )
	    begin
		  slv_reg16 <= 1'b0;
		  slv_reg17 <= 1'b0;
		  slv_reg18 <= 1'b0;
		  slv_reg19 <= 1'b0;
		  slv_reg20 <= 1'b0;
		  slv_reg21 <= 1'b0;
		  slv_reg22 <= 1'b0;
		  slv_reg23 <= 1'b0;
		  slv_reg24 <= 1'b0;
		  slv_reg25 <= 1'b0;
		  slv_reg26 <= 1'b0;
		  slv_reg27 <= 1'b0;
		  slv_reg28 <= 1'b0;
		  slv_reg29 <= 1'b0;
		  slv_reg30 <= 1'b0;
		  slv_reg31 <= 1'b0;
	    end 
	  else
	    begin 
	    	slv_reg16[11:0] <=	data_paral_adc0[(11+0*12):(0*12)];
	    	slv_reg17[11:0] <=	data_paral_adc0[(11+1*12):(1*12)];
	    	slv_reg18[11:0] <=	data_paral_adc0[(11+2*12):(2*12)];
	    	slv_reg19[11:0] <=	data_paral_adc0[(11+3*12):(3*12)];
	    	slv_reg20[11:0] <=	data_paral_adc0[(11+4*12):(4*12)];
	    	slv_reg21[11:0] <=	data_paral_adc0[(11+5*12):(5*12)];
	    	slv_reg22[11:0] <=	data_paral_adc0[(11+6*12):(6*12)];
	    	slv_reg23[11:0] <=	data_paral_adc0[(11+7*12):(7*12)];
	    	slv_reg24[11:0] <=	data_paral_adc1[(11+0*12):(0*12)];
			slv_reg25[11:0] <=	data_paral_adc1[(11+1*12):(1*12)];
			slv_reg26[11:0] <=	data_paral_adc1[(11+2*12):(2*12)];
			slv_reg27[11:0] <=	data_paral_adc1[(11+3*12):(3*12)];
			slv_reg28[11:0] <=	data_paral_adc1[(11+4*12):(4*12)];
			slv_reg29[11:0] <=	data_paral_adc1[(11+5*12):(5*12)];
			slv_reg30[11:0] <=	data_paral_adc1[(11+6*12):(6*12)];
			slv_reg31[11:0] <=	data_paral_adc1[(11+7*12):(7*12)];
			
			slv_reg16[20:16] <=	 idelay_cntvalueout_r[(5*0+4):(5*0)] ;
			slv_reg17[20:16] <=	 idelay_cntvalueout_r[(5*1+4):(5*1)] ;
			slv_reg18[20:16] <=	 idelay_cntvalueout_r[(5*2+4):(5*2)] ;
			slv_reg19[20:16] <=	 idelay_cntvalueout_r[(5*3+4):(5*3)] ;
			slv_reg20[20:16] <=	 idelay_cntvalueout_r[(5*4+4):(5*4)] ;
			slv_reg21[20:16] <=	 idelay_cntvalueout_r[(5*5+4):(5*5)] ;
			slv_reg22[20:16] <=	 idelay_cntvalueout_r[(5*6+4):(5*6)] ;
			slv_reg23[20:16] <=	 idelay_cntvalueout_r[(5*7+4):(5*7)] ;
			slv_reg24[20:16] <=	 idelay_cntvalueout_r[(5*8+4):(5*8)] ;
			slv_reg25[20:16] <=	 idelay_cntvalueout_r[(5*9+4):(5*9)] ;
			slv_reg26[20:16] <=	 idelay_cntvalueout_r[(5*10+4):(5*10)];
			slv_reg27[20:16] <=	 idelay_cntvalueout_r[(5*11+4):(5*11)];
			slv_reg28[20:16] <=	 idelay_cntvalueout_r[(5*12+4):(5*12)];
			slv_reg29[20:16] <=	 idelay_cntvalueout_r[(5*13+4):(5*13)];
			slv_reg30[20:16] <=	 idelay_cntvalueout_r[(5*14+4):(5*14)];
			slv_reg31[20:16] <=	 idelay_cntvalueout_r[(5*15+4):(5*15)];
	    end
	 end
	 //-------------------------------------------------
	
	//-------------------------------------------------- 
	//	reg32		globle reset	[axi write]
	//	reg		[0]		serdes 		reset
	//			[1]		idelayctrl	reset
	//			[2]		all regs 	reset
	//			[3]		switch led show path
	//			[4]		en_trans
	//			[15:5]	add_times	11 bits
	//			[31:16]	enable data processingg module for sepecified path
	//********************************************
	
	assign	{en_trans_r, debug_choise_r, all_regs_rst, delayctrl_rst_r, serdes_rst_r}	=	slv_reg32[4:0];
	assign	add_times_cfg_r[10:0]	= slv_reg32[15:5];
	assign 	en_data_process[15:0] = slv_reg32[31:16];
	//---------------------------------------------------
	
	//---------------------------------------------------
	//	reg33[0]		ready		[logic write]
	//*****************************************
	always @( posedge S_AXI_ACLK )
	begin
	  if ((S_AXI_ARESETN == 1'b0) || (all_regs_rst == 1'b1))
	    begin
	      	slv_reg33  <= 32'b0;
	    end 
	  else
	    begin 
	    	slv_reg33[0] <=	delay_locked;
	    end
	 end
	 //----------------------------------------------------
	// User logic ends

	endmodule
