//-----------------------------------------------------------------
//                MMC (and derivative standards) Host
//                            V0.1
//                     Ultra-Embedded.com
//                        Copyright 2020
//
//                   admin@ultra-embedded.com
//
//                     License: Apache 2.0
//-----------------------------------------------------------------
// Copyright 2020 Ultra-Embedded.com
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------
//-----------------------------------------------------------------
// Module: Serialiser
//-----------------------------------------------------------------
module mmc_cmd_serialiser
(
     input        clk_i
    ,input        rst_i
    ,input        bitclk_i
    ,input        start_i
    ,input        abort_i
    ,input [47:0] data_i
    ,output       cmd_o
    ,output       active_o
    ,output       complete_o
);

reg clk_q;

always @ (posedge clk_i )
if (rst_i)
    clk_q <= 1'b0;
else
    clk_q <= bitclk_i;

// Drive on falling edge
wire drive_w = ~bitclk_i & clk_q;

reg [7:0] index_q;

localparam STATE_W          = 3;

// Current state
localparam STATE_IDLE       = 3'd0;
localparam STATE_STARTED    = 3'd1;
localparam STATE_ACTIVE     = 3'd2;
localparam STATE_END        = 3'd3;

reg [STATE_W-1:0] state_q;
reg [STATE_W-1:0] next_state_r;

always @ *
begin
    next_state_r = state_q;

    case (state_q)
    STATE_IDLE :
    begin
        if (start_i)
            next_state_r  = STATE_STARTED;
    end
    STATE_STARTED:
    begin
        if (drive_w)
            next_state_r  = STATE_ACTIVE;
    end
    STATE_ACTIVE:
    begin
        if ((index_q == 8'd0) & drive_w)
            next_state_r  = STATE_END;   
    end
    STATE_END:
    begin
        if (drive_w)
            next_state_r  = STATE_IDLE;
    end
    default :
        ;
    endcase

    if (abort_i)
        next_state_r  = STATE_IDLE;
end

always @ (posedge clk_i )
if (rst_i)
    state_q <= STATE_IDLE;
else
    state_q <= next_state_r;


always @ (posedge clk_i )
if (rst_i)
    index_q <= 8'd47;
else if (start_i)
    index_q <= 8'd47;
else if (drive_w && state_q == STATE_ACTIVE)
    index_q <= index_q - 8'd1;

wire [6:0] crc7_w;
mmc_crc7
u_crc7
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.clear_i(state_q == STATE_IDLE)
    ,.bitval_i(data_i[index_q[5:0]])
    ,.enable_i(drive_w && (state_q == STATE_ACTIVE) && index_q > 8'd7)
    ,.crc_o(crc7_w)
);

reg cmd_q;

always @ (posedge clk_i )
if (rst_i)
    cmd_q <= 1'b1;
else if (drive_w && state_q == STATE_ACTIVE)
begin
    if (index_q > 8'd7)
        cmd_q <= data_i[index_q[5:0]];
    else if (index_q == 8'd0)
        cmd_q <= 1'b1;
    else
        cmd_q <= crc7_w[index_q[5:0]-1];
end
else if (complete_o)
    cmd_q <= 1'b1;

assign cmd_o      = cmd_q;
assign active_o   = (state_q != STATE_IDLE);
assign complete_o = (state_q == STATE_END) & drive_w;

endmodule
