`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/28 21:04:50
// Design Name: 
// Module Name: util_clock_div
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


module util_clock_div #(
	parameter default_div = 6'd40
)
(
	input			rst_n, // active low
	input 			clk,
	input 	[5:0]	div_par, // MAX -- 63
	output			clk_div,
	output	reg		rst_out
	);

	//div_par == 0  -> default div
	//div_par == 1  -> clk
	//div_par >1    -> clk_div
	
	reg 			clk_v;
	reg		[5:0]	cnt;
	reg		[5:0]	limit;
	reg		[5:0]	limit_rem;
	reg				flag_limit_changed;
	
	reg cnt_rst;
	
	always @ (posedge clk) begin
		if(!rst_n) begin
			limit <= (default_div/2);
			limit_rem <= (default_div/2);
			flag_limit_changed <= 1'b1;
		end
		else begin
			flag_limit_changed <= 1'b0;
			if(div_par == 6'd0)begin
				limit <= (default_div/2);
			end
			else begin
				limit <= (div_par/2);
			end
			limit_rem <= limit;
			if(limit_rem != limit) begin
				flag_limit_changed <= 1'b1;
			end
		end
	end
	
	
	always @ (posedge clk) begin
		if(!rst_n) begin
			cnt <= 6'd1;
			clk_v <= 1'b1;
		end
		else begin
			if (flag_limit_changed) begin
				cnt <= 6'd1;
				clk_v <= clk_v;//1'b1;
			end
			else begin
				if (cnt == limit)begin
					cnt <= 6'd1;
					clk_v <= ~clk_v;
				end
				else begin
					cnt <= cnt + 1'b1;
					clk_v <= clk_v;
				end
			end
		end
	end
	
	
	assign clk_div = (div_par == 4'b0001) ? clk : clk_v;
	
	always @ (negedge rst_n or posedge clk_div) begin
		if(!rst_n) begin
			rst_out <= 1'b0; //active rst
			cnt_rst <= 1'b0;
		end
		else begin
			if (cnt_rst == 1'b1)begin
				cnt_rst <= 1'b1;
				rst_out <= 1'b1; //desactive rst
			end
			else begin
				cnt_rst <= 1'b1;
			end
			
		end
	end


endmodule
