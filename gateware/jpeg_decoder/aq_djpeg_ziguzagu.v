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

module aq_djpeg_ziguzagu(
    input           clk,
    input           rst,

    input           DataInit,
    input           HuffmanEndEnable,

    input           DataInEnable,
    input [5:0]     DataInAddress,
    input [2:0]     DataInColor,
    output          DataInIdle,
    input [15:0]    DataIn,

    output          DataOutEnable,
    input           DataOutRead,
    input [4:0]     DataOutAddress,
    output [2:0]    DataOutColor,
    output [15:0]   DataOutA,
    output [15:0]   DataOutB
);
    // State Machine Parameter
    parameter S_IDLE    = 2'd0;
    parameter S_VALID   = 2'd1;
    parameter S_FULL    = 2'd2;
    parameter S_INIT    = 2'd3;

    reg [1:0]   State;
    reg [1:0]   BankCount;

    reg [2:0]   BankColor [0:3];
    reg [1:0]   WriteBank;
    reg [1:0]   ReadBank;

    wire [5:0]  WriteQuery;

    // State Machine
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            State <= S_IDLE;
            BankCount <= 2'd0;
        end else begin
            case(State)
                S_IDLE: begin
                    if(DataInit) begin
                        State       <= S_INIT;
                    end else if(HuffmanEndEnable) begin
                        State       <= S_VALID;
                        BankCount   <= 2'd0;
                    end
                end
                S_VALID: begin
                    if(HuffmanEndEnable && !(DataOutRead && (DataOutAddress == 5'd31))) begin
                        if(BankCount == 2'd2) begin
                            State       <= S_FULL;
                            BankCount   <= 2'd3;
                        end else begin
                            BankCount <= BankCount + 2'd1;
                        end
                    end else if(!HuffmanEndEnable && (DataOutRead && (DataOutAddress == 5'd31))) begin
                        if(BankCount == 2'd0) begin
                            State       <= S_IDLE;
                            BankCount   <= 2'd0;
                        end else begin
                            BankCount   <= BankCount - 2'd1;
                        end
                    end
                end
                S_FULL: begin
                    if(DataOutRead && (DataOutAddress == 5'd31)) begin
                        State       <= S_VALID;
                        BankCount   <= 2'd2;
                    end
                end
                S_INIT: begin
                    State <= S_IDLE;
                end
            endcase
        end
    end

    // Color
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            BankColor[0]    <= 3'd0;
            BankColor[1]    <= 3'd0;
            BankColor[2]    <= 3'd0;
            BankColor[3]    <= 3'd0;
        end else begin
            if(HuffmanEndEnable) BankColor[WriteBank] <= DataInColor;
        end
    end

    // Bank
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            WriteBank   <= 2'd0;
            ReadBank    <= 2'd0;
        end else begin
            // Write Bank
            if(State == S_INIT) begin
                WriteBank <= 2'd0;
            end else if(HuffmanEndEnable) begin
                WriteBank <= WriteBank + 2'd1;
            end
            // Read Bank
            if(State == S_INIT) begin
                ReadBank <= 2'd0;
            end else if(DataOutRead && (DataOutAddress == 5'd31)) begin
                ReadBank <= ReadBank + 2'd1;
            end
        end
    end

    // Make a Write Address
    function [5:0] F_WriteQuery;
        input [5:0] Count;
        case(Count)
            6'd0:  F_WriteQuery = {1'b0, 5'd0 };
            6'd1:  F_WriteQuery = {1'b0, 5'd2 };
            6'd2:  F_WriteQuery = {1'b0, 5'd4 };
            6'd3:  F_WriteQuery = {1'b0, 5'd8 };
            6'd4:  F_WriteQuery = {1'b0, 5'd6 };
            6'd5:  F_WriteQuery = {1'b0, 5'd1 };
            6'd6:  F_WriteQuery = {1'b1, 5'd3 };
            6'd7:  F_WriteQuery = {1'b0, 5'd5 };
            6'd8:  F_WriteQuery = {1'b0, 5'd10};
            6'd9:  F_WriteQuery = {1'b0, 5'd12};
            6'd10: F_WriteQuery = {1'b0, 5'd16};
            6'd11: F_WriteQuery = {1'b0, 5'd14};
            6'd12: F_WriteQuery = {1'b0, 5'd9 };
            6'd13: F_WriteQuery = {1'b1, 5'd7 };
            6'd14: F_WriteQuery = {1'b1, 5'd0 };
            6'd15: F_WriteQuery = {1'b0, 5'd3 };
            6'd16: F_WriteQuery = {1'b1, 5'd4 };
            6'd17: F_WriteQuery = {1'b1, 5'd11};
            6'd18: F_WriteQuery = {1'b0, 5'd13};
            6'd19: F_WriteQuery = {1'b0, 5'd18};
            6'd20: F_WriteQuery = {1'b0, 5'd20};
            6'd21: F_WriteQuery = {1'b0, 5'd24};
            6'd22: F_WriteQuery = {1'b0, 5'd22};
            6'd23: F_WriteQuery = {1'b0, 5'd17};
            6'd24: F_WriteQuery = {1'b1, 5'd15};
            6'd25: F_WriteQuery = {1'b1, 5'd8 };
            6'd26: F_WriteQuery = {1'b0, 5'd7 };
            6'd27: F_WriteQuery = {1'b1, 5'd1 };
            6'd28: F_WriteQuery = {1'b1, 5'd2 };
            6'd29: F_WriteQuery = {1'b1, 5'd5 };
            6'd30: F_WriteQuery = {1'b0, 5'd11};
            6'd31: F_WriteQuery = {1'b1, 5'd12};
            6'd32: F_WriteQuery = {1'b1, 5'd19};
            6'd33: F_WriteQuery = {1'b0, 5'd21};
            6'd34: F_WriteQuery = {1'b0, 5'd26};
            6'd35: F_WriteQuery = {1'b0, 5'd28};
            6'd36: F_WriteQuery = {1'b0, 5'd30};
            6'd37: F_WriteQuery = {1'b0, 5'd25};
            6'd38: F_WriteQuery = {1'b1, 5'd23};
            6'd39: F_WriteQuery = {1'b1, 5'd16};
            6'd40: F_WriteQuery = {1'b0, 5'd15};
            6'd41: F_WriteQuery = {1'b1, 5'd9 };
            6'd42: F_WriteQuery = {1'b1, 5'd6 };
            6'd43: F_WriteQuery = {1'b1, 5'd10};
            6'd44: F_WriteQuery = {1'b1, 5'd13};
            6'd45: F_WriteQuery = {1'b0, 5'd19};
            6'd46: F_WriteQuery = {1'b1, 5'd20};
            6'd47: F_WriteQuery = {1'b1, 5'd27};
            6'd48: F_WriteQuery = {1'b0, 5'd29};
            6'd49: F_WriteQuery = {1'b1, 5'd31};
            6'd50: F_WriteQuery = {1'b1, 5'd24};
            6'd51: F_WriteQuery = {1'b0, 5'd23};
            6'd52: F_WriteQuery = {1'b1, 5'd17};
            6'd53: F_WriteQuery = {1'b1, 5'd14};
            6'd54: F_WriteQuery = {1'b1, 5'd18};
            6'd55: F_WriteQuery = {1'b1, 5'd21};
            6'd56: F_WriteQuery = {1'b0, 5'd27};
            6'd57: F_WriteQuery = {1'b1, 5'd28};
            6'd58: F_WriteQuery = {1'b0, 5'd31};
            6'd59: F_WriteQuery = {1'b1, 5'd25};
            6'd60: F_WriteQuery = {1'b1, 5'd22};
            6'd61: F_WriteQuery = {1'b1, 5'd26};
            6'd62: F_WriteQuery = {1'b1, 5'd29};
            6'd63: F_WriteQuery = {1'b1, 5'd30};
        endcase
    endfunction

    assign WriteQuery = F_WriteQuery(DataInAddress);

    // RAM(16bit x 32word x 2Bank)
    reg [15:0]  MemoryA  [0:127];
    reg [15:0]  MemoryB  [0:127];

    wire [6:0]  WriteAddress;
    wire        WriteEnableA, WriteEnableB;

    assign WriteEnableA = DataInEnable & ~WriteQuery[5];
    assign WriteEnableB = DataInEnable &  WriteQuery[5];
    assign WriteAddress = {WriteBank, WriteQuery[4:0]};

    // Port A(Write Only)
    always @(posedge clk) begin
        if(WriteEnableA) MemoryA[WriteAddress] <= DataIn;
        if(WriteEnableB) MemoryB[WriteAddress] <= DataIn;
    end

    reg [15:0]  RegMemoryA, RegMemoryB;

    // Port B(Read/Wirte)
    always @(posedge clk) begin
        RegMemoryA <= MemoryA[{ReadBank, DataOutAddress}];
        RegMemoryB <= MemoryB[{ReadBank, DataOutAddress}];
    end

    // Data Enable Register
    reg [127:0] DataEnableA, DataEnableB;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            DataEnableA <= 128'd0;
            DataEnableB <= 128'd0;
        end else begin
            if(State == S_INIT) begin
                DataEnableA <= 128'd0;
                DataEnableB <= 128'd0;
            end else begin
                if(DataInEnable && (WriteBank == 2'd0)) begin
                    if(WriteEnableA) begin
                        if(WriteAddress[4:0] == 5'd0) begin
                            DataEnableA[{2'd0, WriteAddress[4:0]}] <= 1'b1;
                            DataEnableA[31:1] <= 31'd0;
                            DataEnableB[31:0] <= 32'd0;
                        end else begin
                            DataEnableA[{2'd0, WriteAddress[4:0]}] <= 1'b1;
                        end
                    end else begin
                        DataEnableB[{2'd0, WriteAddress[4:0]}] <= 1'b1;
                    end
                end
                if(DataInEnable && (WriteBank == 2'd1)) begin
                    if(WriteEnableA) begin
                        if(WriteAddress[4:0] == 5'd0) begin
                            DataEnableA[{2'd1, WriteAddress[4:0]}] <= 1'b1;
                            DataEnableA[63:33] <= 31'd0;
                            DataEnableB[63:32] <= 32'd0;
                        end else begin
                            DataEnableA[{2'd1, WriteAddress[4:0]}] <= 1'b1;
                        end
                    end else begin
                        DataEnableB[{2'd1, WriteAddress[4:0]}] <= 1'b1;
                    end
                end
                if(DataInEnable && (WriteBank == 2'd2)) begin
                    if(WriteEnableA) begin
                        if(WriteAddress[4:0] == 5'd0) begin
                            DataEnableA[{2'd2, WriteAddress[4:0]}] <= 1'b1;
                            DataEnableA[95:65] <= 31'd0;
                            DataEnableB[95:64] <= 32'd0;
                        end else begin
                            DataEnableA[{2'd2, WriteAddress[4:0]}] <= 1'b1;
                        end
                    end else begin
                        DataEnableB[{2'd2, WriteAddress[4:0]}] <= 1'b1;
                    end
                end
                if(DataInEnable && (WriteBank == 2'd3)) begin
                    if(WriteEnableA) begin
                        if(WriteAddress[4:0] == 5'd0) begin
                            DataEnableA[{2'd3, WriteAddress[4:0]}] <= 1'b1;
                            DataEnableA[127:97] <= 31'd0;
                            DataEnableB[127:96] <= 32'd0;
                        end else begin
                            DataEnableA[{2'd3, WriteAddress[4:0]}] <= 1'b1;
                        end
                    end else begin
                        DataEnableB[{2'd3, WriteAddress[4:0]}] <= 1'b1;
                    end
                end
            end
        end
    end

    reg AddressDelayA, AddressDelayB;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            AddressDelayA <= 1'b0;
            AddressDelayB <= 1'b0;
        end else begin
            AddressDelayA <= DataEnableA[{ReadBank, DataOutAddress}];
            AddressDelayB <= DataEnableB[{ReadBank, DataOutAddress}];
        end
    end

    // Output Signal
    assign DataInIdle       = (State == S_IDLE) | (State == S_VALID);
    assign DataOutEnable    = (State == S_VALID) | (State == S_FULL);
    assign DataOutColor     = BankColor[ReadBank];
    assign DataOutA         = (AddressDelayA)?RegMemoryA:16'd0;
    assign DataOutB         = (AddressDelayB)?RegMemoryB:16'd0;

endmodule
