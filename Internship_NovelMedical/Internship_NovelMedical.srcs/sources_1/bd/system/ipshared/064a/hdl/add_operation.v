`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/07 22:20:03
// Design Name: 
// Module Name: add_operation
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


module add_operation
(
	input				rst,
	input 				clk,
	input 		[10:0]	add_times,
	input				en,
	input		[11:0]	data_in,
	output	reg	[27:0]	data_out
	);

	reg		[12:0]	cnt_add;
	reg		[27:0]	temp_sum;
	reg		[10:0]	add_times_copy;
	reg				flag_add_times_changed;
	
	
	always	@(posedge clk)	begin
		if ((rst == 1'b1) || (en == 1'b0))begin
			flag_add_times_changed <= 0;
			add_times_copy <= add_times;
		end
		else begin
			if(add_times != add_times_copy) begin
				flag_add_times_changed <= 1'b1;
			end
			else begin
				flag_add_times_changed <= 1'b0;
			end
			add_times_copy <= add_times;
		end
	end
	
	always	@(posedge clk)	begin
		if ((rst == 1'b1) || (en == 1'b0) || (flag_add_times_changed == 1'b1))begin
			cnt_add <= 0;
			temp_sum <= 0;
			data_out <= 0;
		end
		else begin
			if (cnt_add < add_times)begin
				temp_sum <= temp_sum + data_in;
				cnt_add <= cnt_add + 1'b1;
			end
			else begin
				cnt_add <= 0;
				temp_sum <= data_in;
				data_out 	<= temp_sum;
			end
		end
	end

endmodule
