`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/02 15:02:32
// Design Name: 
// Module Name: utile_To_Pulse
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


module utile_To_Pulse(
	input		clk,
	input		signal_in,
	output	reg	pulse_out
    );
    
    reg		temp_state;
    
    always	@(posedge clk)	begin
    	pulse_out	<=	1'b0;
    	if(temp_state == 0)	begin
    		if(signal_in == 1)	begin
    			pulse_out	<=	1'b1;
    			temp_state	<=	1'b1;
    		end
    	end
    	else begin
    		if(signal_in == 0)	begin
    			pulse_out	<=	1'b0;
    			temp_state	<=	1'b0;
    		end
    	end
    end
    
endmodule
