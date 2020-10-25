//-----------------------------------------------------------------
//                       AXI-4 JPEG Decoder
//                              V0.1
//                     github.com/ultraembedded
//                          Copyright 2020
//
//                 Email: admin@ultra-embedded.com
//
//                       License: MIT
//-----------------------------------------------------------------
// Copyright (c) 2020 github.com/ultraembedded
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//-----------------------------------------------------------------

`include "jpeg_decoder_defs.v"

//-----------------------------------------------------------------
// Module:  JPEG Decoder Peripheral
//-----------------------------------------------------------------
module jpeg_decoder
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter AXI_ID           = 0
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input          clk_i
    ,input          rst_i
    ,input          cfg_awvalid_i
    ,input  [31:0]  cfg_awaddr_i
    ,input          cfg_wvalid_i
    ,input  [31:0]  cfg_wdata_i
    ,input  [3:0]   cfg_wstrb_i
    ,input          cfg_bready_i
    ,input          cfg_arvalid_i
    ,input  [31:0]  cfg_araddr_i
    ,input          cfg_rready_i
    ,input          outport_awready_i
    ,input          outport_wready_i
    ,input          outport_bvalid_i
    ,input  [1:0]   outport_bresp_i
    ,input  [3:0]   outport_bid_i
    ,input          outport_arready_i
    ,input          outport_rvalid_i
    ,input  [31:0]  outport_rdata_i
    ,input  [1:0]   outport_rresp_i
    ,input  [3:0]   outport_rid_i
    ,input          outport_rlast_i

    // Outputs
    ,output         cfg_awready_o
    ,output         cfg_wready_o
    ,output         cfg_bvalid_o
    ,output [1:0]   cfg_bresp_o
    ,output         cfg_arready_o
    ,output         cfg_rvalid_o
    ,output [31:0]  cfg_rdata_o
    ,output [1:0]   cfg_rresp_o
    ,output         outport_awvalid_o
    ,output [31:0]  outport_awaddr_o
    ,output [3:0]   outport_awid_o
    ,output [7:0]   outport_awlen_o
    ,output [1:0]   outport_awburst_o
    ,output         outport_wvalid_o
    ,output [31:0]  outport_wdata_o
    ,output [3:0]   outport_wstrb_o
    ,output         outport_wlast_o
    ,output         outport_bready_o
    ,output         outport_arvalid_o
    ,output [31:0]  outport_araddr_o
    ,output [3:0]   outport_arid_o
    ,output [7:0]   outport_arlen_o
    ,output [1:0]   outport_arburst_o
    ,output         outport_rready_o
);

//-----------------------------------------------------------------
// Write address / data split
//-----------------------------------------------------------------
// Address but no data ready
reg awvalid_q;

// Data but no data ready
reg wvalid_q;

wire wr_cmd_accepted_w  = (cfg_awvalid_i && cfg_awready_o) || awvalid_q;
wire wr_data_accepted_w = (cfg_wvalid_i  && cfg_wready_o)  || wvalid_q;

always @ (posedge clk_i )
if (rst_i)
    awvalid_q <= 1'b0;
else if (cfg_awvalid_i && cfg_awready_o && !wr_data_accepted_w)
    awvalid_q <= 1'b1;
else if (wr_data_accepted_w)
    awvalid_q <= 1'b0;

always @ (posedge clk_i )
if (rst_i)
    wvalid_q <= 1'b0;
else if (cfg_wvalid_i && cfg_wready_o && !wr_cmd_accepted_w)
    wvalid_q <= 1'b1;
else if (wr_cmd_accepted_w)
    wvalid_q <= 1'b0;

//-----------------------------------------------------------------
// Capture address (for delayed data)
//-----------------------------------------------------------------
reg [7:0] wr_addr_q;

always @ (posedge clk_i )
if (rst_i)
    wr_addr_q <= 8'b0;
else if (cfg_awvalid_i && cfg_awready_o)
    wr_addr_q <= cfg_awaddr_i[7:0];

wire [7:0] wr_addr_w = awvalid_q ? wr_addr_q : cfg_awaddr_i[7:0];

//-----------------------------------------------------------------
// Retime write data
//-----------------------------------------------------------------
reg [31:0] wr_data_q;

always @ (posedge clk_i )
if (rst_i)
    wr_data_q <= 32'b0;
else if (cfg_wvalid_i && cfg_wready_o)
    wr_data_q <= cfg_wdata_i;

//-----------------------------------------------------------------
// Request Logic
//-----------------------------------------------------------------
wire read_en_w  = cfg_arvalid_i & cfg_arready_o;
wire write_en_w = wr_cmd_accepted_w && wr_data_accepted_w;

//-----------------------------------------------------------------
// Accept Logic
//-----------------------------------------------------------------
assign cfg_arready_o = ~cfg_rvalid_o;
assign cfg_awready_o = ~cfg_bvalid_o && ~cfg_arvalid_i && ~awvalid_q;
assign cfg_wready_o  = ~cfg_bvalid_o && ~cfg_arvalid_i && ~wvalid_q;


//-----------------------------------------------------------------
// Register jpeg_ctrl
//-----------------------------------------------------------------
reg jpeg_ctrl_wr_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_ctrl_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_CTRL))
    jpeg_ctrl_wr_q <= 1'b1;
else
    jpeg_ctrl_wr_q <= 1'b0;

// jpeg_ctrl_start [auto_clr]
reg        jpeg_ctrl_start_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_ctrl_start_q <= 1'd`JPEG_CTRL_START_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_CTRL))
    jpeg_ctrl_start_q <= cfg_wdata_i[`JPEG_CTRL_START_R];
else
    jpeg_ctrl_start_q <= 1'd`JPEG_CTRL_START_DEFAULT;

wire        jpeg_ctrl_start_out_w = jpeg_ctrl_start_q;


// jpeg_ctrl_abort [auto_clr]
reg        jpeg_ctrl_abort_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_ctrl_abort_q <= 1'd`JPEG_CTRL_ABORT_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_CTRL))
    jpeg_ctrl_abort_q <= cfg_wdata_i[`JPEG_CTRL_ABORT_R];
else
    jpeg_ctrl_abort_q <= 1'd`JPEG_CTRL_ABORT_DEFAULT;

wire        jpeg_ctrl_abort_out_w = jpeg_ctrl_abort_q;


// jpeg_ctrl_length [internal]
reg [23:0]  jpeg_ctrl_length_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_ctrl_length_q <= 24'd`JPEG_CTRL_LENGTH_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_CTRL))
    jpeg_ctrl_length_q <= cfg_wdata_i[`JPEG_CTRL_LENGTH_R];

wire [23:0]  jpeg_ctrl_length_out_w = jpeg_ctrl_length_q;


//-----------------------------------------------------------------
// Register jpeg_status
//-----------------------------------------------------------------
reg jpeg_status_wr_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_status_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_STATUS))
    jpeg_status_wr_q <= 1'b1;
else
    jpeg_status_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register jpeg_src
//-----------------------------------------------------------------
reg jpeg_src_wr_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_src_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_SRC))
    jpeg_src_wr_q <= 1'b1;
else
    jpeg_src_wr_q <= 1'b0;

// jpeg_src_addr [internal]
reg [31:0]  jpeg_src_addr_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_src_addr_q <= 32'd`JPEG_SRC_ADDR_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_SRC))
    jpeg_src_addr_q <= cfg_wdata_i[`JPEG_SRC_ADDR_R];

wire [31:0]  jpeg_src_addr_out_w = jpeg_src_addr_q;


//-----------------------------------------------------------------
// Register jpeg_dst
//-----------------------------------------------------------------
reg jpeg_dst_wr_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_dst_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_DST))
    jpeg_dst_wr_q <= 1'b1;
else
    jpeg_dst_wr_q <= 1'b0;

// jpeg_dst_addr [internal]
reg [31:0]  jpeg_dst_addr_q;

always @ (posedge clk_i )
if (rst_i)
    jpeg_dst_addr_q <= 32'd`JPEG_DST_ADDR_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `JPEG_DST))
    jpeg_dst_addr_q <= cfg_wdata_i[`JPEG_DST_ADDR_R];

wire [31:0]  jpeg_dst_addr_out_w = jpeg_dst_addr_q;


wire        jpeg_status_busy_in_w;


//-----------------------------------------------------------------
// Read mux
//-----------------------------------------------------------------
reg [31:0] data_r;

always @ *
begin
    data_r = 32'b0;

    case (cfg_araddr_i[7:0])

    `JPEG_CTRL:
    begin
        data_r[`JPEG_CTRL_LENGTH_R] = jpeg_ctrl_length_q;
    end
    `JPEG_STATUS:
    begin
        data_r[`JPEG_STATUS_BUSY_R] = jpeg_status_busy_in_w;
    end
    `JPEG_SRC:
    begin
        data_r[`JPEG_SRC_ADDR_R] = jpeg_src_addr_q;
    end
    `JPEG_DST:
    begin
        data_r[`JPEG_DST_ADDR_R] = jpeg_dst_addr_q;
    end
    default :
        data_r = 32'b0;
    endcase
