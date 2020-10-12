`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/02 15:00:49
// Design Name: 
// Module Name: Grar_Box_6b_2_12b
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


module Grar_Box_6b_2_12b(
	input				clk,
	input				rst,//active hight
	input		[5:0]	data_in,
	input				order,
	output	reg [11:0]	data_out,
	output	reg			ready
    );
    reg		[11:0]	temp_data;
    reg				state;
    
    always	@(posedge clk)	begin
		if (rst == 1'b1)begin
			temp_data <= 12'b0;
			data_out <= 12'b0;
			ready	<= 1'b0;
			state <= 1'b0;
		end
		else begin
			if (state == 1'b0)begin
				data_out[11:0] <= temp_data[11:0];
				if (order) begin
					temp_data[5:0] <= data_in[5:0];
				end
				else begin
					temp_data[11:6] <= data_in[5:0];
				end
//				temp_data[11:6] <= data_in[5:0];//first
				ready <= 1'b0;
				state <= 1'b1;
			end
			else begin
				if (order) begin
					temp_data[11:6] <= data_in[5:0];
				end
				else begin
					temp_data[5:0] <= data_in[5:0];
				end
//				temp_data[5:0] <= data_in[5:0];//last
				ready <= 1'b1;
				state <= 1'b0;
			end
		end
    end
endmodule
