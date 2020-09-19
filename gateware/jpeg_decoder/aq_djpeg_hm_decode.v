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

module aq_djpeg_hm_decode(
	input			rst,
	input			clk,					// Reset and Clock

	// Huffman Table
	input			HuffmanTableEnable,	// Table Data In Enable
	input [1:0]	HuffmanTableColor,	// Huffman Table Color Number
	input [3:0]	HuffmanTableCount,	// Table Number
	input [15:0]	HuffmanTableCode,		// Huffman Table Data
	input [7:0]	HuffmanTableStart,	// Huffman Table Start Number

	// Huffman Decode
	input			DataInRun,				// Data In Start
	input			DataInEnable,			// Data In Enable
	input [31:0]	DataIn,				// Data In
	input [2:0]	JpegComp,
	input           JpegProgressive,
	input [1:0]     SubSamplingW,
	input [1:0]     SubSamplingH,
	input           ResetDC,

	// DHT table
	output [1:0]	DhtColor,				// Color Number
	output [7:0]	DhtNumber,				// Decode Dht Number
	input [3:0]	DhtZero,				// Zero Count of Dht Number
	input [3:0]	DhtWidth,				// Data Width of Dht Number

	// DQT Table
	output			DqtColor,				// Color Number
	output [5:0]	DqtNumber,				// Dqt Number
	input [7:0]	DqtData,				// Dqt Data

	input			DataOutIdle,
	output			DataOutEnable,
	output reg [2:0]	DataOutColor,

	// Output decode data
	output          DecodeNextBlock,
	output			DecodeUseBit,			// Used Data Bit
	output [6:0]	DecodeUseWidth,		// Used Data Width
	output			DecodeEnable,			// Data Out Enable
	output [2:0]	DecodeColor,
	output [5:0]	DecodeCount,
	output [3:0]	DecodeZero,			// Data Out with Zero Count
	output [15:0]	DecodeCode				// Data Out with Code
);
	//--------------------------------------------------------------------------
	// Register Huffman Table(YCbCr)
	//--------------------------------------------------------------------------
	// Y-DC Huffman Table
	reg [15:0]		HuffmanTable0r [0:15];	// Y-DC Huffman Table
	reg [15:0]		HuffmanTable1r [0:15];	// Y-AC Huffman Table
	reg [15:0]		HuffmanTable2r [0:15];	// C-DC Huffman Table
	reg [15:0]		HuffmanTable3r [0:15];	// C-AC Huffman Table

	reg [7:0]		HuffmanNumber0r [0:15];	// Y-DC Huffman Number
	reg [7:0]		HuffmanNumber1r [0:15];	// Y-AC Huffman Number
	reg [7:0]		HuffmanNumber2r [0:15];	// C-DC Huffman Number
	reg [7:0]		HuffmanNumber3r [0:15];	// C-AC Huffman Number

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			HuffmanTable0r[0]		<= 16'h0000;
			HuffmanNumber0r[0]	<=	8'h00;
			HuffmanTable1r[0]		<= 16'h0000;
			HuffmanNumber1r[0]	<=	8'h00;
			HuffmanTable2r[0]		<= 16'h0000;
			HuffmanNumber2r[0]	<=	8'h00;
			HuffmanTable3r[0]		<= 16'h0000;
			HuffmanNumber3r[0]	<=	8'h00;

			HuffmanTable0r[1]		<= 16'h0000;
			HuffmanNumber0r[1]	<=	8'h00;
			HuffmanTable1r[1]		<= 16'h0000;
			HuffmanNumber1r[1]	<=	8'h00;
			HuffmanTable2r[1]		<= 16'h0000;
			HuffmanNumber2r[1]	<=	8'h00;
			HuffmanTable3r[1]		<= 16'h0000;
			HuffmanNumber3r[1]	<=	8'h00;

			HuffmanTable0r[2]		<= 16'h0000;
			HuffmanNumber0r[2]	<=	8'h00;
			HuffmanTable1r[2]		<= 16'h0000;
			HuffmanNumber1r[2]	<=	8'h00;
			HuffmanTable2r[2]		<= 16'h0000;
			HuffmanNumber2r[2]	<=	8'h00;
			HuffmanTable3r[2]		<= 16'h0000;
			HuffmanNumber3r[2]	<=	8'h00;

			HuffmanTable0r[3]		<= 16'h0000;
			HuffmanNumber0r[3]	<=	8'h00;
			HuffmanTable1r[3]		<= 16'h0000;
			HuffmanNumber1r[3]	<=	8'h00;
			HuffmanTable2r[3]		<= 16'h0000;
			HuffmanNumber2r[3]	<=	8'h00;
			HuffmanTable3r[3]		<= 16'h0000;
			HuffmanNumber3r[3]	<=	8'h00;

			HuffmanTable0r[4]		<= 16'h0000;
			HuffmanNumber0r[4]	<=	8'h00;
			HuffmanTable1r[4]		<= 16'h0000;
			HuffmanNumber1r[4]	<=	8'h00;
			HuffmanTable2r[4]		<= 16'h0000;
			HuffmanNumber2r[4]	<=	8'h00;
			HuffmanTable3r[4]		<= 16'h0000;
			HuffmanNumber3r[4]	<=	8'h00;

			HuffmanTable0r[5]		<= 16'h0000;
			HuffmanNumber0r[5]	<=	8'h00;
			HuffmanTable1r[5]		<= 16'h0000;
			HuffmanNumber1r[5]	<=	8'h00;
			HuffmanTable2r[5]		<= 16'h0000;
			HuffmanNumber2r[5]	<=	8'h00;
			HuffmanTable3r[5]		<= 16'h0000;
			HuffmanNumber3r[5]	<=	8'h00;

			HuffmanTable0r[6]		<= 16'h0000;
			HuffmanNumber0r[6]	<=	8'h00;
			HuffmanTable1r[6]		<= 16'h0000;
			HuffmanNumber1r[6]	<=	8'h00;
			HuffmanTable2r[6]		<= 16'h0000;
			HuffmanNumber2r[6]	<=	8'h00;
			HuffmanTable3r[6]		<= 16'h0000;
			HuffmanNumber3r[6]	<=	8'h00;

			HuffmanTable0r[7]		<= 16'h0000;
			HuffmanNumber0r[7]	<=	8'h00;
			HuffmanTable1r[7]		<= 16'h0000;
			HuffmanNumber1r[7]	<=	8'h00;
			HuffmanTable2r[7]		<= 16'h0000;
			HuffmanNumber2r[7]	<=	8'h00;
			HuffmanTable3r[7]		<= 16'h0000;
			HuffmanNumber3r[7]	<=	8'h00;

			HuffmanTable0r[8]		<= 16'h0000;
			HuffmanNumber0r[8]	<=	8'h00;
			HuffmanTable1r[8]		<= 16'h0000;
			HuffmanNumber1r[8]	<=	8'h00;
			HuffmanTable2r[8]		<= 16'h0000;
			HuffmanNumber2r[8]	<=	8'h00;
			HuffmanTable3r[8]		<= 16'h0000;
			HuffmanNumber3r[8]	<=	8'h00;

			HuffmanTable0r[9]		<= 16'h0000;
			HuffmanNumber0r[9]	<=	8'h00;
			HuffmanTable1r[9]		<= 16'h0000;
			HuffmanNumber1r[9]	<=	8'h00;
			HuffmanTable2r[9]		<= 16'h0000;
			HuffmanNumber2r[9]	<=	8'h00;
			HuffmanTable3r[9]		<= 16'h0000;
			HuffmanNumber3r[9]	<=	8'h00;

			HuffmanTable0r[10]	<= 16'h0000;
			HuffmanNumber0r[10]	<=	8'h00;
			HuffmanTable1r[10]	<= 16'h0000;
			HuffmanNumber1r[10]	<=	8'h00;
			HuffmanTable2r[10]	<= 16'h0000;
			HuffmanNumber2r[10]	<=	8'h00;
			HuffmanTable3r[10]	<= 16'h0000;
			HuffmanNumber3r[10]	<=	8'h00;

			HuffmanTable0r[11]	<= 16'h0000;
			HuffmanNumber0r[11]	<=	8'h00;
			HuffmanTable1r[11]	<= 16'h0000;
			HuffmanNumber1r[11]	<=	8'h00;
			HuffmanTable2r[11]	<= 16'h0000;
			HuffmanNumber2r[11]	<=	8'h00;
			HuffmanTable3r[11]	<= 16'h0000;
			HuffmanNumber3r[11]	<=	8'h00;

			HuffmanTable0r[12]	<= 16'h0000;
			HuffmanNumber0r[12]	<=	8'h00;
			HuffmanTable1r[12]	<= 16'h0000;
			HuffmanNumber1r[12]	<=	8'h00;
			HuffmanTable2r[12]	<= 16'h0000;
			HuffmanNumber2r[12]	<=	8'h00;
			HuffmanTable3r[12]	<= 16'h0000;
			HuffmanNumber3r[12]	<=	8'h00;

			HuffmanTable0r[13]	<= 16'h0000;
			HuffmanNumber0r[13]	<=	8'h00;
			HuffmanTable1r[13]	<= 16'h0000;
			HuffmanNumber1r[13]	<=	8'h00;
			HuffmanTable2r[13]	<= 16'h0000;
			HuffmanNumber2r[13]	<=	8'h00;
			HuffmanTable3r[13]	<= 16'h0000;
			HuffmanNumber3r[13]	<=	8'h00;

			HuffmanTable0r[14]	<= 16'h0000;
			HuffmanNumber0r[14]	<=	8'h00;
			HuffmanTable1r[14]	<= 16'h0000;
			HuffmanNumber1r[14]	<=	8'h00;
			HuffmanTable2r[14]	<= 16'h0000;
			HuffmanNumber2r[14]	<=	8'h00;
			HuffmanTable3r[14]	<= 16'h0000;
			HuffmanNumber3r[14]	<=	8'h00;

			HuffmanTable0r[15]	<= 16'h0000;
			HuffmanNumber0r[15]	<=	8'h00;
			HuffmanTable1r[15]	<= 16'h0000;
			HuffmanNumber1r[15]	<=	8'h00;
			HuffmanTable2r[15]	<= 16'h0000;
			HuffmanNumber2r[15]	<=	8'h00;
			HuffmanTable3r[15]	<= 16'h0000;
			HuffmanNumber3r[15]	<=	8'h00;
		end else begin
			if(HuffmanTableEnable ==2'b1) begin
				if(HuffmanTableColor ==2'b00) begin
					HuffmanTable0r[HuffmanTableCount]	<= HuffmanTableCode;
					HuffmanNumber0r[HuffmanTableCount]	<= HuffmanTableStart;
				end else if(HuffmanTableColor ==2'b01) begin
					HuffmanTable1r[HuffmanTableCount]	<= HuffmanTableCode;
					HuffmanNumber1r[HuffmanTableCount]	<= HuffmanTableStart;
				end else if(HuffmanTableColor ==2'b10) begin
					HuffmanTable2r[HuffmanTableCount]	<= HuffmanTableCode;
					HuffmanNumber2r[HuffmanTableCount]	<= HuffmanTableStart;
				end else begin
					HuffmanTable3r[HuffmanTableCount]	<= HuffmanTableCode;
					HuffmanNumber3r[HuffmanTableCount]	<= HuffmanTableStart;
				end
			end
		end
	end

	//--------------------------------------------------------------------------
	// Decode Process
	//--------------------------------------------------------------------------
	reg [3:0]	Process;		// Process State
	reg [31:0]	ProcessData;	// Data

	// Huffman Table
	reg [15:0]	HuffmanTable [0:15];
	// Huffman Table Number
	reg [7:0]	HuffmanNumber [0:15];

	reg [15:0]	Place;			// Place bit
	reg [15:0]	TableCode;		// Table Code
	reg [7:0]	NumberCode;	// Start Number of Table Code
	reg [3:0]	CodeNumber;	// Huffman code width
	reg [15:0]	DataNumber;	// Huffman code

	reg [2:0]	ProcessColor;
	reg [5:0]	ProcessCount;

	reg		 OutEnable;		// Output Enable
	reg [3:0]	OutZero;		// Output Zero Count
	reg [15:0]	OutCode;		// Output Data Code
	wire [15:0] OutCodeP;		// Output Data Code

	reg [4:0]	UseWidth;		// Output used width

//	reg				 DataOutEnable;

	reg signed [31:0] PreData [0:2];

	wire [15:0] SubCode;

	localparam ProcIdle	= 4'h0;
	localparam Phase1	= 4'h1;
	localparam Phase2	= 4'h2;
	localparam Phase3	= 4'h3;
	localparam Phase4	= 4'h4;
	localparam Phase5	= 4'h5;
	localparam Phase6	= 4'h6;
	localparam Phase7	= 4'h7;
	localparam Phase8	= 4'h8;

	function [15:0] OutCodePSel;
		input [3:0]		DhtWidth;
		input [31:0]	 ProcessData;
		begin
			case (DhtWidth)
				4'h0: OutCodePSel = 16'h0000;
				4'h1: OutCodePSel = {15'h0000,ProcessData[31]};
				4'h2: OutCodePSel = {14'h0000,ProcessData[31:30]};
				4'h3: OutCodePSel = {13'h0000,ProcessData[31:29]};
				4'h4: OutCodePSel = {12'h000, ProcessData[31:28]};
				4'h5: OutCodePSel = {11'h000, ProcessData[31:27]};
				4'h6: OutCodePSel = {10'h000, ProcessData[31:26]};
				4'h7: OutCodePSel = {9'h000,	ProcessData[31:25]};
				4'h8: OutCodePSel = {8'h00,	ProcessData[31:24]};
				4'h9: OutCodePSel = {7'h00,	ProcessData[31:23]};
				4'hA: OutCodePSel = {6'h00,	ProcessData[31:22]};
				4'hB: OutCodePSel = {5'h00,	ProcessData[31:21]};
				4'hC: OutCodePSel = {4'h0,	 ProcessData[31:20]};
				4'hD: OutCodePSel = {3'h0,	 ProcessData[31:19]};
				4'hE: OutCodePSel = {2'h0,	 ProcessData[31:18]};
				4'hF: OutCodePSel = {1'h0,	 ProcessData[31:17]};
			endcase
		end
	endfunction
	assign OutCodeP = OutCodePSel(DhtWidth, ProcessData);

	function [15:0] SubCodeSel;
		input [3:0]		DhtWidth;
		begin
		case (DhtWidth)
			4'h0: SubCodeSel = 16'hFFFF;
			4'h1: SubCodeSel = 16'hFFFE;
			4'h2: SubCodeSel = 16'hFFFC;
			4'h3: SubCodeSel = 16'hFFF8;
			4'h4: SubCodeSel = 16'hFFF0;
			4'h5: SubCodeSel = 16'hFFE0;
			4'h6: SubCodeSel = 16'hFFC0;
			4'h7: SubCodeSel = 16'hFF80;
			4'h8: SubCodeSel = 16'hFF00;
			4'h9: SubCodeSel = 16'hFE00;
			4'hA: SubCodeSel = 16'hFC00;
			4'hB: SubCodeSel = 16'hF800;
			4'hC: SubCodeSel = 16'hF000;
			4'hD: SubCodeSel = 16'hE000;
			4'hE: SubCodeSel = 16'hC000;
			4'hF: SubCodeSel = 16'h8000;
		endcase
	end
	endfunction
	assign SubCode = SubCodeSel(DhtWidth);

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			Process			<= ProcIdle;
			ProcessData		<= 32'h00000000;
			ProcessCount	<= 6'd0;
			OutEnable		<= 1'b0;