end

//-----------------------------------------------------------------
// RVALID
//-----------------------------------------------------------------
reg rvalid_q;

always @ (posedge clk_i )
if (rst_i)
    rvalid_q <= 1'b0;
else if (read_en_w)
    rvalid_q <= 1'b1;
else if (cfg_rready_i)
    rvalid_q <= 1'b0;

assign cfg_rvalid_o = rvalid_q;

//-----------------------------------------------------------------
// Retime read response
//-----------------------------------------------------------------
reg [31:0] rd_data_q;

always @ (posedge clk_i )
if (rst_i)
    rd_data_q <= 32'b0;
else if (!cfg_rvalid_o || cfg_rready_i)
    rd_data_q <= data_r;

assign cfg_rdata_o = rd_data_q;
assign cfg_rresp_o = 2'b0;

//-----------------------------------------------------------------
// BVALID
//-----------------------------------------------------------------
reg bvalid_q;

always @ (posedge clk_i )
if (rst_i)
    bvalid_q <= 1'b0;
else if (write_en_w)
    bvalid_q <= 1'b1;
else if (cfg_bready_i)
    bvalid_q <= 1'b0;

assign cfg_bvalid_o = bvalid_q;
assign cfg_bresp_o  = 2'b0;



localparam BUFFER_DEPTH   = 1024;
localparam BUFFER_DEPTH_W = 10;
localparam BURST_LEN      = 32 / 4;

