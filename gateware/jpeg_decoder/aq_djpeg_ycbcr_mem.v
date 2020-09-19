/*
 * Copyright (C)2006-2015 AQUAXIS TECHNOLOGY.
 *  Don't remove this header. 
 * When you use this source, there is a need to inherit this header.
 *
 * License
 *  For no commercial -
 *   License:     The Open Software License 3.0
 *   License URI: http://www.opensource.org/licenses/OSL-3.0
 *
 *  For commmercial -
 *   License:     AQUAXIS License 1.0
 *   License URI: http://www.aquaxis.com/licenses
 *
 * For further information please contact.
 *	URI:    http://www.aquaxis.com/
 *	E-Mail: info(at)aquaxis.com
 */
`timescale 1ps / 1ps

module aq_djpeg_ycbcr_mem(
	input			rst,
	input			clk,

	input			DataInit,
	input [2:0]	JpegComp,

	input       DecoderNextBlock,
	input			DataInEnable,
	input [2:0]	DataInColor,
	input [2:0]	DataInPage,
	input [1:0]	DataInCount,
	input [8:0]	Data0In,
	input [8:0]	Data1In,
	output			DataInFull,

	output			DataOutEnable,
	input [7:0]	DataOutAddressY,
	input [7:0]	DataOutAddressCbCr,
	input			DataOutRead,
	input			DataOutReadNext,
	output [8:0]	DataOutY,
	output [8:0]	DataOutCb,
	output [8:0]	DataOutCr
);
	reg [8:0]		MemYA	[0:511];
	reg [8:0]		MemYB	[0:511];
	reg [8:0]		MemCbA [0:127];
	reg [8:0]		MemCbB [0:127];
	reg [8:0]		MemCrA [0:127];
	reg [8:0]		MemCrB [0:127];

	reg [1:0]		DecoderBank, WriteBank, ReadBank;

	wire [5:0]		DataInAddress;

	assign DataInAddress = {DataInPage, DataInCount};

	wire WriteNext, ReadNext;
	
	assign WriteNext = DataInEnable && (DataInAddress == 5'd63) && (((JpegComp == 3'd3) ? (DataInColor == 3'd5) : 1'b1));
	assign ReadNext = DataOutReadNext;

	// Bank
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			DecoderBank <= 2'd0;
			WriteBank	<= 2'd0;
			ReadBank	<= 2'd0;
		end else begin
			if(DataInit) begin
				DecoderBank	<= 2'd0;
			end else if(DecoderNextBlock == 1'b1) begin
//				(DataInColor == 3'd5)) begin
				DecoderBank	<= DecoderBank + 2'd1;
			end
			if(DataInit) begin
				WriteBank	<= 2'd0;
			end else if(WriteNext == 1'b1) begin
//				(DataInColor == 3'd5)) begin
				WriteBank	<= WriteBank + 2'd1;
			end
			if(DataInit) begin
				ReadBank	<= 2'd0;
			end else if(ReadNext == 1'b1) begin
				ReadBank	<= ReadBank + 2'd1;
			end
		end
	end
	
	reg [1:0]	state;
	localparam S_IDLE = 2'd0;
	localparam S_FULL = 2'd1;
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			state <= S_IDLE;
		end else begin
			if(DataInit) begin
				state <= S_IDLE;
			end else begin
				case(state)
					S_IDLE: begin
						if((DecoderNextBlock == 1'b1) && (ReadBank == DecoderBank +2'd1) && (ReadNext == 1'b0)) begin
							state <= S_FULL;
						end
					end
					S_FULL: begin
						if(ReadNext == 1'b1) begin
							state <= S_IDLE;
						end
					end
					default: begin
						state <= S_IDLE;
					end
				endcase
			end
		end
	end
	assign DataInFull = (state == S_FULL)?1'b1:1'b0;

	wire [6:0]		WriteAddressA;
	wire [6:0]		WriteAddressB;

	function [6:0] F_WriteAddressA;
		input [2:0]	DataInColor;
		input [2:0]	DataInPage;
		input [1:0]	DataInCount;
		begin
			F_WriteAddressA[6]	= DataInColor[1];
			if(DataInColor[2] == 1'b0) begin
				F_WriteAddressA[5:4]	= DataInCount[1:0];
				F_WriteAddressA[3]	= DataInColor[0] & ~DataInColor[2];
			end else begin
				F_WriteAddressA[5]	= 1'b0;
				F_WriteAddressA[4:3]	= DataInCount[1:0];
			end
			F_WriteAddressA[2:0]		= DataInPage[2:0];
		end
	endfunction

	function [6:0] F_WriteAddressB;
		input [2:0]	DataInColor;
		input [2:0]	DataInPage;
		input [1:0]	DataInCount;
		begin
			F_WriteAddressB[6]	= DataInColor[1];
			if(DataInColor[2] == 1'b0) begin
				F_WriteAddressB[5:4]	= ~DataInCount[1:0];
				F_WriteAddressB[3]	= DataInColor[0] & ~DataInColor[2];
			end else begin
				F_WriteAddressB[5]	= 1'b0;
				F_WriteAddressB[4:3]	= ~DataInCount[1:0];
			end
			F_WriteAddressB[2:0]		= DataInPage[2:0];
		end
	endfunction

	assign WriteAddressA = F_WriteAddressA(DataInColor, DataInPage, DataInCount);
	assign WriteAddressB = F_WriteAddressB(DataInColor, DataInPage, DataInCount);

	always @(posedge clk) begin
		if(DataInColor[2] == 1'b0 & DataInEnable == 1'b1) begin
			MemYA[{WriteBank, WriteAddressA}] <= Data0In;
			MemYB[{WriteBank, WriteAddressB}] <= Data1In;
		end
	end

	always @(posedge clk) begin
		if(DataInColor == 3'b100 & DataInEnable == 1'b1) begin
			MemCbA[{WriteBank, WriteAddressA[4:0]}] <= Data0In;
			MemCbB[{WriteBank, WriteAddressB[4:0]}] <= Data1In;
		end
	end

	always @(posedge clk) begin
		if(DataInColor == 3'b101 & DataInEnable == 1'b1) begin
			MemCrA[{WriteBank, WriteAddressA[4:0]}] <= Data0In;
			MemCrB[{WriteBank, WriteAddressB[4:0]}] <= Data1In;
		end
	end

	reg [8:0] ReadYA;
	reg [8:0] ReadYB;
	reg [8:0] ReadCbA;
	reg [8:0] ReadCbB;
	reg [8:0] ReadCrA;
	reg [8:0] ReadCrB;

	reg [7:0] RegAdrsY;
	reg [7:0] RegAdrsCbCr;

	always @(posedge clk) begin
		if (DataOutRead) begin
			RegAdrsY <= DataOutAddressY;

			ReadYA	<= MemYA[{ReadBank, DataOutAddressY[7],DataOutAddressY[5:0]}];
			ReadYB	<= MemYB[{ReadBank, DataOutAddressY[7],DataOutAddressY[5:0]}];

			RegAdrsCbCr <= DataOutAddressCbCr;

			ReadCbA <= MemCbA[{ReadBank, DataOutAddressCbCr[6:5],DataOutAddressCbCr[3:1]}];
			ReadCrA <= MemCrA[{ReadBank, DataOutAddressCbCr[6:5],DataOutAddressCbCr[3:1]}];

			ReadCbB <= MemCbB[{ReadBank, DataOutAddressCbCr[6:5],DataOutAddressCbCr[3:1]}];
			ReadCrB <= MemCrB[{ReadBank, DataOutAddressCbCr[6:5],DataOutAddressCbCr[3:1]}];
		end
	end

	assign DataOutEnable	= (WriteBank != ReadBank);
	assign DataOutY		    = (RegAdrsY[6] ==1'b0)?ReadYA:ReadYB;
	assign DataOutCb		= (RegAdrsCbCr[7] ==1'b0)?ReadCbA:ReadCbB;
	assign DataOutCr		= (RegAdrsCbCr[7] ==1'b0)?ReadCrA:ReadCrB;
endmodule
