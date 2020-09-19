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

module aq_djpeg(
	input			rst,
	input			clk,

	// From FIFO
	input [31:0]	DataIn,
	input			DataInEnable,
	output			DataInRead,
	output 			DataInReq,

	output			JpegDecodeIdle,	// Decoder Process Idle(1:Idle, 0:Run)
	output          JpegProgressive,

	input           OutReady,
	output			OutEnable,
	output [15:0]	OutWidth,
	output [15:0]	OutHeight,
	output [15:0]	OutPixelX,
	output [15:0]	OutPixelY,
	output [7:0]	OutR,
	output [7:0]	OutG,
	output [7:0]	OutB
);
	wire [31:0]		JpegData;
	wire			JpegDataEnable;
	wire            JpegDataEnd;

	wire			UseBit;
	wire [6:0]		UseWidth;
	wire			UseByte;
	wire			UseWord;
	wire           AlignByte;

	wire			FetchImageEnable;
	wire			ImageEnable;
	wire			EnableFF00;
	wire			DataInFull;

	//reg			 ProcessIdle;

	wire			JpegDataEnableW;

	assign JpegDataEnable = (!DataInFull)?JpegDataEnableW:1'b0;

	//--------------------------------------------------------------------------
	// Read JPEG Data from FIFO
	//--------------------------------------------------------------------------
	aq_djpeg_regdata u_jpeg_regdata(
		.rst				( rst				),
		.clk				( clk				),

		// Read Data
		.DataIn			( DataIn			),
		.DataInEnable		( DataInEnable	),
		.DataInRead		( DataInRead		),
		.DataInReq		( DataInReq	),

		// DataOut
		.DataOut			( JpegData			),
		.DataOutEnable	( JpegDataEnableW	),
		.DataOutEnd         ( JpegDataEnd       ),

		//
		.ImageEnable		( FetchImageEnable  ),
		.ProcessIdle		( JpegDecodeIdle	),

		// UseData
		.UseBit			( UseBit			),
		.UseWidth			( UseWidth			),
		.UseByte			( UseByte			),
		.UseWord			( UseWord			),
		.AlignByte          ( AlignByte         )
		);

	//--------------------------------------------------------------------------
	// Read Maker from Jpeg Data
	//--------------------------------------------------------------------------
	wire			DqtEnable;
	wire			DqtTable;
	wire [5:0]		DqtCount;
	wire [7:0]		DqtData;

	wire			DhtEnable;
	wire [1:0]		DhtTable;
	wire [7:0]		DhtCount;
	wire [7:0]		DhtData;

	//
	wire			HuffmanEnable;
	wire [1:0]		HuffmanTable;
	wire [3:0]		HuffmanCount;
	wire [15:0]		HuffmanData;
	wire [7:0]		HuffmanStart;

	wire [11:0]		JpegBlockWidth;
	wire [11:0]     JpegBlockHeight;
	wire [2:0]		JpegComp;
	wire [1:0]      SubSamplingW;
	wire [1:0]      SubSamplingH;
	wire [15:0]     JpegRestart;


	aq_djpeg_fsm u_jpeg_fsm(
		.rst				( rst				),
		.clk				( clk				),

		// From FIFO
		.DataInEnable		( JpegDataEnable	),
		.DataIn			( JpegData			),
		.DataInEnd          ( JpegDataEnd       ),

		.JpegDecodeIdle	( JpegDecodeIdle	),

		.OutWidth			( OutWidth			),
		.OutHeight			( OutHeight		),
		.OutBlockWidth	( JpegBlockWidth	),
		.OutBlockHeight	( JpegBlockHeight	),
		.OutEnable			( OutEnable		),
		.OutReady			( OutReady		),
		.OutPixelX			( OutPixelX		),
		.OutPixelY			( OutPixelY		),

		//
		.DqtEnable			( DqtEnable		),
		.DqtTable			( DqtTable			),
		.DqtCount			( DqtCount			),
		.DqtData			( DqtData			),

		//
		.DhtEnable			( DhtEnable		),
		.DhtTable			( DhtTable			),
		.DhtCount			( DhtCount			),
		.DhtData			( DhtData			),

		//
		.HuffmanEnable	( HuffmanEnable	),
		.HuffmanTable		( HuffmanTable	),
		.HuffmanCount		( HuffmanCount	),
		.HuffmanData		( HuffmanData		),
		.HuffmanStart		( HuffmanStart	),

		//
		.ImageEnable		( ImageEnable		),
		.FetchImageEnable	( FetchImageEnable	),
		.JpegComp			( JpegComp			),
		.JpegProgressive    ( JpegProgressive   ),
		.OutputSubSamplingW ( SubSamplingW      ),
		.OutputSubSamplingH ( SubSamplingH      ),
		.JpegRestart        ( JpegRestart       ),

		//
		.UseByte			( UseByte			),
		.UseWord			( UseWord			)
		);


	wire			HmDecEnable;
	wire [2:0]		HmDecColor;
	wire			HmRead;
	wire [4:0]		HmAddress;

	wire            HmNextBlock;

	wire [15:0]		HmDataA, HmDataB;

	aq_djpeg_huffman u_jpeg_huffman(
		.rst					( rst				),
		.clk					( clk				),

		.ProcessInit			( JpegDecodeIdle	),

		// DQT Table
		.DqtInEnable			( DqtEnable		),
		.DqtInColor			( DqtTable			),
		.DqtInCount			( DqtCount[5:0]	),
		.DqtInData				( DqtData			),

		// DHT Table
		.DhtInEnable			( DhtEnable		),
		.DhtInColor			( DhtTable			),
		.DhtInCount			( DhtCount			),
		.DhtInData				( DhtData			),

		// Huffman Table
		.HuffmanTableEnable	( HuffmanEnable	),
		.HuffmanTableColor	( HuffmanTable	),
		.HuffmanTableCount	( HuffmanCount	),
		.HuffmanTableCode		( HuffmanData		),
		.HuffmanTableStart	( HuffmanStart	),

		// Huffman Decode
		.DataInRun				( ImageEnable		),
		.DataInEnable			( JpegDataEnable	),
		.DataIn				( JpegData			),
		.JpegComp				( JpegComp			),
		.JpegProgressive        ( JpegProgressive   ),
		.JpegBlockWidth         ( JpegBlockWidth    ),
		.JpegBlockHeight        ( JpegBlockHeight   ),
		.SubSamplingW           ( SubSamplingW      ),
		.SubSamplingH           ( SubSamplingH      ),
		.JpegRestart            ( JpegRestart       ),

		// Output decode data
		.DecodeNextBlock        ( HmNextBlock       ),
		.DecodeUseBit			( UseBit			),
		.DecodeUseWidth		( UseWidth			),
		.DecodeAlignByte        ( AlignByte         ),

		// Data Out
		.DataOutEnable		( HmDecEnable		),
		.DataOutRead			( HmRead			),
		.DataOutAddress		( HmAddress		),
		.DataOutColor			( HmDecColor		),
		.DataOutA				( HmDataA			),
		.DataOutB				( HmDataB			)
	);

	wire			DctEnable;
	wire [2:0]		DctColor;
	wire [2:0]		DctPage;
	wire [1:0]		DctCount;
	wire [8:0]		Dct0Data, Dct1Data;

	wire [15:0]		DctWidth, DctHeight;
	wire [11:0]		DctBlockX, DctBlockY;

	wire			YCbCrIdle;

	aq_djpeg_idct u_jpeg_idct(
		.rst				( rst				),
		.clk				( clk				),

		.ProcessInit		( JpegDecodeIdle	),

		.DataInEnable		( HmDecEnable		),
		.DataInRead		( HmRead			),
		.DataInAddress	( HmAddress		),
		.DataInA			( HmDataA			),
		.DataInB			( HmDataB			),

		.DataOutEnable	( DctEnable		),
		.DataOutPage		( DctPage			),
		.DataOutCount		( DctCount			),
		.Data0Out			( Dct0Data			),
		.Data1Out			( Dct1Data			)
		);

	wire			ColorEnable;
	wire [15:0]		ColorPixelX, ColorPixelY;
	wire [7:0]		ColorR, ColorG, ColorB;
	aq_djpeg_ycbcr u_jpeg_ycbcr(
		.rst				( rst				),
		.clk				( clk				),

		.ProcessInit		( JpegDecodeIdle	),
		.JpegComp			( JpegComp			),
		.SubSamplingW       ( SubSamplingW      ),
		.SubSamplingH       ( SubSamplingH      ),

		.DecoderNextBlock   ( HmNextBlock   ),
		.DataInEnable		( DctEnable		),
		.DataInPage		( DctPage			),
		.DataInCount		( DctCount			),
		.DataInIdle		( YCbCrIdle		),
		.Data0In			( Dct0Data			),
		.Data1In			( Dct1Data			),
		.DataInBlockWidth	( JpegBlockWidth	),
		.DataInFull		( DataInFull		),

		.OutReady			( OutReady			),
		.OutEnable			( ColorEnable		),
		.OutPixelX			( ColorPixelX		),
		.OutPixelY			( ColorPixelY		),
		.OutR				( ColorR			),
		.OutG				( ColorG			),
		.OutB				( ColorB			)
	);
	// OutData
//	assign OutEnable	= (ImageEnable)?ColorEnable:1'b0;
	assign OutEnable	= (ImageEnable && (ColorPixelX < OutWidth) && (ColorPixelY < OutHeight))?ColorEnable:1'b0;
	assign OutPixelX	= (ImageEnable)?ColorPixelX:16'd0;
	assign OutPixelY	= (ImageEnable)?ColorPixelY:16'd0;
	assign OutR		= (ImageEnable)?ColorR:8'd0;
	assign OutG		= (ImageEnable)?ColorG:8'd0;
	assign OutB		= (ImageEnable)?ColorB:8'd0;

endmodule