wire        jpeg_valid_w;
wire [31:0] jpeg_data_w;
wire        jpeg_accept_w;

wire [10:0] fifo_in_level_w;
wire [10:0] fifo_addr_level_w;
wire [10:0] fifo_data_level_w;

reg         core_busy_q;
wire        core_idle_w;
reg [31:0]  remaining_q;
reg [15:0]  allocated_q;

//-----------------------------------------------------------------
// FSM
//-----------------------------------------------------------------
localparam STATE_W          = 2;

// Current state
localparam STATE_IDLE       = 2'd0;
localparam STATE_FILL       = 2'd1;
localparam STATE_ACTIVE     = 2'd2;
localparam STATE_DRAIN      = 2'd3;
reg [STATE_W-1:0] state_q;
reg [STATE_W-1:0] next_state_r;

always @ *
begin
    next_state_r = state_q;

    case (state_q)
    STATE_IDLE :
    begin
        if (jpeg_ctrl_start_out_w)
            next_state_r  = STATE_FILL;
    end
    STATE_FILL:
    begin
        if ((fifo_in_level_w > (BUFFER_DEPTH/2)) || (remaining_q == 32'b0))
            next_state_r  = STATE_ACTIVE;
    end
    STATE_ACTIVE:
    begin
        if (core_busy_q && core_idle_w)
            next_state_r  = STATE_DRAIN;
    end
    STATE_DRAIN:
    begin
        if (fifo_addr_level_w == 11'b0 && fifo_data_level_w == 11'b0)
            next_state_r = STATE_IDLE;
    end
    default:
        ;
    endcase

    if (jpeg_ctrl_abort_out_w)
        next_state_r = STATE_IDLE;
end

always @ (posedge clk_i )
if (rst_i)
    state_q <= STATE_IDLE;
else
    state_q <= next_state_r;

assign jpeg_status_busy_in_w = (state_q != STATE_IDLE);    

//-----------------------------------------------------------------
// Core active
//-----------------------------------------------------------------
reg  core_active_q;

always @ (posedge clk_i )
if (rst_i)
    core_active_q  <= 1'b0;
else if (state_q == STATE_IDLE && next_state_r == STATE_FILL)
    core_active_q  <= 1'b1;
else if (state_q == STATE_ACTIVE && next_state_r == STATE_DRAIN)
    core_active_q  <= 1'b0;

//-----------------------------------------------------------------
// Core busy
//-----------------------------------------------------------------
always @ (posedge clk_i )
if (rst_i)
    core_busy_q  <= 1'b0;
else if (state_q == STATE_ACTIVE && !core_idle_w)
    core_busy_q  <= 1'b1;
else if (state_q == STATE_ACTIVE && core_idle_w)
    core_busy_q  <= 1'b0;

//-----------------------------------------------------------------
// FIFO allocation
//-----------------------------------------------------------------
always @ (posedge clk_i )
if (rst_i)
    allocated_q  <= 16'b0;
else if (jpeg_ctrl_abort_out_w || (state_q == STATE_DRAIN))
    allocated_q  <= 16'b0;
else if (outport_arvalid_o && outport_arready_i)
begin
    if (jpeg_valid_w && jpeg_accept_w)
        allocated_q  <= allocated_q + {8'b0, outport_arlen_o};
    else
        allocated_q  <= allocated_q + {8'b0, outport_arlen_o} + 16'd1;
end
else if (jpeg_valid_w && jpeg_accept_w)
    allocated_q  <= allocated_q - 16'd1;

//-----------------------------------------------------------------
// AXI Fetch
//-----------------------------------------------------------------
// Calculate number of bytes being fetch
wire [31:0] fetch_bytes_w = {22'b0, (outport_arlen_o + 8'd1), 2'b0};

reg         arvalid_q;
reg [31:0]  araddr_q;

wire [31:0] remain_rounded_w = remaining_q + 32'd3;
wire [31:0] remain_words_w   = {2'b0, remain_rounded_w[31:2]};
wire [31:0] max_words_w      = (remain_words_w > BURST_LEN && (araddr_q & ((BURST_LEN*4)-1)) == 32'd0) ? BURST_LEN : 1;
wire        fifo_space_w     = (BUFFER_DEPTH - allocated_q) > BURST_LEN;

always @ (posedge clk_i )
if (rst_i)
    remaining_q <= 32'b0;
else if (jpeg_ctrl_start_out_w)
    remaining_q <= {8'b0, jpeg_ctrl_length_out_w};
else if (jpeg_ctrl_abort_out_w)
    remaining_q <= 32'b0;
else if (outport_arvalid_o && outport_arready_i)
begin
    if (remaining_q > fetch_bytes_w)
        remaining_q <= remaining_q - fetch_bytes_w;
    else
        remaining_q <= 32'b0;
end

always @ (posedge clk_i )
if (rst_i)
    arvalid_q <= 1'b0;
else if (outport_arvalid_o && outport_arready_i)
    arvalid_q <= 1'b0;
else if (!outport_arvalid_o && fifo_space_w && remaining_q != 32'b0)
    arvalid_q <= 1'b1;

assign outport_arvalid_o = arvalid_q;

always @ (posedge clk_i )
if (rst_i)
    araddr_q <= 32'b0;
else if (outport_arvalid_o && outport_arready_i)
    araddr_q  <= araddr_q + fetch_bytes_w;
else if (jpeg_ctrl_start_out_w)
    araddr_q <= jpeg_src_addr_out_w;

reg [7:0] arlen_q;

always @ (posedge clk_i )
if (rst_i)
    arlen_q <= 8'b0;
else
    arlen_q <= max_words_w - 1;

assign outport_araddr_o  = araddr_q;
assign outport_arburst_o = 2'b01;
assign outport_arid_o    = AXI_ID;
assign outport_arlen_o   = arlen_q;

assign outport_rready_o  = 1'b1;

//-----------------------------------------------------------------
// JPEG fetch FIFO
//-----------------------------------------------------------------
wire fifo_jpeg_valid_w;

jpeg_decoder_input_fifo
u_fifo_in
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.flush_i(jpeg_ctrl_abort_out_w || (state_q == STATE_DRAIN))

    ,.push_i(outport_rvalid_i)
    ,.data_in_i(outport_rdata_i)
    ,.accept_o()

    ,.valid_o(fifo_jpeg_valid_w)
    ,.data_out_o(jpeg_data_w)
    ,.pop_i(jpeg_accept_w)

    ,.level_o(fifo_in_level_w)
);

assign jpeg_valid_w = fifo_jpeg_valid_w & (state_q == STATE_ACTIVE);

//-----------------------------------------------------------------
// Decoder core
//-----------------------------------------------------------------
wire [15:0] pixel_x_w;
wire [15:0] pixel_y_w;
wire [15:0] pixel_w_w;
wire [15:0] pixel_h_w;

wire        pixel_valid_w;
wire [7:0]  pixel_r_w;
wire [7:0]  pixel_g_w;
wire [7:0]  pixel_b_w;
wire        fifo_accept_in_w;

wire        core_accept_w;

jpeg_core
u_core
(
     .clk_i(clk_i)
    ,.rst_i(~core_active_q)

    ,.inport_valid_i(jpeg_valid_w)
    ,.inport_data_i(jpeg_data_w)
    ,.inport_strb_i(4'hF)
    ,.inport_last_i(1'b0)
    ,.inport_accept_o(core_accept_w)

    ,.outport_valid_o(pixel_valid_w)
    ,.outport_width_o(pixel_w_w)
    ,.outport_height_o(pixel_h_w)
    ,.outport_pixel_x_o(pixel_x_w)
    ,.outport_pixel_y_o(pixel_y_w)
    ,.outport_pixel_r_o(pixel_r_w)
    ,.outport_pixel_g_o(pixel_g_w)
    ,.outport_pixel_b_o(pixel_b_w)
    ,.outport_accept_i(fifo_accept_in_w)

    ,.idle_o(core_idle_w)
);

assign jpeg_accept_w = core_accept_w & (state_q == STATE_ACTIVE);

wire [15:0] rgb565_w = {pixel_r_w[7:3], pixel_g_w[7:2], pixel_b_w[7:3]};

//-----------------------------------------------------------------
// Write Combine
//-----------------------------------------------------------------
reg [15:0] pixel_q;
always @ (posedge clk_i )
if (rst_i)
    pixel_q  <= 16'b0;
else if (pixel_valid_w)
    pixel_q  <= rgb565_w;

reg pixel_idx_q;
always @ (posedge clk_i )
if (rst_i)
    pixel_idx_q  <= 1'b0;
else if (pixel_valid_w)
    pixel_idx_q  <= ~pixel_x_w[0];

reg [31:0] pixel_offset_q;

always @ (posedge clk_i )
if (rst_i)
    pixel_offset_q  <= 32'b0;
else
    pixel_offset_q  <= {15'b0, pixel_w_w, 1'b0} * {16'b0,pixel_y_w};

wire [31:0] pixel_addr_w  = jpeg_dst_addr_out_w + pixel_offset_q + {15'b0, pixel_x_w[15:1], 2'b0};
wire        pixel_ready_w = pixel_idx_q && pixel_valid_w;
wire [31:0] pixel_data_w  = {rgb565_w, pixel_q};

//-----------------------------------------------------------------
// Output FIFO
//-----------------------------------------------------------------
wire        fifo_accept_addr_in_w;
wire        fifo_accept_data_in_w;
wire        fifo_addr_push_w = pixel_ready_w & (state_q == STATE_ACTIVE) & fifo_accept_data_in_w;
wire        fifo_data_push_w = pixel_ready_w & (state_q == STATE_ACTIVE) & fifo_accept_addr_in_w;

jpeg_decoder_output_fifo
u_fifo_addr_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.push_i(fifo_addr_push_w)
    ,.data_in_i(pixel_addr_w)
    ,.accept_o(fifo_accept_addr_in_w)

    ,.valid_o(outport_awvalid_o)
    ,.data_out_o(outport_awaddr_o)
    ,.pop_i(outport_awready_i)

    ,.level_o(fifo_addr_level_w)
);

jpeg_decoder_output_fifo
u_fifo_data_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.push_i(fifo_data_push_w)
    ,.data_in_i(pixel_data_w)
    ,.accept_o(fifo_accept_data_in_w)

    ,.valid_o(outport_wvalid_o)
    ,.data_out_o(outport_wdata_o)
    ,.pop_i(outport_wready_i)

    ,.level_o(fifo_data_level_w)
);

assign fifo_accept_in_w = fifo_accept_addr_in_w & fifo_accept_data_in_w;

//-----------------------------------------------------------------
// Constants
//-----------------------------------------------------------------
assign outport_awlen_o   = 8'd0;  // Singles (not efficient!)
assign outport_awburst_o = 2'b01; // INCR
assign outport_awid_o    = AXI_ID;
assign outport_wstrb_o   = 4'hF;
assign outport_wlast_o   = 1'b1;

assign outport_bready_o  = 1'b1;


endmodule
