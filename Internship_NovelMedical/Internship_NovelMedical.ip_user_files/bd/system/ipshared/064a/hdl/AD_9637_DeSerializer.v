`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/01 11:28:16
// Design Name: 
// Module Name: AD_9637_DeSerializer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 

module AD_9637_DeSerializer(
	input				clk_160M,		// 160MHz clock in, 用于产生adc采样的基础时钟
	input				clk_200M,		// 200MHz clock in, 用于idelay的参考时钟以及该axi模块的时钟
	 
	input				serdes_rst,		// iserdes 模块的复位，高电平有效，16路同时复位
	input				delayctrl_rst,	// idelayCTRL模块的复位，高电平有效，16路同时复位
	
	input	[15:0]		idelay_ld_in,	// idelay LD 接口， 为脉冲，已与200MHz同步， 用于将cntvaluein中的数值加载到idelay中
	input	[15:0]		idelay_inc_in,	// idelay INC 接口， 为脉冲， 已与200MHz同步，用于增加目前cnt数值
	input	[15:0]		idelay_ce_in,	// idelay CE 接口， 为脉冲， 已与200MHz同步，用于使能增加，与INC同时使能
	input	[79:0]		idelay_cntvaluein_in,	//[4:0][15:0]	idelay cntvaluein， 5bits 为用户自定义cnt的数值
	output	[79:0]		idelay_cntvalueout_out,	//idelay cntvalueout， 5bits，输出当前cnt的数值
	
	input	[15:0]		bitslip_in,		//	iserdes bitslip， 为脉冲，需与iserdes的clkdiv同步， 用于字节对齐
	input	[15:0]		serdes_ce_in,	//	iserdes ce， 高有效，用于 片选serdes解串模块（开启/关闭）
	
	input	[15:0]		bit_order,		// 在两个6bits数据拼接中用于拼接顺序调整，默认为0， 为1时调换前后顺序
	

	input   [7:0]		adc0_data_in_p,	// lvds in
	input   [7:0]		adc0_data_in_n,
	input   [7:0]		adc1_data_in_p,
	input   [7:0]		adc1_data_in_n,
	
	input				adc0_fco_in_p,//80M（max） frame clock
	input				adc0_fco_in_n,
	input				adc1_fco_in_p,
	input				adc1_fco_in_n,
	
	input				adc0_dco_in_p, //480Mhz（max） data clock
	input				adc0_dco_in_n,
	input				adc1_dco_in_p,
	input				adc1_dco_in_n,	
	
	output	wire	[95:0]	adc0_data_out, //[11:0][7:0]  parallel data out
	output	wire	[95:0]	adc1_data_out,
	
	output				delay_locked,	// idelayctrl locked （1--> locked --> 时钟稳定，数据可信）
	
	output				clk_to_adc0_p, // 输出 参考时钟 （160MHz， 80的倍数，由ps部分控制）
	output				clk_to_adc0_n,
	output				clk_to_adc1_p,
	output				clk_to_adc1_n,
	
	output	wire	[7:0]	adc0_data_ready,  //新数据拼接完成，在该信号上升沿可用
	output	wire	[7:0]	adc1_data_ready,
	
	input					debug_choise, //选择led灯输出路径
	output	wire	[5:0]	debug_led_show//使用led灯快速查看输出并行结果
    );
    parameter	IODELAY_GROUP   = "dev_if_delay_group";
    parameter	DATA_WIDTH		= 6;
    
    parameter	idelay_cntvaluein_adc1_offset = 40;
 	parameter	idelay_cntvalueout_adc1_offset = 40;
 	parameter	data_paral_adc1_offset = 48;
 	
 	
    reg		clk_80M;
    wire	idelay_clk;//idelay输入C时钟 与 idelayctrl 输入参考时钟
    reg		adc0_iserdes_clk_div; //由dco手动分频得到，故与dco同步，给serdes模块的clk_div
    reg		adc1_iserdes_clk_div;//由dco手动分频得到，故与dco同步，给serdes模块的clk_div
    wire	adc0_dco_single; //转换后的dco
	wire	adc1_dco_single;//转换后的dco
	wire	adc0_fco_single;//转换后的fco
	wire	adc1_fco_single;//转换后的fco
	
	wire	[47:0]	adc0_data_out_intern;//6bits //内部serdes转换后的并行信号，发给变速箱
	wire	[47:0]	adc1_data_out_intern;//6bits //内部serdes转换后的并行信号，发给变速箱
	
    wire	[7:0]	adc0_data_in_ibuf_intern;//由LVDS转换的串行信号，将输给serdes
    wire	[7:0]	adc1_data_in_ibuf_intern;//由LVDS转换的串行信号，将输给serdes
    
    wire	[7:0]	adc0_delayed_data_intern;//由idelay打拍后的串行信号，输给serdes
    wire	[7:0]	adc1_delayed_data_intern;//由idelay打拍后的串行信号，输给serdes
    
    reg		[1:0]	clk_div_count_adc0;//480M（dco）转 160M（clk_div）的计数器
    reg		[1:0]	clk_div_count_adc1;//480M（dco）转 160M（clk_div）的计数器
    
    wire			adc0_gear_box_clk;
    wire			adc1_gear_box_clk;
    
    wire		[7:0]	bitslip_intern_adc0;//由axi内部reg转换成冲击的bitslip信号，输给serdes
    wire		[7:0]	bitslip_intern_adc1;//由axi内部reg转换成冲击的bitslip信号，输给serdes
    
    assign	idelay_clk		=	clk_200M;
    assign	debug_led_show[5:0] = (debug_choise == 1'b1) ? adc1_data_out_intern[5:0] : adc0_data_out_intern[5:0];
    
    // 时钟关系汇总：
    //以adc最高采样速度为例：
    //1. 系统提供160MHz时钟（可在ps中修改最高240MHz），由该模块转换成差分信号输送给ADC芯片，芯片上电后需配置内部分频器（地址0x0B）最少为2分频（001）（接受最高80MHz）
    //2. 当adc芯片处于最高速80MHz（*C*）采样速度时，输出DCO 为 480MHz（*6C*）（双边沿，12bits，80*12/2=480），FCO为80MHz（*C*）（与采样速度相同）
	//3. 对于iserdes模块的clk和clk_div: 由于iserdes处于6bits模式，接收两次后拼接成12bits。
	//		clk是每比特的时钟速度（双边沿），clk与DCO一定保持相同（clk = 480MHz）（*6C*）；
	//		clkdiv是输出并行数据的速度，clkdiv 为clk的1/3频率  （clkdiv = 480*2/6 = 160MHz）（*2C*） *bitslip同步于此时钟
	//4. 避免双边沿触发，变速箱输入时钟为2*FCO = 1/3 * DCO == clk_div（*2C*）
	//5. 经过变速箱后，输出ready信号其实就是数据拼接后的时钟信号，上升沿在数据最稳定时刻，信号速度为iserdes输出并行数据速度的1/2，即 ready = 1/2 clkdiv = FCO （*C*）
    //6. 200MHz 参考时钟是idelay和idelayctrl模块打拍延迟所需的时钟，与以上数据时钟相独立

    //接收DAC0 的 DCO的差分信号并转换成普通信号
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IBUFGDS #(
    	.DIFF_TERM("FALSE"),       // Differential Termination
      	.IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      	.IOSTANDARD("DEFAULT")     // Specify the input I/O standard
     )
    i_clk_in_ibuf_adc0 (
		.I (adc0_dco_in_p),
		.IB (adc0_dco_in_n),
		.O (adc0_dco_single)
    );
    
    //接收DAC1 的 DCO的差分信号并转换成普通信号
    (* IODELAY_GROUP = IODELAY_GROUP *)
	IBUFGDS #(
    	.DIFF_TERM("FALSE"),       // Differential Termination
      	.IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      	.IOSTANDARD("DEFAULT")     // Specify the input I/O standard
     )
     i_clk_in_ibuf_adc1 (
		.I (adc1_dco_in_p),
		.IB (adc1_dco_in_n),
		.O (adc1_dco_single)
    );
    
    //接收DAC0 的 FCO的差分信号并转换成普通信号
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IBUFDS i_fco_in_ibuf_adc0 (
		.I (adc0_fco_in_p),
		.IB (adc0_fco_in_n),
		.O (adc0_fco_single)
    );
    
    //接收DAC1 的 FCO的差分信号并转换成普通信号
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IBUFDS i_fco_in_ibuf_adc1 (
		.I (adc1_fco_in_p),
		.IB (adc1_fco_in_n),
		.O (adc1_fco_single)
    );
    
   //输出ADC0 差分参考时钟
   OBUFDS #(
      .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_adc0 (
      .O(clk_to_adc0_p),     // Diff_p output (connect directly to top-level port)
      .OB(clk_to_adc0_n),   // Diff_n output (connect directly to top-level port)
      .I(clk_160M)      // Buffer input
   ); 
   
   //输出ADC1 差分参考时钟
   OBUFDS #(
      .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_adc1 (
      .O(clk_to_adc1_p),     // Diff_p output (connect directly to top-level port)
      .OB(clk_to_adc1_n),   // Diff_n output (connect directly to top-level port)
      .I(clk_160M)      // Buffer input
   ); 
   
   //接收ADC0 的 差分数据信号并转换成普通信号传输给idelay模块
    genvar	adc0_ibufds_var;
    generate
		for	(adc0_ibufds_var = 0; adc0_ibufds_var < 8; adc0_ibufds_var = adc0_ibufds_var + 1)	begin: gen_adc0_ibuf
			(* IODELAY_GROUP = IODELAY_GROUP *)
			IBUFDS i_ibuf (
			.O(adc0_data_in_ibuf_intern[adc0_ibufds_var]),
			.I(adc0_data_in_p[adc0_ibufds_var]),
			.IB(adc0_data_in_n[adc0_ibufds_var])
			 );
		end
	endgenerate
    
    //接收ADC1 的 差分数据信号并转换成普通信号传输给idelay模块
    genvar	adc1_ibufds_var;
    generate
		for	(adc1_ibufds_var = 0; adc1_ibufds_var < 8; adc1_ibufds_var = adc1_ibufds_var + 1)	begin: gen_adc1_ibuf
			(* IODELAY_GROUP = IODELAY_GROUP *)
			IBUFDS i_ibuf (
			.O(adc1_data_in_ibuf_intern[adc1_ibufds_var]),
			.I(adc1_data_in_p[adc1_ibufds_var]),
			.IB(adc1_data_in_n[adc1_ibufds_var])
			 );
		end
	endgenerate
   

//产生由adc0 dco三分频的时钟作serdes 的 clk_div  
    always	@(posedge adc0_dco_single) begin
    	if(serdes_rst)	begin
    		clk_div_count_adc0	<= 2'b0;
    		adc0_iserdes_clk_div	<= 1'b0;
    	end
    	else begin
    		if (clk_div_count_adc0 >= 2'd2) begin
    			clk_div_count_adc0 <= 2'd0;
    			adc0_iserdes_clk_div <= 1'b1;
    		end
    		else begin
    			clk_div_count_adc0 <= clk_div_count_adc0 + 2'd1;
    			adc0_iserdes_clk_div <= 1'b0;
    		end
    	end
    end
    
    //产生由adc0 dco三分频的时钟作serdes 的 clk_div  
    always	@(posedge adc1_dco_single) begin
    	if(serdes_rst)	begin
    		clk_div_count_adc1	<= 2'b0;
    		adc1_iserdes_clk_div	<= 1'b0;
    	end
    	else begin
    		if (clk_div_count_adc1 >= 2'd2) begin
    			clk_div_count_adc1 <= 2'd0;
    			adc1_iserdes_clk_div <= 1'b1;
    		end
    		else begin
    			clk_div_count_adc1 <= clk_div_count_adc1 + 2'd1;
    			adc1_iserdes_clk_div <= 1'b0;
    		end
    	end
    end
    
    
	assign adc0_gear_box_clk = adc0_iserdes_clk_div;
	assign adc1_gear_box_clk = adc1_iserdes_clk_div;
	


	//产生adc0 的 bitslip的脉冲， 时钟同步于 clk_div 该bitslip的产生由ps控制
    genvar	gen_bitslip_adc0;
	generate	
		for(gen_bitslip_adc0 = 0; gen_bitslip_adc0 < 8; gen_bitslip_adc0 = gen_bitslip_adc0 + 1) begin:	generator_bitslip_adc0
			utile_To_Pulse	u_bitslip_r2p(
				.clk		(adc0_iserdes_clk_div),
				.signal_in	(bitslip_in[gen_bitslip_adc0]),
				.pulse_out	(bitslip_intern_adc0[gen_bitslip_adc0])
				);
		end
	endgenerate
	
    //产生adc1 的 bitslip的脉冲， 时钟同步于 clk_div
    genvar	gen_bitslip_adc1;
	generate	
		for(gen_bitslip_adc1 = 0; gen_bitslip_adc1 < 8; gen_bitslip_adc1 = gen_bitslip_adc1 + 1) begin:	generator_bitslip_adc1
			utile_To_Pulse	u_bitslip_r2p(
				.clk		(adc1_iserdes_clk_div),
				.signal_in	(bitslip_in[gen_bitslip_adc1+8]),
				.pulse_out	(bitslip_intern_adc1[gen_bitslip_adc1])
				);
		end
	endgenerate


    // idelayctrl 模块
    (* IODELAY_GROUP = IODELAY_GROUP *)
    IDELAYCTRL i_delay_ctrl (
    .RST (delayctrl_rst),
    .REFCLK (idelay_clk),
    .RDY (delay_locked));
    

	// idelaye2 模块
	genvar	adc0_idelay_var;
	generate
		for	(adc0_idelay_var = 0; adc0_idelay_var < 8; adc0_idelay_var = adc0_idelay_var + 1)	begin: gen_adc0_idelay
			(* IODELAY_GROUP = IODELAY_GROUP *)
			IDELAYE2 #(
			.CINVCTRL_SEL ("FALSE"),
			.DELAY_SRC ("IDATAIN"),
			.HIGH_PERFORMANCE_MODE ("FALSE"),
			.IDELAY_TYPE ("VAR_LOAD"),
			.IDELAY_VALUE (0),
			.REFCLK_FREQUENCY (200.0),
			.PIPE_SEL ("FALSE"),
			.SIGNAL_PATTERN ("DATA"))
			i_rx_data_idelay_adc0 (
			.CE (idelay_ce_in[adc0_idelay_var]),
			.INC (idelay_inc_in[adc0_idelay_var]),//0
			.DATAIN (1'b0),
			.LDPIPEEN (1'b0),
			.CINVCTRL (1'b0),
			.REGRST (1'b0),
			.C (idelay_clk),
			.IDATAIN (adc0_data_in_ibuf_intern[adc0_idelay_var]),
			.DATAOUT (adc0_delayed_data_intern[adc0_idelay_var]),
			.LD (idelay_ld_in[adc0_idelay_var]),
			.CNTVALUEIN (idelay_cntvaluein_in[(adc0_idelay_var*5 + 4) : (adc0_idelay_var*5)]),
			.CNTVALUEOUT (idelay_cntvalueout_out[(adc0_idelay_var*5 + 4) : (adc0_idelay_var*5)]));
		end
	endgenerate
	
	
	genvar	adc1_idelay_var;
	generate
		for	(adc1_idelay_var = 0; adc1_idelay_var < 8; adc1_idelay_var = adc1_idelay_var + 1)	begin: gen_adc1_idelay
			(* IODELAY_GROUP = IODELAY_GROUP *)
			IDELAYE2 #(
			.CINVCTRL_SEL ("FALSE"),
			.DELAY_SRC ("IDATAIN"),
			.HIGH_PERFORMANCE_MODE ("FALSE"),
			.IDELAY_TYPE ("VAR_LOAD"),
			.IDELAY_VALUE (0),
			.REFCLK_FREQUENCY (200.0),
			.PIPE_SEL ("FALSE"),
			.SIGNAL_PATTERN ("DATA"))
			i_rx_data_idelay_adc1 (
			.CE (idelay_ce_in[adc1_idelay_var+8]),
			.INC (idelay_inc_in[adc1_idelay_var+8]),//0
			.DATAIN (1'b0),
			.LDPIPEEN (1'b0),
			.CINVCTRL (1'b0),
			.REGRST (1'b0),
			.C (idelay_clk),
			.IDATAIN (adc1_data_in_ibuf_intern[adc1_idelay_var]),
			.DATAOUT (adc1_delayed_data_intern[adc1_idelay_var]),
			.LD (idelay_ld_in[adc1_idelay_var+8]),
			.CNTVALUEIN (idelay_cntvaluein_in[(adc1_idelay_var*5 + 4 + idelay_cntvaluein_adc1_offset) : (adc1_idelay_var*5 + idelay_cntvaluein_adc1_offset)]),
			.CNTVALUEOUT (idelay_cntvalueout_out[(adc1_idelay_var*5 + 4 + idelay_cntvalueout_adc1_offset) : (adc1_idelay_var*5 + idelay_cntvalueout_adc1_offset)]));
		end
	endgenerate
	
	// iserdese2 模块
	genvar	adc0_serdes_var;
	generate
		for	(adc0_serdes_var = 0; adc0_serdes_var < 8; adc0_serdes_var = adc0_serdes_var + 1)	begin: gen_adc0_serdes
			(* IODELAY_GROUP = IODELAY_GROUP *)
				ISERDESE2 #(
					.DATA_RATE("DDR"),
					.DATA_WIDTH(DATA_WIDTH),
					.DYN_CLKDIV_INV_EN("FALSE"),
					.DYN_CLK_INV_EN("FALSE"),
					.INIT_Q1(1'b0),
					.INIT_Q2(1'b0),
					.INIT_Q3(1'b0),
					.INIT_Q4(1'b0),
					.INTERFACE_TYPE("NETWORKING"),
					.IOBDELAY("IFD"),
					.NUM_CE(2),
					.OFB_USED("FALSE"),
					.SERDES_MODE("MASTER"),
					.SRVAL_Q1(1'b0),
					.SRVAL_Q2(1'b0),
					.SRVAL_Q3(1'b0),
					.SRVAL_Q4(1'b0))
      				ISERDESE2_inst_adc0 (
						.O(), 
						.Q1(adc0_data_out_intern[(adc0_serdes_var*6+0)]),
						.Q2(adc0_data_out_intern[(adc0_serdes_var*6+1)]),
						.Q3(adc0_data_out_intern[(adc0_serdes_var*6+2)]),
						.Q4(adc0_data_out_intern[(adc0_serdes_var*6+3)]),
						.Q5(adc0_data_out_intern[(adc0_serdes_var*6+4)]),
						.Q6(adc0_data_out_intern[(adc0_serdes_var*6+5)]),
						.Q7(),
						.Q8(),
						.SHIFTOUT1(),
						.SHIFTOUT2(),
						.BITSLIP(bitslip_intern_adc0[adc0_serdes_var]),
						.CE1(serdes_ce_in[adc0_serdes_var]),
						.CE2(serdes_ce_in[adc0_serdes_var]),
						.CLKDIVP(1'b0),
						.CLK(adc0_dco_single),//
						.CLKB(~adc0_dco_single),
						.CLKDIV(adc0_iserdes_clk_div),//
						.OCLK(1'b0),
						.DYNCLKDIVSEL(1'b0),
						.DYNCLKSEL(1'b0),
						.D(1'b0),
						.DDLY(adc0_delayed_data_intern[adc0_serdes_var]),
						.OFB(1'b0),
						.OCLKB(1'b0),
						.RST(serdes_rst),
						.SHIFTIN1(1'b0),
						.SHIFTIN2(1'b0)
      				);
		end
	endgenerate
    
	genvar	adc1_serdes_var;
	generate
		for	(adc1_serdes_var = 0; adc1_serdes_var < 8; adc1_serdes_var = adc1_serdes_var + 1)	begin: gen_adc1_serdes
			(* IODELAY_GROUP = IODELAY_GROUP *)
				ISERDESE2 #(
					.DATA_RATE("DDR"),
					.DATA_WIDTH(DATA_WIDTH),
					.DYN_CLKDIV_INV_EN("FALSE"),
					.DYN_CLK_INV_EN("FALSE"),
					.INIT_Q1(1'b0),
					.INIT_Q2(1'b0),
					.INIT_Q3(1'b0),
					.INIT_Q4(1'b0),
					.INTERFACE_TYPE("NETWORKING"),
					.IOBDELAY("IFD"),
					.NUM_CE(2),
					.OFB_USED("FALSE"),
					.SERDES_MODE("MASTER"),
					.SRVAL_Q1(1'b0),
					.SRVAL_Q2(1'b0),
					.SRVAL_Q3(1'b0),
					.SRVAL_Q4(1'b0))
      				ISERDESE2_inst_adc1 (
						.O(),
						.Q1(adc1_data_out_intern[(adc1_serdes_var*6)]),
						.Q2(adc1_data_out_intern[(adc1_serdes_var*6+1)]),
						.Q3(adc1_data_out_intern[(adc1_serdes_var*6+2)]),
						.Q4(adc1_data_out_intern[(adc1_serdes_var*6+3)]),
						.Q5(adc1_data_out_intern[(adc1_serdes_var*6+4)]),
						.Q6(adc1_data_out_intern[(adc1_serdes_var*6+5)]),
						.Q7(),
						.Q8(),
						.SHIFTOUT1(),
						.SHIFTOUT2(),
						.BITSLIP(bitslip_intern_adc1[adc1_serdes_var]),
						.CE1(serdes_ce_in[adc1_serdes_var+8]),
						.CE2(serdes_ce_in[adc1_serdes_var+8]),
						.CLKDIVP(1'b0),
						.CLK(adc1_dco_single),//
						.CLKB(~adc1_dco_single),
						.CLKDIV(adc1_iserdes_clk_div),//
						.OCLK(1'b0),
						.DYNCLKDIVSEL(1'b0),
						.DYNCLKSEL(1'b0),
						.D(1'b0),
						.DDLY(adc1_delayed_data_intern[adc1_serdes_var]),
						.OFB(1'b0),
						.OCLKB(1'b0),
						.RST(serdes_rst),
						.SHIFTIN1(1'b0),
						.SHIFTIN2(1'b0)
      				);
		end
	endgenerate
	
	//变速箱（字符拼接）模块
	genvar	adc0_gear_box;
	generate
		for	(adc0_gear_box = 0; adc0_gear_box < 8; adc0_gear_box = adc0_gear_box + 1)	begin: gen_adc0_gear_box
			Grar_Box_6b_2_12b GB_adc0(
				.rst			(serdes_rst),
				.clk			(adc0_gear_box_clk),
				.data_in		(adc0_data_out_intern[(adc0_gear_box*6+5) : (adc0_gear_box*6)]),
				.order			(bit_order[adc0_gear_box]),
				.data_out		(adc0_data_out[(adc0_gear_box*12+11) : (adc0_gear_box*12)]),
				.ready			(adc0_data_ready[adc0_gear_box])
			);
		end
	endgenerate
	
    genvar	adc1_gear_box;
	generate
		for	(adc1_gear_box = 0; adc1_gear_box < 8; adc1_gear_box = adc1_gear_box + 1)	begin: gen_adc1_gear_box
			Grar_Box_6b_2_12b GB_adc0(
				.rst			(serdes_rst),
				.clk			(adc1_gear_box_clk),
				.data_in		(adc1_data_out_intern[(adc1_gear_box*6+5) : (adc1_gear_box*6)]),
				.order			(bit_order[adc1_gear_box +8]),
				.data_out		(adc1_data_out[(adc1_gear_box*12+11) : (adc1_gear_box*12)]),
				.ready			(adc1_data_ready[adc1_gear_box])
			);
		end
	endgenerate
    
    
    
endmodule
