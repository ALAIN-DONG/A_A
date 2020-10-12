`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/28 10:40:43
// Design Name: 
// Module Name: AD_9637_SPI_LOGIC
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


module AD_9637_SPI_LOGIC(
	input				clk,
	input				rst_n,		//low active
	output	reg			spi_cs,		//spi
	output	reg			spi_sclk,	//spi
	input				begintogo,	//fpga
	output	reg			done,		//fpga
	output	reg	[7:0]	Reg_Read_Out,
	input		[23:0]	Reg_Ctrl_In,
	inout				spi_sdio	//spi
    );
	
    reg		[23:0]		ControlReg;    
	reg		[10 : 0]	state; // one-hot code state machine
    parameter	Wait		=	11'b0000_0000_001;  // s0
    parameter	Begin_go	=	11'b0000_0000_010;  //s1
	
    parameter	Write_1		=	11'b0000_0000_100;  //s2
    parameter	Write_2		=	11'b0000_0001_000;  //s3
    parameter	Write_3		=	11'b0000_0010_000;  //s4
    
    parameter	Read_1		=	11'b0000_0100_000;
    parameter	Read_2		=	11'b0000_1000_000;
    parameter	Read_3		=	11'b0001_0000_000;
    parameter	Read_4		=	11'b0010_0000_000;
    parameter	Read_5		=	11'b0100_0000_000;
    parameter	Read_6		=	11'b1000_0000_000;
    
    reg		[4:0]	cnt_bits;
    reg				Tri_en;// three state gate switch 1-> output / 0-> input
    reg				sdout;
    reg				begintogo_ready;
    
    assign spi_sdio	=	(Tri_en==1'b1)	?	sdout	:	1'bz; //judgement 

    always @ (posedge clk or negedge rst_n) begin
    	if(!rst_n) begin	  // reset low active
    		spi_cs 	<= 	1'b1; // low active
    		sdout   <= 	1'b1; // Default high level
    		done	<=	1'b0;
    		spi_sclk<=	1'b1; // Default high level
    		cnt_bits<=	5'd0;
    		Tri_en	<=	1'b1; // Default output
    		begintogo_ready	<=	1'b0;
    		state <= Wait;
    		Reg_Read_Out	<=	8'b00000000;
    		ControlReg <= 24'b0;
    	end
    	else begin
    		case(state) 
    		Wait:  //s0
    		begin
    			spi_cs 	<= 	1'b1;
    			sdout   <= 	1'b1;
    			ControlReg <= Reg_Ctrl_In;
    			begintogo_ready	<=	1'b0;
    			if (begintogo) begin
    				state <= Begin_go;
    				done	<=	1'b0;
    			end
    			else begin
    				state <= Wait;
    			end
    		end
    		
    		Begin_go: //s1
    		begin
    			spi_cs 	<= 	1'b0;
    			spi_sclk<=	1'b0;
    			
    			Tri_en	<=	1'b1;
    			done	<=	1'b0;

    			if (begintogo_ready	== 1'b0) begin
    				begintogo_ready	<=	1'b1;
    				state	<=	Begin_go;
    			end
    			else begin
    				if (begintogo == 1'b0) begin
    					//GO GO GO
    					sdout	<=	ControlReg[23];
    					begintogo_ready	<=	1'b0;
    					Reg_Read_Out	<=	8'b00000000;
    					if (ControlReg[23]==1'b1) begin
							//read
							state 	<=	Read_1;
							cnt_bits<=	5'd22;
						end
						else begin
							//write
							state 	<=	Write_1;
							cnt_bits<=	5'd22;
						end
    				end
    				else begin
    					state	<=	Begin_go;
    				end
    			end
    		end
    		
    		Write_1: // s2
    		begin
    			spi_sclk<=	1'b1;
    			state	<=	Write_2;
    		end
    		
    		Write_2: //s3
    		begin
    			sdout	<=	ControlReg[cnt_bits];
    		    if (cnt_bits == 5'b0)
    			begin
    				state	<=	Write_3;
    			end
    			else begin
    				state	<=	Write_1;
    				cnt_bits <= cnt_bits - 1;
    			end
    			spi_sclk<=	1'b0;
    		end
    		
    		Write_3:  //s4
    		begin
    			spi_cs 	<= 	1'b0;
    			spi_sclk<=	1'b1;
    			done	<=	1'b1;
    			state	<=	Wait;
    		end
    		
    		
    		Read_1:
    		begin
    			spi_sclk<=	1'b1;
    			if (cnt_bits == 5'd7)
    			begin
    				state	<=	Read_3;
    			end
    			else begin
    				state	<=	Read_2;
    			end
    		end
    		
    		    		
    		Read_2:
    		begin
    			spi_sclk<=	1'b0;
    			sdout	<=	ControlReg[cnt_bits];
				cnt_bits <= cnt_bits - 1;
				state	<=	Read_1;
    		end
    		
    		    		
    		Read_3:
    		begin
    			spi_sclk<=	1'b0;
    			sdout	<=	1'b1;  //change  0 to 1
    			cnt_bits <= 5'd7;
    			Tri_en	<=	1'b0;
    			state	<=	Read_4;
    		end
    		
    		    		
    		Read_4:
    		begin
    			spi_sclk<=	1'b1;
    			Reg_Read_Out[cnt_bits]	<=	spi_sdio;
    			if (cnt_bits == 5'd0)
    			begin
    				state	<=	Read_6;
    			end
    			else begin
    				state	<=	Read_5;
    			end
    		end
    		
    		    		
    		Read_5:
    		begin
    			cnt_bits <= cnt_bits - 1;
    			spi_sclk<=	1'b0;
    			state	<=	Read_4;
    		end
    		
    		    		
    		Read_6:
    		begin
    			spi_cs 	<= 	1'b1;
    			spi_sclk<=	1'b1;
    			sdout	<=	1'b1; //change 0 to 1
    			Tri_en	<=	1'b1;
    			done	<=	1'b1;
    			state	<=	Wait;
    		end
    		
    		default:
    		begin
    			state	<=	Wait;
    		end
		endcase
    	end
    end
endmodule
