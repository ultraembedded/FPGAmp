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

module aq_djpeg_fsm(
	input			rst,
	input			clk,

	// From FIFO
	input			DataInEnable,
	input [31:0]	DataIn,
	input           DataInEnd,

	output			JpegDecodeIdle,	// Deocder Process Idle(1:Idle, 0:Run)

	//
	output [15:0]	OutWidth,
	output [15:0]	OutHeight,
	output [11:0]	OutBlockWidth,
	output [11:0]	OutBlockHeight,
	input			OutEnable,
	input			OutReady,
	input [15:0]	OutPixelX,
	input [15:0]	OutPixelY,
    
	//
	output			DqtEnable,
	output			DqtTable,
	output [5:0]	DqtCount,
	output [7:0]	DqtData,

	//
	output			DhtEnable,
	output [1:0]	DhtTable,
	output [7:0]	DhtCount,
	output [7:0]	DhtData,

	//
	output			HuffmanEnable,
	output [1:0]	HuffmanTable,
	output [3:0]	HuffmanCount,
	output [15:0]	HuffmanData,
	output [7:0]	HuffmanStart,

	//
	output reg		ImageEnable,
	output reg      FetchImageEnable,
	output reg [2:0]	JpegComp,
	output reg         JpegProgressive,
	output reg [15:0]  JpegRestart,
	output [1:0]    OutputSubSamplingW,
	output [1:0]    OutputSubSamplingH,

	//
	output			UseByte,
	output			UseWord
);

	//--------------------------------------------------------------------------
	// Read Maker from Jpeg Data
	//--------------------------------------------------------------------------
	// State Machine localparam
	localparam S_Idle				= 6'd0;
	localparam S_GetMarker			= 6'd1;
	localparam S_ImageData			= 6'd2;
	// APP Segment
	localparam S_APPLength			= 6'd3;
	localparam S_APPRead			= 6'd4;
	// DQT Segment
	localparam S_DQTLength			= 6'd5;
	localparam S_DQTTable			= 6'd6;
	localparam S_DQTRead			= 6'd7;
	// DHT Segmen
	localparam S_DHTLength			= 6'd8;
	localparam S_DHTTable			= 6'd9;
	localparam S_DHTMakeHm0			= 6'd10;
	localparam S_DHTMakeHm1			= 6'd11;
	localparam S_DHTMakeHm2			= 6'd12;
	localparam S_DHTReadTable		= 6'd13;
	// SOS Segment
	localparam S_SOSLength			= 6'd14;
	localparam S_SOSRead0			= 6'd15;
	localparam S_SOSRead1			= 6'd16;
	localparam S_SOSRead2			= 6'd17;
	localparam S_SOSRead3			= 6'd18;
	localparam S_SOSRead4			= 6'd19;
	// SOF Segment
	localparam S_SOFLength			= 6'd20;
	localparam S_SOFRead0			= 6'd21;
	localparam S_SOFReadY			= 6'd22;
	localparam S_SOFReadX			= 6'd23;
	localparam S_SOFReadComp		= 6'd24;
	localparam S_SOFReadCompColor	= 6'd25;
	localparam S_SOFReadCompColor0	= 6'd26;
	localparam S_SOFReadCompColor1	= 6'd27;
	localparam S_SOFReadCompColor2	= 6'd28;
	localparam S_SOFMakeBlock0		= 6'd29;
	localparam S_SOFMakeBlock1		= 6'd30;
	// EOI Segment
	localparam S_WaitEOI            = 6'd31;
	// DRI Segment
	localparam S_DRILength          = 6'd32;
    localparam S_DRIRead            = 6'd33;
    
	reg [5:0]		State;
	//wire			ImageEnable;
	reg [15:0]		ReadCount;
	reg [15:0]		TableReadCount;

	reg [15:0]		JpegWidth;
	reg [15:0]		JpegHeight;

	reg				ReadDqtTable;
	reg [1:0]		ReadDhtTable;

	reg [15:0]		HmShift;
	reg [15:0]		HmData;
	reg [7:0]		HmMax;
	reg [7:0]		HmCount;
	reg				HmEnable;

	reg [15:0]		JpegBlockWidth;
	reg [15:0]		JpegBlockHeight;
	
	reg [1:0]       ComponentNum;
	reg [1:0]       SubSamplingW;
	reg [1:0]       SubSamplingH;

	reg            LastDataEnable;

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			State				<= S_Idle;
			ReadCount			<= 16'd0;
			TableReadCount		<= 16'd0;
			JpegWidth			<= 16'd0;
			JpegHeight			<= 16'd0;
			ReadDqtTable		<= 1'b0;
			ReadDhtTable		<= 2'd0;
			HmShift			    <= 16'd0;
			HmData				<= 16'd0;
			HmMax				<= 8'd0;
			HmCount			    <= 8'd0;
			HmEnable			<= 1'b0;
			JpegBlockWidth	    <= 16'd0;
			JpegBlockHeight	    <= 16'd0;
			JpegComp			<= 3'd0;
			JpegProgressive     <= 1'b0;
			ComponentNum        <= 2'd0;
			SubSamplingW        <= 2'd0;
			SubSamplingH        <= 2'd0;
			ImageEnable		    <= 1'b0;
			FetchImageEnable	<= 1'b0;
			JpegRestart         <= 16'd0;
			LastDataEnable      <= 1'b0;
		end else begin
			case(State)
				S_Idle: begin
				    LastDataEnable <= DataInEnable;
					if(DataInEnable && LastDataEnable) begin
						State	<= S_GetMarker;
					end
				end

				// Get Marker(with Header)
				S_GetMarker: begin
					if(DataInEnable == 1'b1) begin
						case(DataIn[31:16])
							16'hFFD8: begin		// SOI Segment
								State <= S_GetMarker;
							end
							16'hFFE0: begin		// APP0 Segment
								State <= S_APPLength;
							end
							16'hFFDB: begin		// DQT Segment
								State <= S_DQTLength;
							end
							16'hFFC4: begin		// DHT Segment
								State <= S_DHTLength;
							end
							16'hFFC0: begin		// SOF0 Segment
								State <= S_SOFLength;
								JpegProgressive <= 1'b0;
							end
							16'hFFC2: begin		// SOF2 Segment
								State <= S_SOFLength;
								JpegProgressive <= 1'b1;
							end
							16'hFFDA: begin		// SOS Segment
								State <= S_SOSLength;
							end
							16'hFFDD: begin		// DRI Segment
								State <= S_DRILength;
							end
							//16'hFFDx: begin		// RSTn Segment
							//		State <= S_RST;
							//end
							//16'hFFD9: begin		// EOI Segment
							//		State <= S_EOI;
							//end
							default: begin
								State <= S_APPLength;
							end
						endcase
					end
				end

				// APP Segment
				S_APPLength: begin
					if(DataInEnable == 1'b1) begin
						ReadCount	<= DataIn[31:16] -16'd2;
						State		<= S_APPRead;
					end
				end
				S_APPRead: begin
					if(DataInEnable == 1'b1) begin
						if(ReadCount == 16'd1) begin
							State		<= S_GetMarker;
						end else begin
							ReadCount	<= ReadCount -16'd1;
						end
					end
				end

				// DQT Segment
				S_DQTLength: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_DQTTable;
						ReadCount	<= DataIn[31:16] -16'd2;
						TableReadCount <= DataIn[31:16] - 16'd2;
					end
				end
				S_DQTTable: begin
					if(DataInEnable == 1'b1) begin
						State			<= S_DQTRead;
						ReadDqtTable	<= DataIn[24];
						ReadCount		<= 16'd0;
						TableReadCount  <= TableReadCount - 1'd1;
					end
				end
				S_DQTRead: begin
					if(DataInEnable == 1'b1) begin
						if(ReadCount ==63) begin
							if(TableReadCount == 1) begin
								State		<= S_GetMarker;
							end else begin
								State		<= S_DQTTable;
							end
						end
						ReadCount		<= ReadCount +16'd1;
						TableReadCount  <= TableReadCount - 1'd1;
					end
				end

				// DHT Segment
				S_DHTLength: begin
					if(DataInEnable == 1'b1) begin
						State			<= S_DHTTable;
						ReadCount		<= DataIn[31:16];
						TableReadCount  <= DataIn[31:16] - 16'd2;
					end
				end
				S_DHTTable: begin
					if(DataInEnable == 1'b1) begin
						State <= S_DHTMakeHm0;
						case(DataIn[31:24])
							8'h00: ReadDhtTable <= 2'b00;
							8'h10: ReadDhtTable <= 2'b01;
							8'h01: ReadDhtTable <= 2'b10;
							8'h11: ReadDhtTable <= 2'b11;
						endcase
						TableReadCount <= TableReadCount - 1'd1;
					end
					HmShift		    <= 16'h8000;
					HmData			<= 16'h0000;
					HmMax			<= 8'h00;
					ReadCount		<= 16'd0;
				end
				S_DHTMakeHm0: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_DHTMakeHm1;
						HmCount	<= DataIn[31:24];
					    TableReadCount <= TableReadCount - 1'd1;
					end
					HmEnable		<= 1'b0;
				end
				S_DHTMakeHm1: begin
					State	<= S_DHTMakeHm2;
					HmMax	<= HmMax + HmCount;
				end
				S_DHTMakeHm2: begin
					if(HmCount != 0) begin
						HmData	<= HmData + HmShift;
						HmCount <= HmCount -8'd1;
					end else begin
						if(ReadCount == 15) begin
							State		<= S_DHTReadTable;
							HmCount	<= 8'h00;
						end else begin
							HmEnable	<= 1'b1;
							State		<= S_DHTMakeHm0;
							ReadCount	<= ReadCount +16'd1;
						end
						HmShift <= HmShift >> 1;
					end
				end
				S_DHTReadTable: begin
					HmEnable	<= 1'b0;
					if(DataInEnable == 1'b1) begin
						if(HmMax == HmCount +1) begin
							if(TableReadCount == 1) begin
								State	<= S_GetMarker;
							end else begin
								State	<= S_DHTTable;
							end
						end
						HmCount	<= HmCount +8'd1;
						TableReadCount <= TableReadCount - 1'd1;
					end
				end

				// SOS Segment
				S_SOSLength: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_SOSRead0;
						ReadCount	<= DataIn[31:16];
					end
				end
				S_SOSRead0: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_SOSRead1;
						ReadCount	<= {8'h00,DataIn[31:24]};
					end
				end
				S_SOSRead1: begin
					if(DataInEnable == 1'b1) begin
						if(ReadCount == 1) begin
							State		<= S_SOSRead2;
						end else begin
							ReadCount	<= ReadCount -16'd1;
						end
					end
				end
				S_SOSRead2: begin
					if(DataInEnable == 1'b1) begin
						State	<= S_SOSRead3;
					end
				end
				S_SOSRead3: begin
					if(DataInEnable == 1'b1) begin
						State	<= S_SOSRead4;
					end
				end
				S_SOSRead4: begin
					if(DataInEnable == 1'b1) begin
						State			<= S_ImageData;
						ImageEnable	<= 1'b1;
						FetchImageEnable <= 1'b1;
					end
				end

				// SOF0 Segment
				S_SOFLength: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_SOFRead0;
						ReadCount	<= DataIn[31:16];
					end
				end
				S_SOFRead0: begin
					if(DataInEnable == 1'b1) begin
						State	<= S_SOFReadY;
					end
				end
				S_SOFReadY: begin
					if(DataInEnable == 1'b1) begin
						State				<= S_SOFReadX;
						JpegHeight			<= DataIn[31:16];
						JpegBlockHeight	<= DataIn[31:16];
					end
				end
				S_SOFReadX: begin
					if(DataInEnable == 1'b1) begin
						State				<= S_SOFReadComp;
						JpegWidth			<= DataIn[31:16];
						JpegBlockWidth	<= DataIn[31:16];
						ReadCount			<= 16'd0;
					end
				end
				S_SOFReadComp: begin
					// ã‚³ãƒ³ãƒãƒ¼ãƒãƒ³ãƒˆæ•°
					// 1:ã‚°ãƒ¬ãƒ¼ã‚¹ã‚±ãƒ¼ãƒ«
					// 3:YCbCr or YIQ
					// 4:CMYK
					if(DataInEnable == 1'b1) begin
						State			<= S_SOFReadCompColor;
						JpegComp		<= DataIn[26:24];
						if(ReadCount == 9) begin
						end else begin
							ReadCount	<= ReadCount +16'd1;
						end
					end
				end
				S_SOFReadCompColor: begin
					State			<= S_SOFReadCompColor0;
					ReadCount		<= {13'd0, JpegComp[2:0]} - 16'd1;
				end
				S_SOFReadCompColor0: begin
					if(DataInEnable == 1'b1) begin
						State			<= S_SOFReadCompColor1;
						// Tracking component ID
						ComponentNum    <= DataIn[25:24];
					end
				end
				S_SOFReadCompColor1: begin
					if(DataInEnable == 1'b1) begin
						State			<= S_SOFReadCompColor2;
						if (ComponentNum == 2'd1) begin
						  SubSamplingW  <= DataIn[29:28];
						  SubSamplingH  <= DataIn[25:24];
						end
					end
				end
				S_SOFReadCompColor2: begin
					if(DataInEnable == 1'b1) begin
						if(ReadCount == 0) begin
							State			<= S_SOFMakeBlock0;
						end else begin
							ReadCount		<= ReadCount -16'd1;
							State			<= S_SOFReadCompColor0;
						end
					end
				end
				S_SOFMakeBlock0:begin
					State				<= S_SOFMakeBlock1;
					JpegBlockWidth  <= JpegBlockWidth  + ((SubSamplingW == 2'd2) ? 16'd15 : 16'd7);
					JpegBlockHeight	<= JpegBlockHeight + ((SubSamplingH == 2'd2) ? 16'd15 : 16'd7);
				end
				S_SOFMakeBlock1:begin
					State				<= S_GetMarker;
					JpegBlockWidth	<= JpegBlockWidth	>> ((SubSamplingW == 2'd2) ? 4 : 3);
					JpegBlockHeight	<= JpegBlockHeight  >> ((SubSamplingH == 2'd2) ? 4 : 3);
				end
                
                // DRI Segment
                S_DRILength: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_DRIRead;
					end
				end
				S_DRIRead: begin
					if(DataInEnable == 1'b1) begin
						State		<= S_GetMarker;
						JpegRestart	<= DataIn[31:16];
					end
	            end
				// Image Process
				S_ImageData: begin
					if(OutEnable & OutReady & (JpegWidth == (OutPixelX +1)) & (JpegHeight == (OutPixelY +1))) begin
						ImageEnable	<= 1'b0;
						if (DataInEnd) begin
							State           <= S_Idle;
							LastDataEnable  <= 1'b0;
						    FetchImageEnable <= 1'b0;
						end else
							State			<= S_WaitEOI;
					end
				end

				S_WaitEOI: begin
					if(DataInEnd) begin
						State           <= S_Idle;
					    LastDataEnable  <= 1'b0;
						FetchImageEnable <= 1'b0;
					end
				end
			endcase
		end
	end

	assign UseByte = (DataInEnable == 1'b1) & ((State == S_APPRead) |
												(State == S_DQTRead) | (State == S_DQTTable) |
												(State == S_DHTTable) | (State == S_DHTMakeHm0) | (State == S_DHTReadTable) |
												(State == S_SOSRead0) | (State == S_SOSRead2) | (State == S_SOSRead3) | (State == S_SOSRead4) |
												(State == S_SOFRead0) | (State == S_SOFReadComp) |
												(State == S_SOFReadComp) | (State == S_SOFReadCompColor0) | (State == S_SOFReadCompColor1) | (State == S_SOFReadCompColor2) |
												(State == S_WaitEOI)
												);
	assign UseWord = (DataInEnable == 1'b1) & ((State == S_GetMarker) |
												(State == S_APPLength) |
												(State == S_DQTLength) |
												(State == S_DHTLength) |
												(State == S_SOSLength) | (State == S_SOSRead1) |
												(State == S_SOFLength) | (State == S_SOFReadX) | (State == S_SOFReadY) |
												(State == S_DRILength) | (State == S_DRIRead)
												);

	assign JpegDecodeIdle	= (State == S_Idle);
	//assign ImageEnable		= (State == S_ImageData);

	assign OutWidth		= JpegWidth;
	assign OutHeight		= JpegHeight;
	assign OutBlockWidth	= JpegBlockWidth[11:0];
	assign OutBlockHeight   = JpegBlockHeight[11:0];
	assign OutputSubSamplingW = SubSamplingW;
	assign OutputSubSamplingH = SubSamplingH;

	assign DqtEnable		= (State == S_DQTRead);
	assign DqtTable		= ReadDqtTable;
	assign DqtCount		= ReadCount[5:0];
	assign DqtData		= DataIn[31:24];

	assign DhtEnable		= (State == S_DHTReadTable);
	assign DhtTable		= ReadDhtTable;
	assign DhtCount		= HmCount;
	assign DhtData		= DataIn[31:24];

	assign HuffmanEnable	= HmEnable;
	assign HuffmanTable	= ReadDhtTable;
	assign HuffmanCount	= ReadCount[3:0];
	assign HuffmanData	= HmData;
	assign HuffmanStart	= HmMax;

endmodule
