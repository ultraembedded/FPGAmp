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

module aq_djpeg_idct(
    input               rst,
    input               clk,

    input               ProcessInit,

    input               DataInEnable,
    output              DataInRead,
    output [4:0]        DataInAddress,
    input [15:0]        DataInA,
    input [15:0]        DataInB,

    output              DataOutEnable,
    output [2:0]        DataOutPage,
    output [1:0]        DataOutCount,
    output [8:0]        Data0Out,
    output [8:0]        Data1Out
);
    wire                DctXEnable;
    wire [2:0]          DctXPage;
    wire [1:0]          DctXCount;
    wire [31:0]         DctXData0r;
    wire [31:0]         DctXData1r;

    aq_djpeg_idct_calc u_jpeg_idctx(
        .rst            ( rst           ),
        .clk            ( clk           ),

        .DataInEnable   ( DataInEnable  ),
        .DataInRead     ( DataInRead    ),
        .DataInAddress  ( DataInAddress ),
        .DataInA        ( DataInA       ),
        .DataInB        ( DataInB       ),

        .DataOutEnable  ( DctXEnable    ),
        .DataOutPage    ( DctXPage      ),
        .DataOutCount   ( DctXCount     ),
        .Data0Out       ( DctXData0r    ),
        .Data1Out       ( DctXData1r    )
    );

    wire            DctBEnable;
    wire            DctBRead;
    wire [4:0]      DctBAddress;
    wire [15:0]     DctBDataA;
    wire [15:0]     DctBDataB;
    wire            DctBIdle;

    aq_djpeg_idctb u_jpeg_idctb(
        .rst            ( rst               ),
        .clk            ( clk               ),

        .DataInit       ( ProcessInit       ),

        .DataInEnable   ( DctXEnable        ),
        .DataInPage     ( DctXPage          ),
        .DataInCount    ( DctXCount         ),
        .DataInIdle     ( DctBIdle          ),
        .DataInA        ( DctXData0r[26:11] ),
        .DataInB        ( DctXData1r[26:11] ),

        .DataOutEnable  ( DctBEnable        ),
        .DataOutRead    ( DctBRead          ),
        .DataOutAddress ( DctBAddress       ),
        .DataOutA       ( DctBDataA         ),
        .DataOutB       ( DctBDataB         )

    );

    wire [31:0] Data0OutW, Data1OutW;

    aq_djpeg_idct_calc u_jpeg_idcty(
        .rst            ( rst           ),
        .clk            ( clk           ),

        .DataInEnable   ( DctBEnable    ),
        .DataInRead     ( DctBRead      ),
        .DataInAddress  ( DctBAddress   ),
        .DataInA        ( DctBDataA     ),
        .DataInB        ( DctBDataB     ),

        .DataOutEnable  ( DataOutEnable ),
        .DataOutPage    ( DataOutPage   ),
        .DataOutCount   ( DataOutCount  ),
        .Data0Out       ( Data0OutW     ),
        .Data1Out       ( Data1OutW     )
    );

    assign Data0Out = Data0OutW[23:15];
    assign Data1Out = Data1OutW[23:15];

endmodule
