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

module aq_djpeg_idctb(
    input           clk,
    input           rst,

    input           DataInit,

    input           DataInEnable,
    input [2:0]     DataInPage,
    input [1:0]     DataInCount,
    output          DataInIdle,
    input [15:0]    DataInA,
    input [15:0]    DataInB,

    output          DataOutEnable,
    input           DataOutRead,
    input [4:0]     DataOutAddress,
    output [15:0]   DataOutA,
    output [15:0]   DataOutB
);
    wire [4:0]      DataInAddress;
    reg [1:0]       WriteBank, ReadBank;

    assign DataInAddress = {DataInPage, DataInCount};

    // Bank
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            WriteBank <= 2'd0;
            ReadBank <= 2'd0;
        end else begin
            if(DataInit) begin
                WriteBank <= 2'd0;
            end else if(DataInEnable && (DataInAddress == 5'h1F)) begin
                WriteBank <= WriteBank + 2'd1;
            end
            if(DataInit) begin
                ReadBank <= 2'd0;
            end else if(DataOutRead && (DataOutAddress == 5'h1F)) begin
                ReadBank <= ReadBank + 2'd1;
            end
        end
    end

    wire [5:0]  WriteQueryA, WriteQueryB;

    // Make a Write Address
    function [5:0] F_WriteQueryA;
        input [4:0] Count;
        case(Count)
            5'd0:  F_WriteQueryA = {1'd0, 5'd0};    // 0
            5'd1:  F_WriteQueryA = {1'd0, 5'd4};    // 1
            5'd2:  F_WriteQueryA = {1'd0, 5'd8};    // 2
            5'd3:  F_WriteQueryA = {1'd0, 5'd12};   // 3
            5'd4:  F_WriteQueryA = {1'd0, 5'd2};    // 8
            5'd5:  F_WriteQueryA = {1'd0, 5'd6};    // 9
            5'd6:  F_WriteQueryA = {1'd0, 5'd10};   // 10
            5'd7:  F_WriteQueryA = {1'd0, 5'd14};   // 11
            5'd8:  F_WriteQueryA = {1'd0, 5'd1};    // 16
            5'd9:  F_WriteQueryA = {1'd0, 5'd5};    // 17
            5'd10: F_WriteQueryA = {1'd0, 5'd9};    // 18
            5'd11: F_WriteQueryA = {1'd0, 5'd13};   // 19
            5'd12: F_WriteQueryA = {1'd1, 5'd3};    // 24
            5'd13: F_WriteQueryA = {1'd1, 5'd7};    // 25
            5'd14: F_WriteQueryA = {1'd1, 5'd11};   // 26
            5'd15: F_WriteQueryA = {1'd1, 5'd15};   // 27
            5'd16: F_WriteQueryA = {1'd1, 5'd0};    // 32
            5'd17: F_WriteQueryA = {1'd1, 5'd4};    // 33
            5'd18: F_WriteQueryA = {1'd1, 5'd8};    // 34
            5'd19: F_WriteQueryA = {1'd1, 5'd12};   // 35
            5'd20: F_WriteQueryA = {1'd0, 5'd3};    // 40
            5'd21: F_WriteQueryA = {1'd0, 5'd7};    // 41
            5'd22: F_WriteQueryA = {1'd0, 5'd11};   // 42
            5'd23: F_WriteQueryA = {1'd0, 5'd15};   // 43
            5'd24: F_WriteQueryA = {1'd1, 5'd1};    // 48
            5'd25: F_WriteQueryA = {1'd1, 5'd5};    // 49
            5'd26: F_WriteQueryA = {1'd1, 5'd9};    // 50
            5'd27: F_WriteQueryA = {1'd1, 5'd13};   // 51
            5'd28: F_WriteQueryA = {1'd1, 5'd2};    // 56
            5'd29: F_WriteQueryA = {1'd1, 5'd6};    // 57
            5'd30: F_WriteQueryA = {1'd1, 5'd10};   // 58
            5'd31: F_WriteQueryA = {1'd1, 5'd14};   // 59
        endcase
    endfunction

    function [5:0] F_WriteQueryB;
        input [4:0] Count;
        case(Count)
            5'd0:  F_WriteQueryB = {1'd1, 5'd28};   // 7
            5'd1:  F_WriteQueryB = {1'd1, 5'd24};   // 6
            5'd2:  F_WriteQueryB = {1'd1, 5'd20};   // 5
            5'd3:  F_WriteQueryB = {1'd1, 5'd16};   // 4
            5'd4:  F_WriteQueryB = {1'd1, 5'd30};   // 15
            5'd5:  F_WriteQueryB = {1'd1, 5'd26};   // 14
            5'd6:  F_WriteQueryB = {1'd1, 5'd22};   // 13
            5'd7:  F_WriteQueryB = {1'd1, 5'd18};   // 12
            5'd8:  F_WriteQueryB = {1'd1, 5'd29};   // 23
            5'd9:  F_WriteQueryB = {1'd1, 5'd25};   // 22
            5'd10: F_WriteQueryB = {1'd1, 5'd21};   // 21
            5'd11: F_WriteQueryB = {1'd1, 5'd17};   // 20
            5'd12: F_WriteQueryB = {1'd0, 5'd31};   // 31
            5'd13: F_WriteQueryB = {1'd0, 5'd27};   // 30
            5'd14: F_WriteQueryB = {1'd0, 5'd23};   // 29
            5'd15: F_WriteQueryB = {1'd0, 5'd19};   // 28
            5'd16: F_WriteQueryB = {1'd0, 5'd28};   // 39
            5'd17: F_WriteQueryB = {1'd0, 5'd24};   // 38
            5'd18: F_WriteQueryB = {1'd0, 5'd20};   // 37
            5'd19: F_WriteQueryB = {1'd0, 5'd16};   // 36
            5'd20: F_WriteQueryB = {1'd1, 5'd31};   // 47
            5'd21: F_WriteQueryB = {1'd1, 5'd27};   // 46
            5'd22: F_WriteQueryB = {1'd1, 5'd23};   // 45
            5'd23: F_WriteQueryB = {1'd1, 5'd19};   // 44
            5'd24: F_WriteQueryB = {1'd0, 5'd29};   // 55
            5'd25: F_WriteQueryB = {1'd0, 5'd25};   // 54
            5'd26: F_WriteQueryB = {1'd0, 5'd21};   // 53
            5'd27: F_WriteQueryB = {1'd0, 5'd17};   // 52
            5'd28: F_WriteQueryB = {1'd0, 5'd30};   // 63
            5'd29: F_WriteQueryB = {1'd0, 5'd26};   // 62
            5'd30: F_WriteQueryB = {1'd0, 5'd22};   // 61
            5'd31: F_WriteQueryB = {1'd0, 5'd18};   // 60
        endcase
    endfunction

    assign WriteQueryA = F_WriteQueryA(DataInAddress);
    assign WriteQueryB = F_WriteQueryB(DataInAddress);

    // RAM(16bit x 32word x 2Bank)
    reg [15:0]  MemoryA  [0:127];
    reg [15:0]  MemoryB  [0:127];

    wire [6:0]  WriteAddressA, WriteAddressB;
    wire [15:0] WriteDataA, WriteDataB;

    assign WriteAddressA = {WriteBank, (WriteQueryA[5])?WriteQueryB[4:0]:WriteQueryA[4:0]};
    assign WriteAddressB = {WriteBank, (WriteQueryB[5])?WriteQueryB[4:0]:WriteQueryA[4:0]};

    assign WriteDataA = (WriteQueryA[5])?DataInB:DataInA;
    assign WriteDataB = (WriteQueryB[5])?DataInB:DataInA;

    // Port A(Write Only)
    always @(posedge clk) begin
        if(DataInEnable) MemoryA[WriteAddressA] <= WriteDataA;
        if(DataInEnable) MemoryB[WriteAddressB] <= WriteDataB;
    end

    reg [15:0]  RegMemoryA, RegMemoryB;

    // Port B(Read/Wirte)
    always @(posedge clk) begin
        RegMemoryA <= MemoryA[{ReadBank, DataOutAddress}];
        RegMemoryB <= MemoryB[{ReadBank, DataOutAddress}];
    end

    assign DataOutEnable    = (WriteBank != ReadBank);
    assign DataOutA         = (DataOutAddress[4])?RegMemoryB:RegMemoryA;
    assign DataOutB         = (DataOutAddress[4])?RegMemoryA:RegMemoryB;

endmodule
