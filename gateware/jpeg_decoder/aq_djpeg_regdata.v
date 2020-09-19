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

module aq_djpeg_regdata(
	input			rst,
	input			clk,

	// Read Data
	input [31:0]	DataIn,
	input			DataInEnable,		// Data Enable
	output			DataInRead,		// Data Read
	output			DataInReq,	// Data Request

	// DataOut
	output reg [31:0] 	DataOut,			// Data Out
	output			DataOutEnable,	// Data Out Enable
	output          DataOutEnd,

	input			ImageEnable,
	input			ProcessIdle,

	// UseData
	input			UseBit,		// Used data bit
	input [6:0]	UseWidth,		// Used data bit width
	input			UseByte,		// Used data byte
	input			UseWord,		// Used data word
	input           AlignByte      // Align to next byte boundary for RSTn
);
	wire			RegValid;
	reg [95:0]		RegData;
	reg [6:0]		RegWidth;
	reg				CheckMode;
	reg				DataEnd;

	wire			PreImageEnable;
	reg				ImageReady;

//	assign RegValid	= (ImageEnable)?(RegWidth > 7'd64):(RegWidth > 7'd32);
	assign RegValid	= (ImageReady)?(RegWidth > 7'd64):(RegWidth > 7'd32);
	assign DataInReq 	= (~RegValid) & (DataEnd == 1'b0);
	assign DataInRead	= ((RegValid == 1'b0) & (DataInEnable == 1'b1) & (DataEnd == 1'b0));

	assign PreImageEnable	= ((ImageEnable == 1'b1) && (ImageReady == 1'b0))?1'b1:1'b0;

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			RegData	<= 96'd0;
			RegWidth	<= 7'd0;
			CheckMode	<= 1'b0;
			ImageReady	<= 1'b0;
		end else begin
			if(DataEnd == 1'b1 & ProcessIdle == 1'b1) begin
				RegData	<= 96'd0;
				RegWidth	<= 7'd0;
				CheckMode	<= 1'b0;
				ImageReady	<= 1'b0;
			end else if(RegValid == 1'b0 & (DataInEnable == 1'b1 | DataEnd == 1'b1)) begin
				if(ImageReady == 1'b1) begin
				    // Group 1
					if(RegData[39: 8] == 32'hFF00FF00 & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {8'h00,RegData[71:48]};
						RegData[63:32]	<= {RegData[47:40],16'hFFFF,RegData[7:0]};
						CheckMode		<= 1'b0;
					end else if(RegData[39: 28] == 12'hFFD & RegData[23: 8] == 16'hFF00 & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd8;
						RegData[95:64]	<= {16'h0000,RegData[71:56]};
						RegData[63:32]	<= {RegData[55:40],8'hFF,RegData[7:0]};
						CheckMode		<= 1'b0;
					end else if(RegData[39: 24] == 16'hFFD0 & RegData[23:12] == 12'hFFD & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd8;
						RegData[95:64]	<= {16'h0000,RegData[71:56]};
						RegData[63:32]	<= {RegData[55:40],8'hFF,RegData[7:0]};
						CheckMode		<= 1'b0;
					// Group 2
					end else if(RegData[39:24] == 16'hFF00 & RegData[15: 0] == 16'hFF00 & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {8'h00,RegData[71:48]};
						RegData[63:32]	<= {RegData[47:40],8'hFF,RegData[23:16],8'hFF};
						CheckMode		<= 1'b1;
					end else if(RegData[39:28] == 12'hFFD & RegData[15: 0] == 16'hFF00 & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd8;
						RegData[95:64]	<= {16'h0000,RegData[71:56]};
						RegData[63:32]	<= {RegData[55:40],RegData[23:16],8'hFF};
						CheckMode		<= 1'b1;
					end else if(RegData[39:24] == 16'hFF00 & RegData[15: 4] == 16'hFFD & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd8;
						RegData[95:64]	<= {16'h0000,RegData[71:56]};
						RegData[63:32]	<= {RegData[55:40],8'hFF,RegData[23:16]};
						CheckMode		<= 1'b1;
					// Group 3
					end else if(RegData[31: 0] == 32'hFF00FF00) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {16'h0000,RegData[63:48]};
						RegData[63:32]	<= {RegData[47:32],16'hFFFF};
						CheckMode		<= 1'b1;
					end else if(RegData[31: 20] == 12'hFFD & RegData[15: 0] == 16'hFF00 & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd8;
						RegData[95:64]	<= {24'h000000,RegData[63:56]};
						RegData[63:32]	<= {RegData[55:32],8'hFF};
						CheckMode		<= 1'b1;
					end else if(RegData[31: 16] == 16'hFF00 & RegData[15: 4] == 12'hFFD & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd8;
						RegData[95:64]	<= {24'h000000,RegData[63:56]};
						RegData[63:32]	<= {RegData[55:32],8'hFF};
						CheckMode		<= 1'b1;
					// Group 4
					end else if(RegData[39:24] == 16'hFF00 & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd24;
						RegData[95:64]	<= {RegData[71:40]};
						RegData[63:32]	<= {8'hFF,RegData[23:0]};
						CheckMode		<= 1'b0;
					end else if(RegData[39:28] == 12'hFFD & CheckMode != 1'b1) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {8'h00,RegData[71:48]};
						RegData[63:32]	<= {RegData[47:40], RegData[23:0]};
						CheckMode		<= 1'b0;
					// Group 5
					end else if(RegData[31:16] == 16'hFF00) begin
						RegWidth		<= RegWidth + 7'd24;
						RegData[95:64]	<= {RegData[71:40]};
						RegData[63:32]	<= {RegData[39:32],8'hFF,RegData[15:0]};
						CheckMode		<= 1'b0;
					end else if(RegData[31:20] == 12'hFFD) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {8'h00,RegData[71:48]};
						RegData[63:32]	<= {RegData[47:32], RegData[15:0]};
						CheckMode		<= 1'b0;
					// Group 6
					end else if(RegData[23: 8] == 16'hFF00) begin
						RegWidth		<= RegWidth + 7'd24;
						RegData[95:64]	<= {RegData[71:40]};
						RegData[63:32]	<= {RegData[39:32],RegData[31:24],8'hFF,RegData[7:0]};
						CheckMode		<= 1'b0;
					end else if(RegData[23:12] == 12'hFFD) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {8'h00,RegData[71:48]};
						RegData[63:32]	<= {RegData[47:24], RegData[7:0]};
						CheckMode		<= 1'b0;
					// Group 7
					end else if(RegData[15: 0] == 16'hFF00) begin
						RegWidth		<= RegWidth + 7'd24;
						RegData[95:64]	<= {RegData[71:40]};
						RegData[63:32]	<= {RegData[39:32],RegData[31:16],8'hFF};
						CheckMode		<= 1'b1;
					end else if(RegData[15: 4] == 12'hFFD) begin
						RegWidth		<= RegWidth + 7'd16;
						RegData[95:64]	<= {8'h00,RegData[71:48]};
						RegData[63:32]	<= {RegData[47:16]};
						CheckMode		<= 1'b0;
					// Group 8
					end else begin
						RegWidth		<= RegWidth + 7'd32;
						RegData[95:64]	<= RegData[63:32];
						RegData[63:32]	<= RegData[31:0];
						CheckMode		<= 1'b0;
					end
				end else begin
					RegWidth		<= RegWidth + 7'd32;
					RegData[95:64]	<= RegData[63:32];
					RegData[63:32]	<= RegData[31:0];
					CheckMode		<= 1'b0;
				end
				RegData[31: 0] <= {DataIn[7:0],DataIn[15:8],DataIn[23:16],DataIn[31:24]};
			end else if(PreImageEnable == 1'b1) begin
				if((RegData[63:32] == 32'hFF00FF00) && (RegWidth == 7'd64)) begin
                    RegWidth        <= 7'd48;
					RegData[63:32]	<= {32'h0000FFFF};
					CheckMode		<= 1'b1;
				end else if ((RegData[63:48] == 16'hFF00) && (RegWidth == 7'd64)) begin
                    RegWidth        <= 7'd56;
					RegData[63:32]	<= {16'h00FF, RegData[47:32]};
					CheckMode		<= 1'b0;
				end else if ((RegData[55:40] == 16'hFF00) && (RegWidth == 7'd64)) begin
                    RegWidth        <= 7'd56;
					RegData[63:32]	<= {8'h00,RegData[63:56],8'hFF,RegData[39:32]};
					CheckMode		<= 1'b0;
				end else if ((RegData[47:32] == 16'hFF00) && (RegWidth == 7'd64)) begin
                    RegWidth        <= 7'd56;
					RegData[63:32]	<= {16'h00,RegData[55:48],8'hFF};
					CheckMode		<= 1'b1;
				end else if ((RegData[55:40] == 16'hFF00) && (RegWidth == 7'd56)) begin
                    RegWidth        <= 7'd48;
					RegData[63:32]	<= {24'h0000FF, RegData[39:32]};
					CheckMode		<= 1'b0;
				end else if ((RegData[47:32] == 16'hFF00) && (RegWidth == 7'd56)) begin
                    RegWidth        <= 7'd48;
					RegData[63:32]	<= {16'h0000, RegData[55:48],8'hFF};
					CheckMode		<= 1'b1;
				end else if ((RegData[47:32] == 16'hFF00) && (RegWidth == 7'd48)) begin
                    RegWidth        <= 7'd40;
					RegData[63:32]	<= {32'h000000FF};
					CheckMode		<= 1'b1;
				end
				ImageReady		<= 1'b1;
			end else if(UseBit == 1'b1) begin
				RegWidth <= RegWidth - UseWidth;
			end else if(UseByte == 1'b1) begin
				RegWidth <= RegWidth - 7'd8;
			end else if(UseWord == 1'b1) begin
				RegWidth <= RegWidth - 7'd16;
			end else if(AlignByte == 1'b1) begin
			    RegWidth <= {RegWidth[6:3], 3'b0};
			end
		end
	end

	// PickUp with End of Jpeg Data
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			DataEnd <= 1'b0;
		end else begin
			if(ProcessIdle) begin
				DataEnd <= 1'b0;
			end else if(ImageEnable == 1'b1 & ((RegData[39:24] == 16'hFFD9 & CheckMode != 1'b1) | RegData[31:16] == 16'hFFD9 | RegData[23: 8] == 16'hFFD9 | RegData[15: 0] == 16'hFFD9)) begin
				DataEnd <= 1'b1;
			end
		end
	end

	function [31:0]	SliceData;
		input [95:0]	RegData;
		input [7:0]	RegWidth;

		case(RegWidth)
			//8'd33: SliceData = RegData[32: 1];
			//8'd34: SliceData = RegData[33: 2];
			//8'd35: SliceData = RegData[34: 3];
			//8'd36: SliceData = RegData[35: 4];
			//8'd37: SliceData = RegData[36: 5];
			//8'd38: SliceData = RegData[37: 6];
			//8'd39: SliceData = RegData[38: 7];
			8'd40: SliceData = RegData[39: 8];
			//8'd41: SliceData = RegData[40: 9];
			//8'd42: SliceData = RegData[41:10];
			//8'd43: SliceData = RegData[42:11];
			//8'd44: SliceData = RegData[43:12];
			//8'd45: SliceData = RegData[44:13];
			//8'd46: SliceData = RegData[45:14];
			//8'd47: SliceData = RegData[46:15];
			8'd48: SliceData = RegData[47:16];
			//8'd49: SliceData = RegData[48:17];
			//8'd50: SliceData = RegData[49:18];
			//8'd51: SliceData = RegData[50:19];
			//8'd52: SliceData = RegData[51:20];
			//8'd53: SliceData = RegData[52:21];
			//8'd54: SliceData = RegData[53:22];
			//8'd55: SliceData = RegData[54:23];
			8'd56: SliceData = RegData[55:24];
			//8'd57: SliceData = RegData[56:25];
			//8'd58: SliceData = RegData[57:26];
			//8'd59: SliceData = RegData[58:27];
			//8'd60: SliceData = RegData[59:28];
			//8'd61: SliceData = RegData[60:29];
			//8'd62: SliceData = RegData[61:30];
			//8'd63: SliceData = RegData[62:31];
			8'd64: SliceData = RegData[63:32];
			8'd65: SliceData = RegData[64:33];
			8'd66: SliceData = RegData[65:34];
			8'd67: SliceData = RegData[66:35];
			8'd68: SliceData = RegData[67:36];
			8'd69: SliceData = RegData[68:37];
			8'd70: SliceData = RegData[69:38];
			8'd71: SliceData = RegData[70:39];
			8'd72: SliceData = RegData[71:40];
			8'd73: SliceData = RegData[72:41];
			8'd74: SliceData = RegData[73:42];
			8'd75: SliceData = RegData[74:43];
			8'd76: SliceData = RegData[75:44];
			8'd77: SliceData = RegData[76:45];
			8'd78: SliceData = RegData[77:46];
			8'd79: SliceData = RegData[78:47];
			8'd80: SliceData = RegData[79:48];
			8'd81: SliceData = RegData[80:49];
			8'd82: SliceData = RegData[81:50];
			8'd83: SliceData = RegData[82:51];
			8'd84: SliceData = RegData[83:52];
			8'd85: SliceData = RegData[84:53];
			8'd86: SliceData = RegData[85:54];
			8'd87: SliceData = RegData[86:55];
			8'd88: SliceData = RegData[87:56];
			8'd89: SliceData = RegData[88:57];
			8'd90: SliceData = RegData[89:58];
			8'd91: SliceData = RegData[90:59];
			8'd92: SliceData = RegData[91:60];
			8'd93: SliceData = RegData[92:61];
			8'd94: SliceData = RegData[93:62];
			8'd95: SliceData = RegData[94:63];
			8'd96: SliceData = RegData[95:64];
			default: SliceData = 32'h00000000;
		endcase
	endfunction

	reg				OutEnable;
	reg				PreEnable;
	//reg [31:0]		DataOut;

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			OutEnable	<= 1'b0;
			PreEnable	<= 1'b0;
			DataOut	<= 32'h00000000;
		end else begin
			if(DataEnd == 1'b1 & ProcessIdle == 1'b1) begin
				OutEnable	<= 1'b0;
				PreEnable	<= 1'b0;
				DataOut	<= 32'h00000000;
			end else begin
				OutEnable	<= RegValid;
				PreEnable	<= (UseBit == 1'b1 | UseByte == 1'b1 | UseWord == 1'b1 | AlignByte == 1'b1);
				DataOut	<= SliceData(RegData,RegWidth);
			end
		end
	end

	assign DataOutEnable = (PreEnable == 1'b0)?OutEnable:1'b0;
	assign DataOutEnd = DataEnd;

endmodule