//			DataOutEnable	<= 1'b0;
			DataOutColor	<= 3'b000;
			PreData[0]		<= 32'h00000000;
			PreData[1]		<= 32'h00000000;
			PreData[2]		<= 32'h00000000;
			UseWidth		<= 5'h00;
			CodeNumber		<= 4'd0;
		end else begin
			case (Process)
				ProcIdle: begin
					if(DataInRun == 1'b1) begin
						Process	<= Phase1;
					end else begin
						// Reset DC code
						PreData[0]	<= 32'h00000000;
						PreData[1]	<= 32'h00000000;
						PreData[2]	<= 32'h00000000;
					end
					OutEnable		<= 1'b0;
					ProcessColor	<= 3'b000;
					ProcessCount	<= 6'd0;
//					DataOutEnable	<= 1'b0;
					DataOutColor	<= 3'b000;
				end
				// get a table-data and table-number
				Phase1: begin
					if(DataInRun == 1'b0) begin
						Process		<= ProcIdle;
					end else if(DataInEnable == 1'b1 & DataOutIdle == 1'b1) begin
						Process		<= Phase2;
						ProcessData	<= DataIn;
					end
					if (ResetDC) begin
                        PreData[0]		<= 32'h00000000;
                        PreData[1]		<= 32'h00000000;
                        PreData[2]		<= 32'h00000000;
					end
					OutEnable	<= 1'b0;
//					DataOutEnable	<= 1'b0;
					if(ProcessColor[2] == 1'b0) begin
						if(ProcessCount == 0) begin
							HuffmanTable[0]	<= HuffmanTable0r[0];
							HuffmanNumber[0]	<= HuffmanNumber0r[0];
							HuffmanTable[1]	<= HuffmanTable0r[1];
							HuffmanNumber[1]	<= HuffmanNumber0r[1];
							HuffmanTable[2]	<= HuffmanTable0r[2];
							HuffmanNumber[2]	<= HuffmanNumber0r[2];
							HuffmanTable[3]	<= HuffmanTable0r[3];
							HuffmanNumber[3]	<= HuffmanNumber0r[3];
							HuffmanTable[4]	<= HuffmanTable0r[4];
							HuffmanNumber[4]	<= HuffmanNumber0r[4];
							HuffmanTable[5]	<= HuffmanTable0r[5];
							HuffmanNumber[5]	<= HuffmanNumber0r[5];
							HuffmanTable[6]	<= HuffmanTable0r[6];
							HuffmanNumber[6]	<= HuffmanNumber0r[6];
							HuffmanTable[7]	<= HuffmanTable0r[7];
							HuffmanNumber[7]	<= HuffmanNumber0r[7];
							HuffmanTable[8]	<= HuffmanTable0r[8];
							HuffmanNumber[8]	<= HuffmanNumber0r[8];
							HuffmanTable[9]	<= HuffmanTable0r[9];
							HuffmanNumber[9]	<= HuffmanNumber0r[9];
							HuffmanTable[10]	<= HuffmanTable0r[10];
							HuffmanNumber[10]	<= HuffmanNumber0r[10];
							HuffmanTable[11]	<= HuffmanTable0r[11];
							HuffmanNumber[11]	<= HuffmanNumber0r[11];
							HuffmanTable[12]	<= HuffmanTable0r[12];
							HuffmanNumber[12]	<= HuffmanNumber0r[12];
							HuffmanTable[13]	<= HuffmanTable0r[13];
							HuffmanNumber[13]	<= HuffmanNumber0r[13];
							HuffmanTable[14]	<= HuffmanTable0r[14];
							HuffmanNumber[14]	<= HuffmanNumber0r[14];
							HuffmanTable[15]	<= HuffmanTable0r[15];
							HuffmanNumber[15]	<= HuffmanNumber0r[15];
						end else begin
							HuffmanTable[0]	<= HuffmanTable1r[0];
							HuffmanNumber[0]	<= HuffmanNumber1r[0];
							HuffmanTable[1]	<= HuffmanTable1r[1];
							HuffmanNumber[1]	<= HuffmanNumber1r[1];
							HuffmanTable[2]	<= HuffmanTable1r[2];
							HuffmanNumber[2]	<= HuffmanNumber1r[2];
							HuffmanTable[3]	<= HuffmanTable1r[3];
							HuffmanNumber[3]	<= HuffmanNumber1r[3];
							HuffmanTable[4]	<= HuffmanTable1r[4];
							HuffmanNumber[4]	<= HuffmanNumber1r[4];
							HuffmanTable[5]	<= HuffmanTable1r[5];
							HuffmanNumber[5]	<= HuffmanNumber1r[5];
							HuffmanTable[6]	<= HuffmanTable1r[6];
							HuffmanNumber[6]	<= HuffmanNumber1r[6];
							HuffmanTable[7]	<= HuffmanTable1r[7];
							HuffmanNumber[7]	<= HuffmanNumber1r[7];
							HuffmanTable[8]	<= HuffmanTable1r[8];
							HuffmanNumber[8]	<= HuffmanNumber1r[8];
							HuffmanTable[9]	<= HuffmanTable1r[9];
							HuffmanNumber[9]	<= HuffmanNumber1r[9];
							HuffmanTable[10]	<= HuffmanTable1r[10];
							HuffmanNumber[10]	<= HuffmanNumber1r[10];
							HuffmanTable[11]	<= HuffmanTable1r[11];
							HuffmanNumber[11]	<= HuffmanNumber1r[11];
							HuffmanTable[12]	<= HuffmanTable1r[12];
							HuffmanNumber[12]	<= HuffmanNumber1r[12];
							HuffmanTable[13]	<= HuffmanTable1r[13];
							HuffmanNumber[13]	<= HuffmanNumber1r[13];
							HuffmanTable[14]	<= HuffmanTable1r[14];
							HuffmanNumber[14]	<= HuffmanNumber1r[14];
							HuffmanTable[15]	<= HuffmanTable1r[15];
							HuffmanNumber[15]	<= HuffmanNumber1r[15];
						end
					end else begin
						if(ProcessCount == 0) begin
							HuffmanTable[0]	<= HuffmanTable2r[0];
							HuffmanNumber[0]	<= HuffmanNumber2r[0];
							HuffmanTable[1]	<= HuffmanTable2r[1];
							HuffmanNumber[1]	<= HuffmanNumber2r[1];
							HuffmanTable[2]	<= HuffmanTable2r[2];
							HuffmanNumber[2]	<= HuffmanNumber2r[2];
							HuffmanTable[3]	<= HuffmanTable2r[3];
							HuffmanNumber[3]	<= HuffmanNumber2r[3];
							HuffmanTable[4]	<= HuffmanTable2r[4];
							HuffmanNumber[4]	<= HuffmanNumber2r[4];
							HuffmanTable[5]	<= HuffmanTable2r[5];
							HuffmanNumber[5]	<= HuffmanNumber2r[5];
							HuffmanTable[6]	<= HuffmanTable2r[6];
							HuffmanNumber[6]	<= HuffmanNumber2r[6];
							HuffmanTable[7]	<= HuffmanTable2r[7];
							HuffmanNumber[7]	<= HuffmanNumber2r[7];
							HuffmanTable[8]	<= HuffmanTable2r[8];
							HuffmanNumber[8]	<= HuffmanNumber2r[8];
							HuffmanTable[9]	<= HuffmanTable2r[9];
							HuffmanNumber[9]	<= HuffmanNumber2r[9];
							HuffmanTable[10]	<= HuffmanTable2r[10];
							HuffmanNumber[10]	<= HuffmanNumber2r[10];
							HuffmanTable[11]	<= HuffmanTable2r[11];
							HuffmanNumber[11]	<= HuffmanNumber2r[11];
							HuffmanTable[12]	<= HuffmanTable2r[12];
							HuffmanNumber[12]	<= HuffmanNumber2r[12];
							HuffmanTable[13]	<= HuffmanTable2r[13];
							HuffmanNumber[13]	<= HuffmanNumber2r[13];
							HuffmanTable[14]	<= HuffmanTable2r[14];
							HuffmanNumber[14]	<= HuffmanNumber2r[14];
							HuffmanTable[15]	<= HuffmanTable2r[15];
							HuffmanNumber[15]	<= HuffmanNumber2r[15];
						end else begin
							HuffmanTable[0]	<= HuffmanTable3r[0];
							HuffmanNumber[0]	<= HuffmanNumber3r[0];
							HuffmanTable[1]	<= HuffmanTable3r[1];
							HuffmanNumber[1]	<= HuffmanNumber3r[1];
							HuffmanTable[2]	<= HuffmanTable3r[2];
							HuffmanNumber[2]	<= HuffmanNumber3r[2];
							HuffmanTable[3]	<= HuffmanTable3r[3];
							HuffmanNumber[3]	<= HuffmanNumber3r[3];
							HuffmanTable[4]	<= HuffmanTable3r[4];
							HuffmanNumber[4]	<= HuffmanNumber3r[4];
							HuffmanTable[5]	<= HuffmanTable3r[5];
							HuffmanNumber[5]	<= HuffmanNumber3r[5];
							HuffmanTable[6]	<= HuffmanTable3r[6];
							HuffmanNumber[6]	<= HuffmanNumber3r[6];
							HuffmanTable[7]	<= HuffmanTable3r[7];
							HuffmanNumber[7]	<= HuffmanNumber3r[7];
							HuffmanTable[8]	<= HuffmanTable3r[8];
							HuffmanNumber[8]	<= HuffmanNumber3r[8];
							HuffmanTable[9]	<= HuffmanTable3r[9];
							HuffmanNumber[9]	<= HuffmanNumber3r[9];
							HuffmanTable[10]	<= HuffmanTable3r[10];
							HuffmanNumber[10]	<= HuffmanNumber3r[10];
							HuffmanTable[11]	<= HuffmanTable3r[11];
							HuffmanNumber[11]	<= HuffmanNumber3r[11];
							HuffmanTable[12]	<= HuffmanTable3r[12];
							HuffmanNumber[12]	<= HuffmanNumber3r[12];
							HuffmanTable[13]	<= HuffmanTable3r[13];
							HuffmanNumber[13]	<= HuffmanNumber3r[13];
							HuffmanTable[14]	<= HuffmanTable3r[14];
							HuffmanNumber[14]	<= HuffmanNumber3r[14];
							HuffmanTable[15]	<= HuffmanTable3r[15];
							HuffmanNumber[15]	<= HuffmanNumber3r[15];
						end
					end
				end
				// compare table
				Phase2: begin
					Process		<= Phase4;
					if(ProcessData[31:16] >= HuffmanTable[0])	Place[0]	<= 1'b1;
					else											Place[0]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[1])	Place[1]	<= 1'b1;
					else											Place[1]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[2])	Place[2]	<= 1'b1;
					else											Place[2]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[3])	Place[3]	<= 1'b1;
					else											Place[3]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[4])	Place[4]	<= 1'b1;
					else											Place[4]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[5])	Place[5]	<= 1'b1;
					else											Place[5]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[6])	Place[6]	<= 1'b1;
					else											Place[6]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[7])	Place[7]	<= 1'b1;
					else											Place[7]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[8])	Place[8]	<= 1'b1;
					else											Place[8]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[9])	Place[9]	<= 1'b1;
					else											Place[9]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[10])	Place[10]	<= 1'b1;
					else											Place[10]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[11])	Place[11]	<= 1'b1;
					else											Place[11]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[12])	Place[12]	<= 1'b1;
					else											Place[12]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[13])	Place[13]	<= 1'b1;
					else											Place[13]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[14])	Place[14]	<= 1'b1;
					else											Place[14]	<= 1'b0;
					if(ProcessData[31:16] >= HuffmanTable[15])	Place[15]	<= 1'b1;
					else											Place[15]	<= 1'b0;
				end
				// shift code
				Phase4: begin
					Process	<= Phase5;
					case (Place)
						16'b0000000000000001: begin
							TableCode		<= {15'h0000,HuffmanTable[0][15]};
							NumberCode		<= HuffmanNumber[0];
							CodeNumber		<= 4'h0;
							DataNumber		<= {15'h0000,ProcessData[31]};
							ProcessData	<= {ProcessData[30:0],1'b0};
						end
						16'b0000000000000011: begin
							TableCode		<= {14'h0000,HuffmanTable[1][15:14]};
							NumberCode		<= HuffmanNumber[1];
							CodeNumber		<= 4'h1;
							DataNumber		<= {14'h0000,ProcessData[31:30]};
							ProcessData	<= {ProcessData[29:0],2'b00};
						end
						16'b0000000000000111: begin
							TableCode		<= {13'h0000,HuffmanTable[2][15:13]};
							NumberCode		<= HuffmanNumber[2];
							CodeNumber		<= 4'h2;
							DataNumber		<= {13'h0000,ProcessData[31:29]};
							ProcessData	<= {ProcessData[28:0],3'b000};
						end
						16'b0000000000001111: begin
							TableCode		<= {12'h000,HuffmanTable[3][15:12]};
							NumberCode		<= HuffmanNumber[3];
							CodeNumber		<= 4'h3;
							DataNumber		<= {12'h000,ProcessData[31:28]};
							ProcessData	<= {ProcessData[27:0],4'h0};
						end
						16'b0000000000011111: begin
							TableCode		<= {11'h000,HuffmanTable[4][15:11]};
							NumberCode		<= HuffmanNumber[4];
							CodeNumber		<= 4'h4;
							DataNumber		<= {11'h000,ProcessData[31:27]};
							ProcessData	<= {ProcessData[26:0],5'h00};
						end
						16'b0000000000111111: begin
							TableCode		<= {10'h000,HuffmanTable[5][15:10]};
							NumberCode		<= HuffmanNumber[5];
							CodeNumber		<= 4'h5;
							DataNumber		<= {10'h000,ProcessData[31:26]};
							ProcessData	<= {ProcessData[25:0],6'h00};
						end
						16'b0000000001111111: begin
							TableCode		<= {9'h000,HuffmanTable[6][15:9]};
							NumberCode		<= HuffmanNumber[6];
							CodeNumber		<= 4'h6;
							DataNumber		<= {9'h000,ProcessData[31:25]};
							ProcessData	<= {ProcessData[24:0],7'h00};
						end
						16'b0000000011111111: begin
							TableCode		<= {8'h00,HuffmanTable[7][15:8]};
							NumberCode		<= HuffmanNumber[7];
							CodeNumber		<= 4'h7;
							DataNumber		<= {8'h00,ProcessData[31:24]};
							ProcessData	<= {ProcessData[23:0],8'h00};
						end
						16'b0000000111111111: begin
							TableCode		<= {7'h00,HuffmanTable[8][15:7]};
							NumberCode		<= HuffmanNumber[8];
							CodeNumber		<= 4'h8;
							DataNumber		<= {7'h00,ProcessData[31:23]};
							ProcessData	<= {ProcessData[22:0],9'h000};
						end
						16'b0000001111111111: begin
							TableCode		<= {6'h00,HuffmanTable[9][15:6]};
							NumberCode		<= HuffmanNumber[9];
							CodeNumber		<= 4'h9;
							DataNumber		<= {6'h00,ProcessData[31:22]};
							ProcessData	<= {ProcessData[21:0],10'h000};
						end
						16'b0000011111111111: begin
							TableCode		<= {5'h00,HuffmanTable[10][15:5]};
							NumberCode		<= HuffmanNumber[10];
							CodeNumber		<= 4'hA;
							DataNumber		<= {5'h00,ProcessData[31:21]};
							ProcessData	<= {ProcessData[20:0],11'h000};
						end
						16'b0000111111111111: begin
							TableCode		<= {4'h0,HuffmanTable[11][15:4]};
							NumberCode		<= HuffmanNumber[11];
							CodeNumber		<= 4'hB;
							DataNumber		<= {4'h0,ProcessData[31:20]};
							ProcessData	<= {ProcessData[19:0],12'h000};
						end
						16'b0001111111111111: begin
							TableCode		<= {3'h0,HuffmanTable[12][15:3]};
							NumberCode		<= HuffmanNumber[12];
							CodeNumber		<= 4'hC;
							DataNumber		<= {3'h0,ProcessData[31:19]};
							ProcessData	<= {ProcessData[18:0],13'h0000};
						end
						16'b0011111111111111: begin
							TableCode		<= {2'h0,HuffmanTable[13][15:2]};
							NumberCode		<= HuffmanNumber[13];
							CodeNumber		<= 4'hD;
							DataNumber		<= {2'h0,ProcessData[31:18]};
							ProcessData	<= {ProcessData[17:0],14'h0000};
						end
						16'b0111111111111111: begin
							TableCode		<= {1'h0,HuffmanTable[14][15:1]};
							NumberCode		<= HuffmanNumber[14];
							CodeNumber		<= 4'hE;
							DataNumber		<= {1'h0,ProcessData[31:17]};
							ProcessData	<= {ProcessData[16:0],15'h0000};
						end
						16'b1111111111111111: begin
							TableCode		<= HuffmanTable[15];
							NumberCode		<= HuffmanNumber[15];
							CodeNumber		<= 4'hF;
							DataNumber		<= ProcessData[31:16] ;
							ProcessData	<= {ProcessData[15:0],16'h0000};
						end
					endcase
				end
				Phase5: begin
					if(DataOutIdle == 1'b1) Process	<= Phase6;
				end
				Phase6: begin
					Process	<= Phase7;
					OutZero	<= DhtZero;
					UseWidth	<= CodeNumber + DhtWidth +5'd1;
					if(ProcessCount == 0) begin
						OutEnable	<= 1'b1;
					end else begin
						if(DhtZero == 4'h0 & DhtWidth == 4'h0) begin
							ProcessCount	<= 6'd63;
							OutEnable		<= 1'b0;
						end else if(DhtZero == 4'hF & DhtWidth == 4'h0) begin
							ProcessCount	<= ProcessCount + 6'd15;
							OutEnable		<= 1'b0;
						end else begin
							ProcessCount	<= ProcessCount + DhtZero;
							OutEnable		<= 1'b1;
						end
					end

					if(ProcessData[31] == 1'b0 & DhtWidth != 0) begin
						OutCode	<= (OutCodeP | SubCode) + 16'h0001;
					end else begin
						OutCode	<= OutCodeP;
					end
				end
				Phase7: begin
					Process	<= Phase8;
					if(ProcessCount == 0) begin
						if(ProcessColor[2] == 1'b0) begin
							OutCode	<= OutCode + PreData[0][15:0];
							PreData[0]	<= OutCode + PreData[0];
						end else begin
							if(ProcessColor[0] == 1'b0) begin
								OutCode	<= OutCode + PreData[1][15:0];
								PreData[1]	<= OutCode + PreData[1];
							end else begin
								OutCode	<= OutCode + PreData[2][15:0];
								PreData[2]	<= OutCode + PreData[2];
							end
						end
					end
				end
				Phase8: begin
					OutEnable	<= 1'b0;
					Process		<= Phase1;
					if(ProcessCount <6'd63 && (!JpegProgressive)) begin
						ProcessCount	<= ProcessCount +6'd1;
					end else begin
						ProcessCount	<= 6'd0;
//						DataOutEnable	<= 1'b1;
						DataOutColor	<= ProcessColor;
						// JPEGコンポーネント数が3ならブロックは6つある
						// JPEGコンポーネント数が1ならブロックは4つしかない(グレースケール)
						if (JpegComp == 3) begin
							case (ProcessColor)
							3'd0: ProcessColor <= (SubSamplingW == 2'd2) ? ProcessColor +3'd1
												: (SubSamplingH == 2'd2) ? 3'd2
																			: 3'd4;
							3'd1: ProcessColor <= (SubSamplingH == 2'd2) ? ProcessColor +3'd1
																			: 3'd4;
							3'd2: ProcessColor <= (SubSamplingW == 2'd2) ? ProcessColor +3'd1
																			: 3'd4;
							3'd5: ProcessColor <= 3'd0;
							default: ProcessColor <= ProcessColor +3'd1;
							endcase
						end else begin
							ProcessColor <= 3'd0;
						end
					end
				end	
			endcase
		end
	end

	assign DhtColor[1]		= ProcessColor[2];
	assign DhtColor[0]		= ProcessCount != 6'd0;
	assign DhtNumber			= DataNumber - TableCode + NumberCode;

	assign DqtColor			= ProcessColor[2];
	assign DqtNumber			= ProcessCount[5:0];

	assign DecodeNextBlock = (Process == Phase8) 
						  && (JpegProgressive || (ProcessCount == 6'd63)) 
						  && ((JpegComp == 3) ? (ProcessColor == 3'd5) : (1'b1));

	assign DecodeUseBit		= Process == Phase7;
	assign DecodeUseWidth	= UseWidth;

	assign DecodeEnable		= OutEnable == 1'b1 & Process == Phase8;
	assign DecodeColor		= ProcessColor;
	assign DecodeCount		= ProcessCount[5:0];
	assign DecodeZero			= OutZero;
	// Assuming the first section of progressive JPEG has fixed shift of 1 to reduce shifter size
	assign DecodeCode			= (DqtData * OutCode) << JpegProgressive;
	// First round of progressive JPEG contains DC only so only 1 component per block
	assign DataOutEnable		= (Process == Phase8) & (ProcessCount >= 6'd63 || JpegProgressive);

endmodule
