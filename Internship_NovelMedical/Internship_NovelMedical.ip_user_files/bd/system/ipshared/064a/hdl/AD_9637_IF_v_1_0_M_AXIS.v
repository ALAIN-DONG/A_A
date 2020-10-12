`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/02 19:45:32
// Design Name: 
// Module Name: AD_9637_IF_v_1_0_M_AXIS
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


module AD_9637_IF_v_1_0_M_AXIS(
		input 	wire				M_AXIS_tready,
		output	wire	[3:0]		M_AXIS_tkeep,
		output	wire				M_AXIS_tlast,
		output	wire				M_AXIS_tvalid,
		output	wire	[31:0]		M_AXIS_tdata,
		output	wire				M_AXIS_aresetn,
		output	wire				M_AXIS_aclk,
		input	wire				clk,
		input   wire	[95:0]		data_paral_adc0,	
		input	wire	[95:0]		data_paral_adc1,	
		input	wire	[7:0]		adc0_clk_to_data_process,	
		input	wire	[7:0]		adc1_clk_to_data_process,	
		input	wire	[15:0]		en_data_pross,		
		input	wire				rst_data_process,
		input	wire				en_trans,
		input	wire	[10:0]		add_times_cfg
    );

    assign	M_AXIS_aresetn = ~rst_data_process; // out-> active low
    
    Data_processing	u_data_processing_ch0(
		.rst				(rst_data_process),
		.clk				(clk),
		.clk_adc0			(adc0_clk_to_data_process),
		.clk_adc1			(adc1_clk_to_data_process),
		.data_in_adc0		(data_paral_adc0),
		.data_in_adc1		(data_paral_adc1),
		.en_channel			(en_data_pross),
		.en_trans			(en_trans),
		.add_times			(add_times_cfg),
		.S_AXIS_tready		(M_AXIS_tready),
		.S_AXIS_tkeep		(M_AXIS_tkeep),
		.S_AXIS_tlast		(M_AXIS_tlast),
		.S_AXIS_tvalid		(M_AXIS_tvalid),
		.S_AXIS_tdata		(M_AXIS_tdata),
		.clk_to_fifo		(M_AXIS_aclk) 
	);
endmodule
