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
module mmc_dat_serialiser
(
     input          clk_i
    ,input          rst_i
    ,input          bitclk_i
    ,input          start_i
    ,input          abort_i
    ,input  [7:0]   data_i
    ,output         accept_o
    ,input          mode_4bit_i
    ,input  [7:0]   block_cnt_i
    ,output         dat_o
    ,output         dat_out_en_o
    ,output         active_o
    ,output         complete_o
);

reg clk_q;

always @ (posedge clk_i )
if (rst_i)
    clk_q <= 1'b0;
else
    clk_q <= bitclk_i;

// Drive on falling edge
wire drive_w = ~bitclk_i & clk_q;

reg [15:0] index_q;
reg [2:0]  bitcnt_q;

localparam STATE_W          = 3;

// Current state
localparam STATE_IDLE       = 3'd0;
localparam STATE_DELAY      = 3'd1;
localparam STATE_STARTED    = 3'd2;
localparam STATE_ACTIVE     = 3'd3;
localparam STATE_END        = 3'd4;

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
            next_state_r  = STATE_DELAY;
    end
    STATE_DELAY:
    begin
        if (drive_w && bitcnt_q == 3'd7)
            next_state_r  = STATE_STARTED;
    end
    STATE_STARTED:
    begin
        if (drive_w)
            next_state_r  = STATE_ACTIVE;
    end
    STATE_ACTIVE:
    begin
        if ((index_q == 16'd0) & drive_w)
        begin
            //if (block_cnt_q != 8'd0)
            //    next_state_r  = STATE_STARTED;
            //else
                next_state_r  = STATE_END;
        end
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
    block_cnt_q <= 8'b0;
else if ((state_q == STATE_IDLE) && start_i)
    block_cnt_q <= block_cnt_i;
else if ((state_q == STATE_ACTIVE) && (index_q == 16'd0) && drive_w)
    block_cnt_q <= block_cnt_q - 8'd1;

always @ (posedge clk_i )
if (rst_i)
    index_q <= 16'd0;
else if (state_q == STATE_STARTED)
    index_q <= mode_4bit_i ? 16'd1040: 16'd4112;
else if (drive_w && state_q == STATE_ACTIVE)
    index_q <= index_q - 16'd1;

always @ (posedge clk_i )
if (rst_i)
    bitcnt_q <= 3'b0;
else if (state_q == STATE_STARTED)
    bitcnt_q <= 3'b0;
else if (state_q == STATE_DELAY && drive_w)
    bitcnt_q <= bitcnt_q + 3'd1;    
else if (state_q == STATE_ACTIVE && drive_w)
    bitcnt_q <= bitcnt_q + 3'd1;

reg [7:0] data_q;

always @ (posedge clk_i )
if (rst_i)
    data_q <= 8'b0;
else if (accept_o)
    data_q <= data_i;
else if (state_q == STATE_ACTIVE && drive_w)
    data_q <= {data_q[6:0], 1'b0};

assign accept_o = ((state_q == STATE_IDLE) && start_i) || (state_q == STATE_ACTIVE && drive_w && bitcnt_q == 3'd7);

wire [15:0] crc_w;

mmc_crc16
u_crc16
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    
    ,.clear_i(state_q == STATE_IDLE)
    ,.bitval_i(data_q[7])
    ,.enable_i(drive_w && state_q == STATE_ACTIVE && index_q > 16'd16)
    ,.crc_o(crc_w)
);

reg [31:0] tmp_cnt_q;
always @ (posedge clk_i )
if (rst_i)
    tmp_cnt_q <= 32'b0;
else if (state_q == STATE_IDLE)
    tmp_cnt_q <= 32'b0;
else if (state_q == STATE_ACTIVE && drive_w)
    tmp_cnt_q <= tmp_cnt_q + 32'd1;

reg dat_q;

always @ (posedge clk_i )
if (rst_i)
    dat_q <= 1'b1;
else if (drive_w && state_q == STATE_STARTED)
    dat_q <= 1'b0;
else if (drive_w && state_q == STATE_ACTIVE)
begin
    if (index_q > 16'd16)
        dat_q <= data_q[7];
    else
        dat_q <= crc_w[index_q - 1];
end
else if (complete_o)
    dat_q <= 1'b1;

assign dat_o        = dat_q;
assign dat_out_en_o = (state_q != STATE_IDLE);

assign active_o   = (state_q != STATE_IDLE);
assign complete_o = (state_q == STATE_END);

endmodule