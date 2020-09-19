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
// Module: Deserialiser
//-----------------------------------------------------------------
module mmc_dat_deserialiser
(
     input          clk_i
    ,input          rst_i
    ,input          bitclk_i
    ,input          start_i
    ,input          abort_i
    ,input          data_i
    ,input          mode_4bit_i
    ,input  [7:0]   block_cnt_i
    ,output         valid_o
    ,output [7:0]   data_o
    ,output         active_o
    ,output         error_o
    ,output         complete_o
);

reg clk_q;

always @ (posedge clk_i )
if (rst_i)
    clk_q <= 1'b0;
else
    clk_q <= bitclk_i;

// Capture on rising edge
wire capture_w = bitclk_i & ~clk_q;

reg [15:0] index_q;

localparam STATE_W          = 3;

// Current state
localparam STATE_IDLE       = 3'd0;
localparam STATE_STARTED    = 3'd1;
localparam STATE_ACTIVE     = 3'd2;
localparam STATE_END        = 3'd3;

reg [STATE_W-1:0] state_q;
reg [STATE_W-1:0] next_state_r;
reg [7:0]         block_cnt_q;

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
        if (capture_w && !data_i)
            next_state_r  = STATE_ACTIVE;
    end
    STATE_ACTIVE:
    begin
        if ((index_q == 16'd0) & capture_w)
        begin
            if (block_cnt_q != 8'd0)
                next_state_r  = STATE_STARTED;
            else
                next_state_r  = STATE_END;
        end
    end
    STATE_END:
    begin
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
    block_cnt_q <= 8'b0;
else if ((state_q == STATE_IDLE) && start_i)
    block_cnt_q <= block_cnt_i;
else if ((state_q == STATE_ACTIVE) && (index_q == 16'd0) && capture_w)
    block_cnt_q <= block_cnt_q - 8'd1;

always @ (posedge clk_i )
if (rst_i)
    index_q <= 16'd0;
else if (state_q == STATE_STARTED)
    index_q <= mode_4bit_i ? 16'd1040: 16'd4112;
else if (capture_w && state_q == STATE_ACTIVE)
    index_q <= index_q - 16'd1;

reg [7:0] data_q;

always @ (posedge clk_i )
if (rst_i)
    data_q <= 8'b0;
else if (state_q == STATE_STARTED)
    data_q <= 8'b0;
else if (state_q == STATE_ACTIVE && capture_w)
    data_q <= {data_q[6:0], data_i};

reg [2:0] bitcnt_q;

always @ (posedge clk_i )
if (rst_i)
    bitcnt_q <= 3'b0;
else if (state_q == STATE_STARTED)
    bitcnt_q <= 3'b0;
else if (state_q == STATE_ACTIVE && capture_w)
    bitcnt_q <= bitcnt_q + 3'd1;

reg valid_q;

always @ (posedge clk_i )
if (rst_i)
    valid_q <= 1'b0;
else
    valid_q <= (state_q == STATE_ACTIVE && capture_w && bitcnt_q == 3'd7 && index_q > 16'd15);

assign active_o   = (state_q != STATE_IDLE);
assign complete_o = (state_q == STATE_END);
assign valid_o    = valid_q;
assign data_o     = data_q;
assign error_o    = 1'b0; // TODO: Add CRC checking

endmodule