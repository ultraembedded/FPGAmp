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

module aq_djpeg_idct_calc(
    input           clk,
    input           rst,

    input           DataInEnable,
    output          DataInRead,
    output [4:0]    DataInAddress,
    input [15:0]    DataInA,
    input [15:0]    DataInB,

    output          DataOutEnable,
    output [2:0]    DataOutPage,
    output [1:0]    DataOutCount,
    output [31:0]   Data0Out,
    output [31:0]   Data1Out
);
    //-------------------------------------------------------------------------
    // Phase1
    //-------------------------------------------------------------------------
    reg           Phase1Enable;
    reg [2:0]     Phase1Page;
    reg [2:0]     Phase1Count;
    reg           Phase1EnableD;
    reg [2:0]     Phase1PageD;
    reg [2:0]     Phase1CountD;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase1Enable  <= 1'b0;
            Phase1Page    <= 3'd0;
            Phase1Count   <= 3'd0;
            Phase1EnableD <= 1'b0;
            Phase1PageD   <= 3'd0;
            Phase1CountD  <= 3'd0;
        end else begin
            if(Phase1Enable == 1'b0) begin
                if(DataInEnable == 1'b1) begin
                    Phase1Enable <= 1'b1;
                    Phase1Page   <= 3'd0;
                    Phase1Count  <= 3'd0;
                end
            end else begin
                if(Phase1Count == 3'd6) begin
                    if(Phase1Page == 3'd7) begin
                        Phase1Enable <= 1'b0;
                        Phase1Page   <= 3'd0;
                    end else begin
                        Phase1Page   <= Phase1Page + 3'd1;
                    end
                    Phase1Count <= 3'd0;
                end else begin
                    Phase1Count <= Phase1Count + 3'd1;
                end
            end
            Phase1EnableD <= Phase1Enable;
            Phase1PageD   <= Phase1Page;
            Phase1CountD  <= Phase1Count;
        end
    end

    assign DataInRead       = Phase1Enable & (Phase1Count < 3'd4);
    assign DataInAddress    = {Phase1Page, Phase1Count[1:0]};

    wire signed [15:0] Phase1R0w;
    wire signed [15:0] Phase1R1w;
    wire signed [15:0] Phase1C0w;
    wire signed [15:0] Phase1C1w;
    wire signed [15:0] Phase1C2w;
    wire signed [15:0] Phase1C3w;

    assign Phase1R0w = DataInA;
    assign Phase1R1w = DataInB;

    function [15:0] Phase1C0wSel;
        input [2:0] Phase1Count;
        begin
            case(Phase1Count)
                3'd0: begin
                    Phase1C0wSel = 16'd2896; // C4_16
                end
                3'd1: begin
                    Phase1C0wSel = 16'd3784; // C2_16
                end
                3'd2: begin
                    Phase1C0wSel = 16'd4017; // C1_16
                end
                3'd3: begin
                    Phase1C0wSel = 16'd2276; // C5_16
                end
                default: begin
                    Phase1C0wSel = 16'd0;
                end
            endcase
        end
    endfunction

    function [15:0] Phase1C1wSel;
        input [2:0]     Phase1Count;
        begin
            case(Phase1Count)
                3'd0: begin
                    Phase1C1wSel = 16'd2896; // C4_16
                end
                3'd1: begin
                    Phase1C1wSel = 16'd1567; // C6_16
                end
                3'd2: begin
                    Phase1C1wSel = 16'd799;  // C7_16
                end
                3'd3: begin
                    Phase1C1wSel = 16'd3406; // C3_16
                end
                default: begin
                    Phase1C1wSel = 16'd0;
                end
            endcase
        end
    endfunction

    function [15:0] Phase1C2wSel;
        input [2:0]     Phase1Count;
        begin
            case(Phase1Count)
                3'd0: begin
                    Phase1C2wSel = 16'd2896; // C4_16
                end
                3'd1: begin
                    Phase1C2wSel = 16'd1567; // C6_16
                end
                3'd2: begin
                    Phase1C2wSel = 16'd799;  // C7_16
                end
                3'd3: begin
                    Phase1C2wSel = 16'd3406; // C3_16
                end
                default: begin
                    Phase1C2wSel = 16'd0;
                end
            endcase
        end
    endfunction

    function [15:0] Phase1C3wSel;
        input [2:0]     Phase1Count;
        begin
            case(Phase1Count)
                3'd0: begin
                    Phase1C3wSel = 16'd2896; // C4_16
                end
                3'd1: begin
                    Phase1C3wSel = 16'd3784; // C2_16
                end
                3'd2: begin
                    Phase1C3wSel = 16'd4017; // C1_16
                end
                3'd3: begin
                    Phase1C3wSel = 16'd2276; // C5_16
                end
                default: begin
                    Phase1C3wSel = 16'd0;
                end
            endcase
        end
    endfunction

    assign Phase1C0w = Phase1C0wSel(Phase1CountD);
    assign Phase1C1w = Phase1C1wSel(Phase1CountD);
    assign Phase1C2w = Phase1C2wSel(Phase1CountD);
    assign Phase1C3w = Phase1C3wSel(Phase1CountD);

    reg signed [31:0] Phase1R0r;
    reg signed [31:0] Phase1R1r;
    reg signed [31:0] Phase1R2r;
    reg signed [31:0] Phase1R3r;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase1R0r <= 0;
            Phase1R1r <= 0;
            Phase1R2r <= 0;
            Phase1R3r <= 0;
        end else begin
            Phase1R0r <= Phase1R0w * Phase1C0w;
            Phase1R1r <= Phase1R1w * Phase1C1w;
            Phase1R2r <= Phase1R0w * Phase1C2w;
            Phase1R3r <= Phase1R1w * Phase1C3w;
        end
    end

/*
    always @(posedge clk) begin
        if((Phase1EnableD == 1'b1) && (Phase1CountD < 3'd4)) begin
            $display("(%d,%d) = %8x, %8x",Phase1PageD ,Phase1CountD,
                                                   Phase1R0w, Phase1R1w);
        end
        //if((Phase1EnableD == 1'b1) && (Phase1CountD < 3'd4)) begin
        //    $display("(%d,%d) = %8x, %8x, %8x, %8x",Phase1PageD ,Phase1CountD,
        //                                           Phase1R0r, Phase1R1r, Phase1R2r, Phase1R3r);
        //end
    end
*/
    //-------------------------------------------------------------------------
    // Phase2
    //  R0: s0,s3,s7,s6
    //  R1: s1,s2,s4,s5
    //-------------------------------------------------------------------------
    reg             Phase2Enable;
    reg [2:0]       Phase2Page;
    reg [2:0]       Phase2Count;
    reg             Phase2EnableD;
    reg [2:0]       Phase2PageD;
    reg [2:0]       Phase2CountD;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase2Enable  <= 1'b0;
            Phase2Page    <= 3'd0;
            Phase2Count   <= 3'd0;
            Phase2EnableD <= 1'b0;
            Phase2PageD   <= 3'd0;
            Phase2CountD  <= 3'd0;
        end else begin
            Phase2Enable  <= Phase1EnableD;
            Phase2Page    <= Phase1PageD;
            Phase2Count   <= Phase1CountD;
            Phase2EnableD <= Phase2Enable;
            Phase2PageD   <= Phase2Page;
            Phase2CountD  <= Phase2Count;
        end
    end

    wire signed [31:0] Phase2A0w;
    wire signed [31:0] Phase2A1w;

    assign             Phase2A0w = Phase1R0r + Phase1R1r;
    assign             Phase2A1w = Phase1R2r - Phase1R3r;

    reg signed [31:0]  Phase2Reg [0:7];

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase2Reg[0] <= 0;
            Phase2Reg[1] <= 0;
            Phase2Reg[2] <= 0;
            Phase2Reg[3] <= 0;
            Phase2Reg[4] <= 0;
            Phase2Reg[5] <= 0;
            Phase2Reg[6] <= 0;
            Phase2Reg[7] <= 0;
        end else begin
            case(Phase2Count)
              3'd0: begin
                  Phase2Reg[0] <= Phase2A0w;
                  Phase2Reg[1] <= Phase2A1w;
              end
              3'd1: begin
                  Phase2Reg[3] <= Phase2A0w;
                  Phase2Reg[2] <= Phase2A1w;
              end
              3'd2: begin
                  Phase2Reg[7] <= Phase2A0w;
                  Phase2Reg[4] <= Phase2A1w;
              end
              3'd3: begin
                  Phase2Reg[6] <= Phase2A0w;
                  Phase2Reg[5] <= Phase2A1w;
              end
            endcase
        end
    end

    //-------------------------------------------------------------------------
    // Phase3
    //  R0: t0,t1,t4,t7
    //  R1: t3,t2,t5,t6
    //-------------------------------------------------------------------------
    reg           Phase3Enable;
    reg [2:0]     Phase3Page;
    reg [2:0]     Phase3Count;
    reg           Phase3EnableD;
    reg [2:0]     Phase3PageD;
    reg [2:0]     Phase3CountD;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase3Enable  <= 1'b0;
            Phase3Page    <= 3'd0;
            Phase3Count   <= 3'd0;
            Phase3EnableD <= 1'b0;
            Phase3PageD   <= 3'd0;
            Phase3CountD  <= 3'd0;
        end else begin
            Phase3Enable  <= Phase2EnableD;
            Phase3Page    <= Phase2PageD;
            Phase3Count   <= Phase2CountD;
            Phase3EnableD <= Phase3Enable;
            Phase3PageD   <= Phase3Page;
            Phase3CountD  <= Phase3Count;
        end
    end

    wire signed [31:0] Phase3R0w;
    wire signed [31:0] Phase3R1w;

    assign             Phase3R0w = (Phase3Count == 3'd0)?Phase2Reg[0]:
                                   (Phase3Count == 3'd1)?Phase2Reg[1]:
                                   (Phase3Count == 3'd2)?Phase2Reg[4]:
                                   (Phase3Count == 3'd3)?Phase2Reg[7]:
                                   32'd0;
    assign             Phase3R1w = (Phase3Count == 3'd0)?Phase2Reg[3]:
                                   (Phase3Count == 3'd1)?Phase2Reg[2]:
                                   (Phase3Count == 3'd2)?Phase2Reg[5]:
                                   (Phase3Count == 3'd3)?Phase2Reg[6]:
                                   32'd0;



    wire signed [31:0] Phase3A0w;
    wire signed [31:0] Phase3A1w;
    assign             Phase3A0w = Phase3R0w + Phase3R1w;
    assign             Phase3A1w = Phase3R0w - Phase3R1w;

    reg signed [31:0]  Phase3Reg [0:7];

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase3Reg[0] <= 0;
            Phase3Reg[1] <= 0;
            Phase3Reg[2] <= 0;
            Phase3Reg[3] <= 0;
            Phase3Reg[4] <= 0;
            Phase3Reg[5] <= 0;
            Phase3Reg[6] <= 0;
            Phase3Reg[7] <= 0;
        end else begin
            case(Phase3Count)
              3'd0: begin
                  Phase3Reg[0] <= Phase3A0w;
                  Phase3Reg[3] <= Phase3A1w;
              end
              3'd1: begin
                  Phase3Reg[1] <= Phase3A0w;
                  Phase3Reg[2] <= Phase3A1w;
              end
              3'd2: begin
                  Phase3Reg[4] <= Phase3A0w;
                  Phase3Reg[5] <= Phase3A1w;
              end
              3'd3: begin
                  Phase3Reg[7] <= Phase3A0w;
                  Phase3Reg[6] <= Phase3A1w;
              end
            endcase
        end
    end

    //-------------------------------------------------------------------------
    // Phase4
    //  R0: s6
    //  R1: s5
    //-------------------------------------------------------------------------
    reg           Phase4Enable;
    reg [2:0]     Phase4Page;
    reg [2:0]     Phase4Count;
    reg           Phase4EnableD;
    reg [2:0]     Phase4PageD;
    reg [2:0]     Phase4CountD;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase4Enable  <= 1'b0;
            Phase4Page    <= 3'd0;
            Phase4Count   <= 3'd0;
            Phase4EnableD <= 1'b0;
            Phase4PageD   <= 3'd0;
            Phase4CountD  <= 3'd0;
        end else begin
            Phase4Enable  <= Phase3EnableD;
            Phase4Page    <= Phase3PageD;
            Phase4Count   <= Phase3CountD;
            Phase4EnableD <= Phase4Enable;
            Phase4PageD   <= Phase4Page;
            Phase4CountD  <= Phase4Count;
        end
    end

    reg signed [42:0] Phase4R0r;
    reg signed [42:0] Phase4R1r;

    wire signed [8:0] C_181;
    assign            C_181 = 9'h0B5;

    wire signed [32:0] Phase4R0w;
    wire signed [32:0] Phase4R1w;

    assign Phase4R0w = Phase3Reg[6] + Phase3Reg[5];
    assign Phase4R1w = Phase3Reg[6] - Phase3Reg[5];

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase4R0r <= 0;
            Phase4R1r <= 0;
        end else begin
            case(Phase4Count)
              3'd2: begin
                  //Phase4R0r <= (Phase3Reg[6] + Phase3Reg[5]) * C_181;
                  //Phase4R1r <= (Phase3Reg[6] - Phase3Reg[5]) * C_181;
                  Phase4R0r <= Phase4R0w * C_181;
                  Phase4R1r <= Phase4R1w * C_181;
              end
            endcase
        end
    end

    //-------------------------------------------------------------------------
    // Phase5
    //  R0: B0,B1,B2,B3
    //  R1: B7,B6,B5,B4
    //-------------------------------------------------------------------------
    reg           Phase5Enable;
    reg [2:0]     Phase5Page;
    reg [2:0]     Phase5Count;
    reg           Phase5EnableD;
    reg [2:0]     Phase5PageD;
    reg [2:0]     Phase5CountD;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase5Enable  <= 1'b0;
            Phase5Page    <= 3'd0;
            Phase5Count   <= 3'd0;
            Phase5EnableD <= 1'b0;
            Phase5PageD   <= 3'd0;
            Phase5CountD  <= 3'd0;
        end else begin
            Phase5Enable  <= Phase4EnableD;
            Phase5Page    <= Phase4PageD;
            Phase5Count   <= Phase4CountD;
            Phase5EnableD <= Phase5Enable;
            Phase5PageD   <= Phase5Page;
            Phase5CountD  <= Phase5Count;
        end
    end

    wire signed [31:0] Phase5R0w;
    wire signed [31:0] Phase5R1w;
    assign             Phase5R0w = (Phase5Count == 3'd0)?Phase3Reg[0]:
                                   (Phase5Count == 3'd1)?Phase3Reg[1]:
                                   (Phase5Count == 3'd2)?Phase3Reg[2]:
                                   (Phase5Count == 3'd3)?Phase3Reg[3]:
                                   32'd0;
    assign             Phase5R1w = (Phase5Count == 3'd0)?Phase3Reg[7]:
                                   (Phase5Count == 3'd1)?Phase4R0r >> 8:
                                   (Phase5Count == 3'd2)?Phase4R1r >> 8:
                                   (Phase5Count == 3'd3)?Phase3Reg[4]:
                                   32'd0;

    reg signed [31:0]  Phase5R0r;
    reg signed [31:0]  Phase5R1r;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            Phase5R0r <= 0;
            Phase5R1r <= 0;
        end else begin
            Phase5R0r <= Phase5R0w + Phase5R1w;
            Phase5R1r <= Phase5R0w - Phase5R1w;
        end
    end

    assign DataOutEnable = Phase5EnableD == 1'b1 & Phase5CountD[2] == 1'b0;
    assign DataOutPage   = Phase5PageD;
    assign DataOutCount  = Phase5CountD[1:0];

    assign Data0Out = Phase5R0r;
    assign Data1Out = Phase5R1r;

endmodule
