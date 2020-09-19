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

module aq_djpeg_huffman(
	input			rst,
	input			clk,

	// Init
	input			ProcessInit,

	// DQT Table
	input			DqtInEnable,
	input			DqtInColor,
	input [5:0]	 DqtInCount,
	input [7:0]	 DqtInData,

	// DHT Table
	input			DhtInEnable,
	input [1:0]	 DhtInColor,
	input [7:0]	 DhtInCount,
	input [7:0]	 DhtInData,

	// Huffman Table
	input			HuffmanTableEnable,	// Table Data In Enable
	input [1:0]	 HuffmanTableColor,	// Huffman Table Color Number
	input [3:0]	 HuffmanTableCount,	// Table Number
	input [15:0]	HuffmanTableCode,	// Huffman Table Data
	input [7:0]	 HuffmanTableStart,	// Huffman Table Start Number

	// Huffman Decode
	input			DataInRun,			// Data In Start
	input			DataInEnable,			// Data In Enable
	input [31:0]	DataIn,				// Data In
	input [2:0]	JpegComp,
    input           JpegProgressive,
	input [11:0]    JpegBlockWidth,
	input [11:0]    JpegBlockHeight,
	input [1:0]     SubSamplingW,
	input [1:0]     SubSamplingH,
	input [15:0]    JpegRestart,
    
	output          DecodeNextBlock,
	output			DecodeUseBit,
	output [6:0]	DecodeUseWidth,
	output          DecodeAlignByte,

	// Data Out
	output			DataOutEnable,
	output [2:0]	DataOutColor,
	input			DataOutRead,
	input [4:0]	 DataOutAddress,
	output [15:0]	DataOutA,
	output [15:0]	DataOutB
);
	wire			HmDqtColor;
	wire [5:0]		HmDqtNumber;
	wire [7:0]		HmDqtData;

	// DQT Table
	aq_djpeg_dqt u_jpeg_dqt(
		.rst			( rst				),
		.clk			( clk				),

		.DataInEnable	( DqtInEnable		),
		.DataInColor	( DqtInColor		),
		.DataInCount	( DqtInCount[5:0]	),
		.DataIn			( DqtInData		 ),

		.TableColor		( HmDqtColor		),
		.TableNumber	( HmDqtNumber		),
		.TableData		( HmDqtData		 )
	);

	wire [1:0]		HmDhtColor;
	wire [7:0]		HmDhtNumber;
	wire [3:0]		HmDhtZero;
	wire [3:0]		HmDhtWidth;

	aq_djpeg_dht u_jpeg_dht(
		.rst			( rst			),
		.clk			( clk			),

		.DataInEnable	( DhtInEnable	),
		.DataInColor	( DhtInColor	),
		.DataInCount	( DhtInCount	),
		.DataIn			( DhtInData	 ),

		.ColorNumber	( HmDhtColor	),
		.TableNumber	( HmDhtNumber	),
		.ZeroTable		( HmDhtZero	 ),
		.WidhtTable		( HmDhtWidth	)
	);

	wire [5:0]		HmDecCount;
	wire [15:0]	 HmDecData;

	wire            HmInEnable;

	wire			HmOutEnable;
	wire [2:0]		HmOutColor;

	wire            HmDecodeNextBlock;
	reg  [11:0]     HmDecodeBlockX;
	reg  [11:0]     HmDecodeBlockY;
	reg             HmDecodeFinish;

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			HmDecodeBlockX <= 12'd0;
			HmDecodeBlockY <= 12'd0;
			HmDecodeFinish <= 1'b0;
		end else begin
			if(ProcessInit) begin
				HmDecodeBlockX <= 12'd0;
				HmDecodeBlockY <= 12'd0;
				HmDecodeFinish <= 1'b0;
			end else if(HmDecodeNextBlock) begin
					if(JpegBlockWidth == HmDecodeBlockX +1) begin
						if(JpegBlockHeight == HmDecodeBlockY +1) begin
							HmDecodeFinish <= 1'b1;
						end else begin
							HmDecodeBlockX <= 12'd0;
							HmDecodeBlockY <= HmDecodeBlockY + 12'd1;
						end
					end else begin
						HmDecodeBlockX <= HmDecodeBlockX + 12'd1;
					end
			end
		end
	end
	
	reg  [15:0]     HmDecodeCount;
	reg             HmDecodePreAlignByte;
	reg             HmDecodeAlignByte;
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			HmDecodeCount <= 16'd0;
			HmDecodePreAlignByte <= 1'b0;
			HmDecodeAlignByte <= 1'b0;
		end else begin
			if(ProcessInit) begin
				HmDecodeCount <= 16'd0;
			    HmDecodePreAlignByte <= 1'b0;
			    HmDecodeAlignByte <= 1'b0;
			end else if(HmDecodeNextBlock) begin
			    if (JpegRestart == HmDecodeCount + 1 && JpegRestart != 0) begin
			        HmDecodeCount <= 16'd0;
			        HmDecodePreAlignByte <= 1'b1;
			    end else begin
			        HmDecodeCount <= HmDecodeCount + 1;
			    end
			end
			
			if (HmDecodeAlignByte) begin
			    HmDecodeAlignByte <= 1'b0;
			end else if (DataInEnable) begin
			    HmDecodeAlignByte <= HmDecodePreAlignByte;
			    HmDecodePreAlignByte <= 1'b0;
			end
		end
	end

	assign DecodeNextBlock = HmDecodeNextBlock;
	assign HmInEnable = DataInEnable & (~HmDecodeFinish) & (~HmDecodePreAlignByte) & (~HmDecodeAlignByte);
	assign DecodeAlignByte = HmDecodeAlignByte;

	wire HmOutIdle;
	wire HmDecEnable;

	aq_djpeg_hm_decode u_jpeg_hm_decode(
		.rst				( rst					),
		.clk				( clk					),

		// Huffman Table
		.HuffmanTableEnable	( HuffmanTableEnable	),
		.HuffmanTableColor	( HuffmanTableColor	 ),
		.HuffmanTableCount	( HuffmanTableCount	 ),
		.HuffmanTableCode	( HuffmanTableCode		),
		.HuffmanTableStart	( HuffmanTableStart	 ),

		// Huffman Decode
		.DataInRun			( DataInRun			 ),
		.DataInEnable		( HmInEnable    	),
		.DataIn			( DataIn				),
		.JpegComp			( JpegComp				),
		.JpegProgressive    ( JpegProgressive       ),
		.SubSamplingW       ( SubSamplingW          ),
		.SubSamplingH       ( SubSamplingH          ),
		.ResetDC            ( HmDecodePreAlignByte  ),

		// Huffman Table List
		.DhtColor			( HmDhtColor			),
		.DhtNumber			( HmDhtNumber			),
		.DhtZero			( HmDhtZero			 ),
		.DhtWidth			( HmDhtWidth			),

		// DQT Table
		.DqtColor			( HmDqtColor			),
		.DqtNumber			( HmDqtNumber			),
		.DqtData			( HmDqtData			 ),

		.DataOutIdle		( HmOutIdle			 ),
		.DataOutEnable		( HmOutEnable			),
		.DataOutColor		( HmOutColor			),

		// Output decode data
		.DecodeNextBlock    ( HmDecodeNextBlock     ),

		.DecodeUseBit		( DecodeUseBit			),
		.DecodeUseWidth		( DecodeUseWidth		),

		.DecodeEnable		( HmDecEnable			),
		.DecodeColor		(						),
		.DecodeCount		( HmDecCount			),
		.DecodeZero			(						),
		.DecodeCode			( HmDecData			 )
		);

	// Ziguzagu to iDCTx Matrix
	aq_djpeg_ziguzagu u_jpeg_ziguzagu(
		.rst				( rst				),
		.clk				( clk				),

		.DataInit			( ProcessInit		),
		.HuffmanEndEnable	( HmOutEnable		),

		.DataInEnable		( HmDecEnable		),
		.DataInAddress		( HmDecCount		),
		.DataInColor		( HmOutColor		),
		.DataInIdle			( HmOutIdle		 ),
		.DataIn				( HmDecData		 ),

		.DataOutEnable		( DataOutEnable	 ),
		.DataOutRead		( DataOutRead		),
		.DataOutAddress		( DataOutAddress	),
		.DataOutColor		( DataOutColor		),
		.DataOutA			( DataOutA			),
		.DataOutB			( DataOutB			)
	);
endmodule
