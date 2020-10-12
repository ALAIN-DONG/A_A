`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/02 20:00:56
// Design Name: 
// Module Name: Data_processing
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


module Data_processing 
	(
	input 		wire			clk,
	input		wire			rst,
	input		wire	[95:0]	data_in_adc0,
	input		wire	[95:0]	data_in_adc1,
	input		wire	[7:0]	clk_adc0,
	input		wire	[7:0]	clk_adc1,
	input 		wire	[15:0]	en_channel,
	input		wire			en_trans,
	input		wire	[10:0]	add_times, 
	input		wire			S_AXIS_tready,
	output		wire	[3:0]	S_AXIS_tkeep,
	output		reg				S_AXIS_tlast,
	output		reg				S_AXIS_tvalid,
	output		reg		[31:0]	S_AXIS_tdata,
	output		wire			clk_to_fifo  
	);
	
	wire	en_pulse;
	wire	[223:0]		result_add_adc0;
	wire	[223:0]		result_add_adc1;
	reg		[27:0]		test_reg;
	wire	[27:0]		test_wire;
	reg	[1:0]	state;
	reg [3:0]	cnt_ch;
	wire	clk_trans;
	
	assign clk_trans = clk_adc0[0];
	assign S_AXIS_tkeep = 4'b1111;
	assign clk_to_fifo = clk;
	assign	test_wire = test_reg;
	
	utile_To_Pulse u_to_pulse_en(
		.clk			(clk),//200M
		.signal_in		(en_trans),
		.pulse_out		(en_pulse)
	);
	
	genvar adc0_add_opt_var;
	generate	
		for(adc0_add_opt_var = 0; adc0_add_opt_var < 8; adc0_add_opt_var = adc0_add_opt_var + 1) begin:	gen_add_option_adc0
			add_operation u_add_opt_adc0(
				.rst(rst),
				.clk(clk_adc0[adc0_add_opt_var]),
				.add_times(add_times),
				.en(en_channel[adc0_add_opt_var]),
				.data_in(data_in_adc0[(adc0_add_opt_var*12+11) : (adc0_add_opt_var*12)]),
				.data_out(result_add_adc0[(adc0_add_opt_var*28+27) : (adc0_add_opt_var*28)])
			);
		end
	endgenerate
	
	genvar adc1_add_opt_var;
	generate	
		for(adc1_add_opt_var = 0; adc1_add_opt_var < 8; adc1_add_opt_var = adc1_add_opt_var + 1) begin:	gen_add_option_adc1
			add_operation u_add_opt_adc1(
				.rst(rst),
				.clk(clk_adc1[adc1_add_opt_var]),
				.add_times(add_times),
				.en(en_channel[adc1_add_opt_var + 8]),
				.data_in(data_in_adc1[(adc1_add_opt_var*12+11) : (adc1_add_opt_var*12)]),
				.data_out(result_add_adc1[(adc1_add_opt_var*28+27) : (adc1_add_opt_var*28)])
			);
		end
	endgenerate
	
always@(posedge clk)
begin
	if(rst) begin
		S_AXIS_tvalid <= 1'b0;
		S_AXIS_tdata <= 32'd0;
		S_AXIS_tlast <= 1'b0;
		state 		<=0;
		cnt_ch 		<= 4'd0;
	end
	else begin
		case(state)
			0: 	begin
				if(en_pulse && S_AXIS_tready) begin
					S_AXIS_tvalid <= 1'b0; 
					S_AXIS_tdata <= 32'd0;
					S_AXIS_tlast <= 1'b0;
					cnt_ch <= 4'd0;
					state <= 1;
				end
				else begin
					S_AXIS_tvalid <= 1'b0;
					S_AXIS_tlast <= 1'b0;
					S_AXIS_tdata <= 32'd0;
					cnt_ch <= 4'd0;
					state <= 0;
				end
			end
			1:	begin
				if(S_AXIS_tready) begin
					
					case(cnt_ch)
						4'd0:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[27:0]};
							end
						4'd1:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[55:28]};
							end
						4'd2:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[83:56]};
							end
						4'd3:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[111:84]};
							end
						4'd4:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[139:112]};
							end
						4'd5:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[167:140]};
							end
						4'd6:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[195:168]};
							end
						4'd7:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc0[223:196]};
							end
						4'd8:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[27:0]};
							end
						4'd9:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[55:28]};
							end
						4'd10:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[83:56]};
							end
						4'd11:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[111:84]};
							end
						4'd12:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[139:112]};
							end
						4'd13:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[167:140]};
							end
						4'd14:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[195:168]};
							end
						4'd15:begin
								S_AXIS_tdata <= {cnt_ch[3:0], result_add_adc1[223:196]};
							end
						default:S_AXIS_tdata <= 0;
					endcase
					
					S_AXIS_tlast <= 1'b1;
					S_AXIS_tvalid <= 1'b1;
					if(cnt_ch == 4'b1111)begin
						state <= 0;
						cnt_ch <= 4'd0;
					end
					else begin
						state <= 2;
					end
				end
				else begin
					S_AXIS_tdata <= S_AXIS_tdata;
					S_AXIS_tvalid <= S_AXIS_tvalid;
					S_AXIS_tlast <= S_AXIS_tlast;
					state <= 1;
				end
			end       
			2:	begin
				if(S_AXIS_tready) begin
					cnt_ch <= cnt_ch + 1'b1;
					S_AXIS_tvalid <= 1'b0;
					S_AXIS_tlast <= 1'b0;
					S_AXIS_tdata <= 32'd0;
					state <= 1;
				end
				else begin
					S_AXIS_tdata <= S_AXIS_tdata;
					S_AXIS_tvalid <= S_AXIS_tvalid;
					S_AXIS_tlast <= S_AXIS_tlast;
					state <= 2;
				end
			end
			default: state <=0;
		endcase
	end              
end	

	
endmodule