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

module aq_djpeg_dht(
	input			rst,
	input			clk,

	input			DataInEnable,
	input [1:0]	DataInColor,
	input [7:0]	DataInCount,
	input [7:0]	DataIn,

	input [1:0]	ColorNumber,
	input [7:0]	TableNumber,
	output [3:0]	ZeroTable,
	output [3:0]	WidhtTable
);
	// RAM
	reg [7:0]	   DHT_Ydc [0:15];
	reg [7:0]	   DHT_Yac [0:255];
	reg [7:0]	   DHT_Cdc [0:15];
	reg [7:0]	   DHT_Cac [0:255];

	reg [7:0]	   ReadDataYdc;
	reg [7:0]	   ReadDataYac;
	reg [7:0]	   ReadDataCdc;
	reg [7:0]	   ReadDataCac;

	wire [7:0]	  ReadData;

	// RAM
	always @(posedge clk) begin
		if((DataInEnable == 1'b1) & (DataInColor == 2'b00)) begin
			DHT_Ydc[DataInCount[3:0]] <= DataIn;
		end
		if(DataInEnable ==1'b1 & DataInColor ==2'b01) begin
			DHT_Yac[DataInCount] <= DataIn;
		end
		if(DataInEnable ==1'b1 & DataInColor ==2'b10) begin
			DHT_Cdc[DataInCount[3:0]] <= DataIn;
		end
		if(DataInEnable ==1'b1 & DataInColor ==2'b11) begin
			DHT_Cac[DataInCount] <= DataIn;
		end
	end

	always @(posedge clk) begin
		ReadDataYdc[7:0] <= DHT_Ydc[TableNumber[3:0]];
		ReadDataYac[7:0] <= DHT_Yac[TableNumber];
		ReadDataCdc[7:0] <= DHT_Cdc[TableNumber[3:0]];
		ReadDataCac[7:0] <= DHT_Cac[TableNumber];
	end

	// Selector
	function [7:0] ReadDataSel;
		input [1:0]	ColorNumber;
		input [7:0]	ReadDataYdc;
		input [7:0]	ReadDataYac;
		input [7:0]	ReadDataCdc;
		input [7:0]	ReadDataCac;
		begin
			case (ColorNumber[1:0])
			2'b00: ReadDataSel[7:0] = ReadDataYdc[7:0];
			2'b01: ReadDataSel[7:0] = ReadDataYac[7:0];
			2'b10: ReadDataSel[7:0] = ReadDataCdc[7:0];
			2'b11: ReadDataSel[7:0] = ReadDataCac[7:0];
			endcase
		end
	endfunction

	assign ReadData = ReadDataSel(ColorNumber, ReadDataYdc, ReadDataYac, ReadDataCdc, ReadDataCac);

	assign ZeroTable  = ReadData[7:4];
	assign WidhtTable = ReadData[3:0];
endmodule
