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

`include "mmc_card_defs.v"

//-----------------------------------------------------------------
// Module:  MMC Peripheral
//-----------------------------------------------------------------
module mmc_card
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter MMC_FIFO_DEPTH   = 1024
    ,parameter MMC_FIFO_DEPTH_W = 10
    ,parameter AXI_ID           = 0
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
    ,input          mmc_cmd_in_i
    ,input  [3:0]   mmc_dat_in_i
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
    ,output         mmc_clk_o
    ,output         mmc_cmd_out_o
    ,output         mmc_cmd_out_en_o
    ,output [3:0]   mmc_dat_out_o
    ,output [3:0]   mmc_dat_out_en_o
    ,output         intr_o
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
// Register mmc_control
//-----------------------------------------------------------------
reg mmc_control_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_wr_q <= 1'b1;
else
    mmc_control_wr_q <= 1'b0;

// mmc_control_start [auto_clr]
reg        mmc_control_start_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_start_q <= 1'd`MMC_CONTROL_START_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_start_q <= cfg_wdata_i[`MMC_CONTROL_START_R];
else
    mmc_control_start_q <= 1'd`MMC_CONTROL_START_DEFAULT;

wire        mmc_control_start_out_w = mmc_control_start_q;


// mmc_control_abort [auto_clr]
reg        mmc_control_abort_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_abort_q <= 1'd`MMC_CONTROL_ABORT_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_abort_q <= cfg_wdata_i[`MMC_CONTROL_ABORT_R];
else
    mmc_control_abort_q <= 1'd`MMC_CONTROL_ABORT_DEFAULT;

wire        mmc_control_abort_out_w = mmc_control_abort_q;


// mmc_control_fifo_rst [auto_clr]
reg        mmc_control_fifo_rst_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_fifo_rst_q <= 1'd`MMC_CONTROL_FIFO_RST_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_fifo_rst_q <= cfg_wdata_i[`MMC_CONTROL_FIFO_RST_R];
else
    mmc_control_fifo_rst_q <= 1'd`MMC_CONTROL_FIFO_RST_DEFAULT;

wire        mmc_control_fifo_rst_out_w = mmc_control_fifo_rst_q;


// mmc_control_block_cnt [internal]
reg [7:0]  mmc_control_block_cnt_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_block_cnt_q <= 8'd`MMC_CONTROL_BLOCK_CNT_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_block_cnt_q <= cfg_wdata_i[`MMC_CONTROL_BLOCK_CNT_R];

wire [7:0]  mmc_control_block_cnt_out_w = mmc_control_block_cnt_q;


// mmc_control_write [internal]
reg        mmc_control_write_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_write_q <= 1'd`MMC_CONTROL_WRITE_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_write_q <= cfg_wdata_i[`MMC_CONTROL_WRITE_R];

wire        mmc_control_write_out_w = mmc_control_write_q;


// mmc_control_dma_en [internal]
reg        mmc_control_dma_en_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_dma_en_q <= 1'd`MMC_CONTROL_DMA_EN_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_dma_en_q <= cfg_wdata_i[`MMC_CONTROL_DMA_EN_R];

wire        mmc_control_dma_en_out_w = mmc_control_dma_en_q;


// mmc_control_wide_mode [internal]
reg        mmc_control_wide_mode_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_wide_mode_q <= 1'd`MMC_CONTROL_WIDE_MODE_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_wide_mode_q <= cfg_wdata_i[`MMC_CONTROL_WIDE_MODE_R];

wire        mmc_control_wide_mode_out_w = mmc_control_wide_mode_q;


// mmc_control_data_exp [internal]
reg        mmc_control_data_exp_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_data_exp_q <= 1'd`MMC_CONTROL_DATA_EXP_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_data_exp_q <= cfg_wdata_i[`MMC_CONTROL_DATA_EXP_R];

wire        mmc_control_data_exp_out_w = mmc_control_data_exp_q;


// mmc_control_resp136_exp [internal]
reg        mmc_control_resp136_exp_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_resp136_exp_q <= 1'd`MMC_CONTROL_RESP136_EXP_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_resp136_exp_q <= cfg_wdata_i[`MMC_CONTROL_RESP136_EXP_R];

wire        mmc_control_resp136_exp_out_w = mmc_control_resp136_exp_q;


// mmc_control_resp48_exp [internal]
reg        mmc_control_resp48_exp_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_control_resp48_exp_q <= 1'd`MMC_CONTROL_RESP48_EXP_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CONTROL))
    mmc_control_resp48_exp_q <= cfg_wdata_i[`MMC_CONTROL_RESP48_EXP_R];

wire        mmc_control_resp48_exp_out_w = mmc_control_resp48_exp_q;


//-----------------------------------------------------------------
// Register mmc_clock
//-----------------------------------------------------------------
reg mmc_clock_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_clock_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CLOCK))
    mmc_clock_wr_q <= 1'b1;
else
    mmc_clock_wr_q <= 1'b0;

// mmc_clock_div [internal]
reg [7:0]  mmc_clock_div_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_clock_div_q <= 8'd`MMC_CLOCK_DIV_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CLOCK))
    mmc_clock_div_q <= cfg_wdata_i[`MMC_CLOCK_DIV_R];

wire [7:0]  mmc_clock_div_out_w = mmc_clock_div_q;


//-----------------------------------------------------------------
// Register mmc_status
//-----------------------------------------------------------------
reg mmc_status_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_status_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_STATUS))
    mmc_status_wr_q <= 1'b1;
else
    mmc_status_wr_q <= 1'b0;







//-----------------------------------------------------------------
// Register mmc_cmd0
//-----------------------------------------------------------------
reg mmc_cmd0_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_cmd0_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CMD0))
    mmc_cmd0_wr_q <= 1'b1;
else
    mmc_cmd0_wr_q <= 1'b0;

// mmc_cmd0_value [internal]
reg [31:0]  mmc_cmd0_value_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_cmd0_value_q <= 32'd`MMC_CMD0_VALUE_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CMD0))
    mmc_cmd0_value_q <= cfg_wdata_i[`MMC_CMD0_VALUE_R];

wire [31:0]  mmc_cmd0_value_out_w = mmc_cmd0_value_q;


//-----------------------------------------------------------------
// Register mmc_cmd1
//-----------------------------------------------------------------
reg mmc_cmd1_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_cmd1_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CMD1))
    mmc_cmd1_wr_q <= 1'b1;
else
    mmc_cmd1_wr_q <= 1'b0;

// mmc_cmd1_value [internal]
reg [15:0]  mmc_cmd1_value_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_cmd1_value_q <= 16'd`MMC_CMD1_VALUE_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_CMD1))
    mmc_cmd1_value_q <= cfg_wdata_i[`MMC_CMD1_VALUE_R];

wire [15:0]  mmc_cmd1_value_out_w = mmc_cmd1_value_q;


//-----------------------------------------------------------------
// Register mmc_resp0
//-----------------------------------------------------------------
reg mmc_resp0_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_resp0_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_RESP0))
    mmc_resp0_wr_q <= 1'b1;
else
    mmc_resp0_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register mmc_resp1
//-----------------------------------------------------------------
reg mmc_resp1_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_resp1_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_RESP1))
    mmc_resp1_wr_q <= 1'b1;
else
    mmc_resp1_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register mmc_resp2
//-----------------------------------------------------------------
reg mmc_resp2_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_resp2_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_RESP2))
    mmc_resp2_wr_q <= 1'b1;
else
    mmc_resp2_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register mmc_resp3
//-----------------------------------------------------------------
reg mmc_resp3_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_resp3_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_RESP3))
    mmc_resp3_wr_q <= 1'b1;
else
    mmc_resp3_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register mmc_resp4
//-----------------------------------------------------------------
reg mmc_resp4_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_resp4_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_RESP4))
    mmc_resp4_wr_q <= 1'b1;
else
    mmc_resp4_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register mmc_tx
//-----------------------------------------------------------------
reg mmc_tx_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_tx_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_TX))
    mmc_tx_wr_q <= 1'b1;
else
    mmc_tx_wr_q <= 1'b0;

// mmc_tx_data [external]
wire [31:0]  mmc_tx_data_out_w = wr_data_q[`MMC_TX_DATA_R];


//-----------------------------------------------------------------
// Register mmc_rx
//-----------------------------------------------------------------
reg mmc_rx_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_rx_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_RX))
    mmc_rx_wr_q <= 1'b1;
else
    mmc_rx_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register mmc_dma
//-----------------------------------------------------------------
reg mmc_dma_wr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_dma_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_DMA))
    mmc_dma_wr_q <= 1'b1;
else
    mmc_dma_wr_q <= 1'b0;

// mmc_dma_addr [internal]
reg [31:0]  mmc_dma_addr_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_dma_addr_q <= 32'd`MMC_DMA_ADDR_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `MMC_DMA))
    mmc_dma_addr_q <= cfg_wdata_i[`MMC_DMA_ADDR_R];

wire [31:0]  mmc_dma_addr_out_w = mmc_dma_addr_q;


wire        mmc_status_cmd_in_in_w;
wire [3:0]  mmc_status_dat_in_in_w;
wire        mmc_status_fifo_empty_in_w;
wire        mmc_status_fifo_full_in_w;
wire        mmc_status_crc_err_in_w;
wire        mmc_status_busy_in_w;
wire [31:0]  mmc_resp0_value_in_w;
wire [31:0]  mmc_resp1_value_in_w;
wire [31:0]  mmc_resp2_value_in_w;
wire [31:0]  mmc_resp3_value_in_w;
wire [31:0]  mmc_resp4_value_in_w;
wire [31:0]  mmc_rx_data_in_w;


//-----------------------------------------------------------------
// Read mux
//-----------------------------------------------------------------
reg [31:0] data_r;

always @ *
begin
    data_r = 32'b0;

    case (cfg_araddr_i[7:0])

    `MMC_CONTROL:
    begin
        data_r[`MMC_CONTROL_BLOCK_CNT_R] = mmc_control_block_cnt_q;
        data_r[`MMC_CONTROL_WRITE_R] = mmc_control_write_q;
        data_r[`MMC_CONTROL_DMA_EN_R] = mmc_control_dma_en_q;
        data_r[`MMC_CONTROL_WIDE_MODE_R] = mmc_control_wide_mode_q;
        data_r[`MMC_CONTROL_DATA_EXP_R] = mmc_control_data_exp_q;
        data_r[`MMC_CONTROL_RESP136_EXP_R] = mmc_control_resp136_exp_q;
        data_r[`MMC_CONTROL_RESP48_EXP_R] = mmc_control_resp48_exp_q;
    end
    `MMC_CLOCK:
    begin
        data_r[`MMC_CLOCK_DIV_R] = mmc_clock_div_q;
    end
    `MMC_STATUS:
    begin
        data_r[`MMC_STATUS_CMD_IN_R] = mmc_status_cmd_in_in_w;
        data_r[`MMC_STATUS_DAT_IN_R] = mmc_status_dat_in_in_w;
        data_r[`MMC_STATUS_FIFO_EMPTY_R] = mmc_status_fifo_empty_in_w;
        data_r[`MMC_STATUS_FIFO_FULL_R] = mmc_status_fifo_full_in_w;
        data_r[`MMC_STATUS_CRC_ERR_R] = mmc_status_crc_err_in_w;
        data_r[`MMC_STATUS_BUSY_R] = mmc_status_busy_in_w;
    end
    `MMC_CMD0:
    begin
        data_r[`MMC_CMD0_VALUE_R] = mmc_cmd0_value_q;
    end
    `MMC_CMD1:
    begin
        data_r[`MMC_CMD1_VALUE_R] = mmc_cmd1_value_q;
    end
    `MMC_RESP0:
    begin
        data_r[`MMC_RESP0_VALUE_R] = mmc_resp0_value_in_w;
    end
    `MMC_RESP1:
    begin
        data_r[`MMC_RESP1_VALUE_R] = mmc_resp1_value_in_w;
    end
    `MMC_RESP2:
    begin
        data_r[`MMC_RESP2_VALUE_R] = mmc_resp2_value_in_w;
    end
    `MMC_RESP3:
    begin
        data_r[`MMC_RESP3_VALUE_R] = mmc_resp3_value_in_w;
    end
    `MMC_RESP4:
    begin
        data_r[`MMC_RESP4_VALUE_R] = mmc_resp4_value_in_w;
    end
    `MMC_RX:
    begin
        data_r[`MMC_RX_DATA_R] = mmc_rx_data_in_w;
    end
    `MMC_DMA:
    begin
        data_r[`MMC_DMA_ADDR_R] = mmc_dma_addr_q;
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

wire mmc_rx_rd_req_w = read_en_w & (cfg_araddr_i[7:0] == `MMC_RX);

wire mmc_tx_wr_req_w = mmc_tx_wr_q;
wire mmc_rx_wr_req_w = mmc_rx_wr_q;

wire       start_w = mmc_control_start_out_w;

//-----------------------------------------------------------------
// SPI Clock Generator
//-----------------------------------------------------------------
wire [7:0] clk_div_w = mmc_clock_div_out_w;
reg [7:0]  clk_div_q;

always @ (posedge clk_i )
if (rst_i)
    clk_div_q <= 8'd0;
else if (clk_div_q == 8'd0)
    clk_div_q <= clk_div_w;
else
    clk_div_q <= clk_div_q - 8'd1;

wire clk_en_w     = (clk_div_q == 8'd0);

//-----------------------------------------------------------------
// State machine
//-----------------------------------------------------------------
localparam STATE_W          = 3;

// Current state
localparam STATE_IDLE       = 3'd0;
localparam STATE_CMD        = 3'd1;
localparam STATE_RESP       = 3'd2;
localparam STATE_DATA_IN    = 3'd3;
localparam STATE_DATA_OUT   = 3'd4;
localparam STATE_DMA        = 3'd5;

reg [STATE_W-1:0] state_q;
reg [STATE_W-1:0] next_state_r;

wire              cmd_complete_w;
wire              resp_complete_w;
wire              data_complete_w;
wire              write_complete_w;
wire              dma_complete_w;

always @ *
begin
    next_state_r = state_q;

    case (state_q)
    //-----------------------------------------
    // IDLE
    //-----------------------------------------
    STATE_IDLE :
    begin
        if (start_w)
            next_state_r  = STATE_CMD;
    end
    //-----------------------------------------
    // CMD
    //-----------------------------------------
    STATE_CMD:
    begin
        if (cmd_complete_w)
            next_state_r = (mmc_control_resp136_exp_out_w || mmc_control_resp48_exp_out_w) ?
                           STATE_RESP : STATE_IDLE;
    end
    //-----------------------------------------
    // RESP
    //-----------------------------------------
    STATE_RESP:
    begin
        if (resp_complete_w)
        begin
            if (mmc_control_data_exp_out_w)
                next_state_r = STATE_DATA_IN;
            else if (mmc_control_write_out_w)
                next_state_r = STATE_DATA_OUT;
            else
                next_state_r = STATE_IDLE;
        end
    end
    //-----------------------------------------
    // DATA_IN
    //-----------------------------------------
    STATE_DATA_IN:
    begin
        if (data_complete_w && mmc_control_dma_en_out_w)
            next_state_r = STATE_DMA;
        else if (data_complete_w)
            next_state_r = STATE_IDLE;
    end
    //-----------------------------------------
    // DMA
    //-----------------------------------------
    STATE_DMA:
    begin
        if (dma_complete_w)
            next_state_r = STATE_IDLE;
    end
    //-----------------------------------------
    // DATA_OUT
    //-----------------------------------------
    STATE_DATA_OUT:
    begin
        if (write_complete_w)
            next_state_r = STATE_IDLE;
    end
    default :
       ;

    endcase

    if (mmc_control_abort_out_w)
        next_state_r = STATE_IDLE;
end

// Update state
always @ (posedge clk_i )
if (rst_i)
    state_q <= STATE_IDLE;
else
    state_q <= next_state_r;

assign mmc_status_busy_in_w = (state_q != STATE_IDLE);

//-----------------------------------------------------------------
// Interrupt Output
//-----------------------------------------------------------------
reg intr_q;

always @ (posedge clk_i )
if (rst_i)
    intr_q <= 1'b0;
else
    intr_q <= (state_q != STATE_IDLE) && (next_state_r == STATE_IDLE);

assign intr_o = intr_q;

//-----------------------------------------------------------------
// Command Output
//-----------------------------------------------------------------
wire [47:0] cmd_w = {1'b0, 1'b1, mmc_cmd0_value_out_w[29:0], mmc_cmd1_value_out_w[15:8], 7'b0, 1'b1};

mmc_cmd_serialiser
u_cmd_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.bitclk_i(mmc_clk_o)
    ,.start_i(start_w)
    ,.abort_i(mmc_control_abort_out_w)
    ,.data_i(cmd_w)
    ,.cmd_o(mmc_cmd_out_o)
    ,.active_o(mmc_cmd_out_en_o)
    ,.complete_o(cmd_complete_w)
);    

//-----------------------------------------------------------------
// Response Input
//-----------------------------------------------------------------
wire [135:0] resp_w;

mmc_cmd_deserialiser
u_cmd_in
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.bitclk_i(mmc_clk_o)
    ,.start_i(state_q == STATE_CMD && next_state_r == STATE_RESP)
    ,.abort_i(mmc_control_abort_out_w)
    ,.data_i(mmc_cmd_in_i)
    ,.r2_mode_i(mmc_control_resp136_exp_out_w)
    ,.resp_o(resp_w)
    ,.active_o()
    ,.complete_o(resp_complete_w)
);    

assign mmc_resp0_value_in_w = resp_w[31:0];
assign mmc_resp1_value_in_w = resp_w[63:32];
assign mmc_resp2_value_in_w = resp_w[95:64];
assign mmc_resp3_value_in_w = resp_w[127:96];
assign mmc_resp4_value_in_w = {24'b0, resp_w[135:128]};


//-----------------------------------------------------------------
// Data Input
//-----------------------------------------------------------------
wire       rx_ready_w;
wire [7:0] rx_data0_w;
wire [7:0] rx_data1_w;
wire [7:0] rx_data2_w;
wire [7:0] rx_data3_w;

wire       data_start_w = state_q == STATE_RESP && next_state_r == STATE_DATA_IN;

mmc_dat_deserialiser
u_dat0_in
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_start_w)
    ,.abort_i(mmc_control_abort_out_w)
    ,.data_i(mmc_dat_in_i[0])
    ,.mode_4bit_i(mmc_control_wide_mode_out_w)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)

    ,.valid_o(rx_ready_w)
    ,.data_o(rx_data0_w)
    ,.active_o()
    ,.error_o()
    ,.complete_o(data_complete_w)
);

mmc_dat_deserialiser
u_dat1_in
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_start_w & mmc_control_wide_mode_out_w)
    ,.abort_i(mmc_control_abort_out_w)
    ,.data_i(mmc_dat_in_i[1])
    ,.mode_4bit_i(1'b1)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)

    ,.valid_o()
    ,.data_o(rx_data1_w)
    ,.active_o()
    ,.error_o()
    ,.complete_o()
);

mmc_dat_deserialiser
u_dat2_in
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_start_w & mmc_control_wide_mode_out_w)
    ,.abort_i(mmc_control_abort_out_w)
    ,.data_i(mmc_dat_in_i[2])
    ,.mode_4bit_i(1'b1)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)

    ,.valid_o()
    ,.data_o(rx_data2_w)
    ,.active_o()
    ,.error_o()
    ,.complete_o()
);

mmc_dat_deserialiser
u_dat3_in
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_start_w & mmc_control_wide_mode_out_w)
    ,.abort_i(mmc_control_abort_out_w)
    ,.data_i(mmc_dat_in_i[3])
    ,.mode_4bit_i(1'b1)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)

    ,.valid_o()
    ,.data_o(rx_data3_w)
    ,.active_o()
    ,.error_o()
    ,.complete_o()
);

wire [31:0] wide_data_w;

// Demange byte packed 4-bit
assign wide_data_w[0+0]  = rx_data0_w[6];
assign wide_data_w[0+1]  = rx_data1_w[6];
assign wide_data_w[0+2]  = rx_data2_w[6];
assign wide_data_w[0+3]  = rx_data3_w[6];
assign wide_data_w[0+4]  = rx_data0_w[7];
assign wide_data_w[0+5]  = rx_data1_w[7];
assign wide_data_w[0+6]  = rx_data2_w[7];
assign wide_data_w[0+7]  = rx_data3_w[7];
assign wide_data_w[8+0]  = rx_data0_w[4];
assign wide_data_w[8+1]  = rx_data1_w[4];
assign wide_data_w[8+2]  = rx_data2_w[4];
assign wide_data_w[8+3]  = rx_data3_w[4];
assign wide_data_w[8+4]  = rx_data0_w[5];
assign wide_data_w[8+5]  = rx_data1_w[5];
assign wide_data_w[8+6]  = rx_data2_w[5];
assign wide_data_w[8+7]  = rx_data3_w[5];
assign wide_data_w[16+0] = rx_data0_w[2];
assign wide_data_w[16+1] = rx_data1_w[2];
assign wide_data_w[16+2] = rx_data2_w[2];
assign wide_data_w[16+3] = rx_data3_w[2];
assign wide_data_w[16+4] = rx_data0_w[3];
assign wide_data_w[16+5] = rx_data1_w[3];
assign wide_data_w[16+6] = rx_data2_w[3];
assign wide_data_w[16+7] = rx_data3_w[3];
assign wide_data_w[24+0] = rx_data0_w[0];
assign wide_data_w[24+1] = rx_data1_w[0];
assign wide_data_w[24+2] = rx_data2_w[0];
assign wide_data_w[24+3] = rx_data3_w[0];
assign wide_data_w[24+4] = rx_data0_w[1];
assign wide_data_w[24+5] = rx_data1_w[1];
assign wide_data_w[24+6] = rx_data2_w[1];
assign wide_data_w[24+7] = rx_data3_w[1];

reg [31:0] rx_data_q;
reg [1:0]  rx_idx_q;
reg        rx_push_q;

always @ (posedge clk_i )
if (rst_i)
    rx_data_q <= 32'b0;
else if (mmc_control_wide_mode_out_w)
    rx_data_q <= wide_data_w;
else if (rx_ready_w)
    rx_data_q <= {rx_data0_w,rx_data_q[31:8]};

always @ (posedge clk_i )
if (rst_i)
    rx_idx_q <= 2'b0;
else if (state_q == STATE_RESP && next_state_r == STATE_DATA_IN)
    rx_idx_q <= 2'b0;
else if (rx_ready_w && !mmc_control_wide_mode_out_w)
    rx_idx_q <= rx_idx_q + 2'd1;

always @ (posedge clk_i )
if (rst_i)
    rx_push_q <= 1'b0;
else
    rx_push_q <= rx_ready_w && (mmc_control_wide_mode_out_w || (rx_idx_q == 2'd3));

//-----------------------------------------------------------------
// Data Output
//-----------------------------------------------------------------
wire       data_write_w = state_q == STATE_RESP && next_state_r == STATE_DATA_OUT;
wire       tx_ready_w;
reg [1:0]  tx_idx_q;

// Single data
wire [7:0] tx_data_w  = (tx_idx_q == 2'd0) ? fifo_data_out_w[7:0]   :
                        (tx_idx_q == 2'd1) ? fifo_data_out_w[15:8]  :
                        (tx_idx_q == 2'd2) ? fifo_data_out_w[23:16] :
                                             fifo_data_out_w[31:24];

// 4-bit data
wire [7:0] tx_data0_w;
wire [7:0] tx_data1_w;
wire [7:0] tx_data2_w;
wire [7:0] tx_data3_w;

assign tx_data0_w[6] = fifo_data_out_w[0+0];
assign tx_data1_w[6] = fifo_data_out_w[0+1];
assign tx_data2_w[6] = fifo_data_out_w[0+2];
assign tx_data3_w[6] = fifo_data_out_w[0+3];
assign tx_data0_w[7] = fifo_data_out_w[0+4];
assign tx_data1_w[7] = fifo_data_out_w[0+5];
assign tx_data2_w[7] = fifo_data_out_w[0+6];
assign tx_data3_w[7] = fifo_data_out_w[0+7];
assign tx_data0_w[4] = fifo_data_out_w[8+0];
assign tx_data1_w[4] = fifo_data_out_w[8+1];
assign tx_data2_w[4] = fifo_data_out_w[8+2];
assign tx_data3_w[4] = fifo_data_out_w[8+3];
assign tx_data0_w[5] = fifo_data_out_w[8+4];
assign tx_data1_w[5] = fifo_data_out_w[8+5];
assign tx_data2_w[5] = fifo_data_out_w[8+6];
assign tx_data3_w[5] = fifo_data_out_w[8+7];
assign tx_data0_w[2] = fifo_data_out_w[16+0];
assign tx_data1_w[2] = fifo_data_out_w[16+1];
assign tx_data2_w[2] = fifo_data_out_w[16+2];
assign tx_data3_w[2] = fifo_data_out_w[16+3];
assign tx_data0_w[3] = fifo_data_out_w[16+4];
assign tx_data1_w[3] = fifo_data_out_w[16+5];
assign tx_data2_w[3] = fifo_data_out_w[16+6];
assign tx_data3_w[3] = fifo_data_out_w[16+7];
assign tx_data0_w[0] = fifo_data_out_w[24+0];
assign tx_data1_w[0] = fifo_data_out_w[24+1];
assign tx_data2_w[0] = fifo_data_out_w[24+2];
assign tx_data3_w[0] = fifo_data_out_w[24+3];
assign tx_data0_w[1] = fifo_data_out_w[24+4];
assign tx_data1_w[1] = fifo_data_out_w[24+5];
assign tx_data2_w[1] = fifo_data_out_w[24+6];
assign tx_data3_w[1] = fifo_data_out_w[24+7];

always @ (posedge clk_i )
if (rst_i)
    tx_idx_q <= 2'b0;
else if (mmc_control_abort_out_w)
    tx_idx_q <= 2'b0;
else if (tx_ready_w && !mmc_control_wide_mode_out_w)
    tx_idx_q <= tx_idx_q + 2'd1;

mmc_dat_serialiser
u_dat0_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_write_w)
    ,.abort_i(mmc_control_abort_out_w)

    ,.data_i(mmc_control_wide_mode_out_w ? tx_data0_w : tx_data_w)
    ,.accept_o(tx_ready_w)

    ,.mode_4bit_i(mmc_control_wide_mode_out_w)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)
    ,.dat_o(mmc_dat_out_o[0])
    ,.dat_out_en_o(mmc_dat_out_en_o[0])
    ,.active_o()
    ,.complete_o(write_complete_w)
);

mmc_dat_serialiser
u_dat1_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_write_w & mmc_control_wide_mode_out_w)
    ,.abort_i(mmc_control_abort_out_w)

    ,.data_i(tx_data1_w)
    ,.accept_o()

    ,.mode_4bit_i(1'b1)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)
    ,.dat_o(mmc_dat_out_o[1])
    ,.dat_out_en_o(mmc_dat_out_en_o[1])
    ,.active_o()
    ,.complete_o()
);
mmc_dat_serialiser
u_dat2_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_write_w & mmc_control_wide_mode_out_w)
    ,.abort_i(mmc_control_abort_out_w)

    ,.data_i(tx_data2_w)
    ,.accept_o()

    ,.mode_4bit_i(1'b1)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)
    ,.dat_o(mmc_dat_out_o[2])
    ,.dat_out_en_o(mmc_dat_out_en_o[2])
    ,.active_o()
    ,.complete_o()
);
mmc_dat_serialiser
u_dat3_out
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.bitclk_i(mmc_clk_o)
    ,.start_i(data_write_w & mmc_control_wide_mode_out_w)
    ,.abort_i(mmc_control_abort_out_w)

    ,.data_i(tx_data3_w)
    ,.accept_o()

    ,.mode_4bit_i(1'b1)
    ,.block_cnt_i(mmc_control_block_cnt_out_w)
    ,.dat_o(mmc_dat_out_o[3])
    ,.dat_out_en_o(mmc_dat_out_en_o[3])
    ,.active_o()
    ,.complete_o()
);

reg tx_pop_q;

always @ (posedge clk_i )
if (rst_i)
    tx_pop_q <= 1'b0;
else
    tx_pop_q <= tx_ready_w && (mmc_control_wide_mode_out_w || (tx_idx_q == 2'd3));

//-----------------------------------------------------------------
// Shared FIFO
//-----------------------------------------------------------------
wire        rx_accept_w;
wire        rx_valid_w;

wire        fifo_push_w    = mmc_tx_wr_req_w | rx_push_q;
wire [31:0] fifo_data_in_w = mmc_tx_wr_req_w ? mmc_tx_data_out_w : rx_data_q;

wire        dma_pop_w;
wire        fifo_pop_w     = mmc_rx_rd_req_w | dma_pop_w | tx_pop_q;
wire [31:0] fifo_data_out_w;
wire [MMC_FIFO_DEPTH_W:0] fifo_level_w;

mmc_card_fifo
u_fifo
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.flush_i(mmc_control_fifo_rst_out_w)

    ,.push_i(fifo_push_w)
    ,.data_in_i(fifo_data_in_w)
    ,.accept_o(rx_accept_w)

    ,.valid_o(rx_valid_w)
    ,.data_out_o(fifo_data_out_w)
    ,.pop_i(fifo_pop_w)

    ,.level_o(fifo_level_w)
);

assign mmc_rx_data_in_w           = fifo_data_out_w;
assign mmc_status_fifo_empty_in_w = ~rx_valid_w;
assign mmc_status_fifo_full_in_w  = ~rx_accept_w;
assign mmc_status_crc_err_in_w    = 1'b0; // TODO: CRC checking

//-----------------------------------------------------------------
// Outputs
//-----------------------------------------------------------------
//synthesis attribute IOB of mmc_clk_q is "TRUE"
reg mmc_clk_q;

always @ (posedge clk_i )
if (rst_i)
    mmc_clk_q <= 1'b0;
else if (clk_en_w)
    mmc_clk_q <= ~mmc_clk_q;

assign mmc_clk_o             = mmc_clk_q;

//-----------------------------------------------------------------
// DMA
//-----------------------------------------------------------------

// Enough data for a burst
wire can_issue_w = mmc_control_dma_en_out_w && (fifo_level_w >= 8);
reg [2:0] burst_cnt_q;

always @ (posedge clk_i )
if (rst_i)
    burst_cnt_q <= 3'b0;
else if (start_w)
    burst_cnt_q <= 3'b0;
else if (outport_wvalid_o && outport_wready_i)
    burst_cnt_q <= burst_cnt_q + 3'd1;

reg [31:0] awaddr_q;
always @ (posedge clk_i )
if (rst_i)
    awaddr_q <= 32'b0;
else if (start_w)
    awaddr_q <= mmc_dma_addr_out_w;
else if (outport_awvalid_o && outport_awready_i)
    awaddr_q <= awaddr_q + {22'b0, outport_awlen_o, 2'b0} + 32'd4;

assign outport_awvalid_o = (burst_cnt_q == 3'd0) ? (can_issue_w & outport_wready_i) : 1'b0;
assign outport_awaddr_o  = awaddr_q;
assign outport_awlen_o   = 8'd7; // 32-bytes
assign outport_awburst_o = 2'b01; // INCR
assign outport_awid_o    = AXI_ID;

assign outport_wvalid_o = (burst_cnt_q == 3'd0) ? (can_issue_w & outport_awready_i) : 1'b1;
assign outport_wdata_o  = fifo_data_out_w;
assign outport_wstrb_o  = 4'hF;
assign outport_wlast_o  = burst_cnt_q == 3'd7;

// Pop FIFO
assign dma_pop_w        = outport_wvalid_o & outport_wready_i;

assign outport_rready_o = 1'b1;
assign outport_bready_o = 1'b1;

// Not yet
assign outport_arvalid_o = 1'b0;
assign outport_araddr_o  = 32'b0;
assign outport_arid_o    = 4'b0;
assign outport_arlen_o   = 8'b0;
assign outport_arburst_o = 2'b0;

reg [15:0] outstanding_q;
reg [15:0] outstanding_r;

always @ *
begin
    outstanding_r = outstanding_q;

    if (outport_awvalid_o && outport_awready_i)
        outstanding_r = outstanding_r + 16'd1;
    if (outport_bvalid_i && outport_bready_o)
        outstanding_r = outstanding_r - 16'd1;
end

always @ (posedge clk_i )
if (rst_i)
    outstanding_q <= 16'b0;
else
    outstanding_q <= outstanding_r;

assign dma_complete_w = ~((|fifo_level_w) || (|outstanding_q) || outport_awvalid_o || outport_wvalid_o);

//-----------------------------------------------------------------
// Input capture
//-----------------------------------------------------------------
reg clk_q;

always @ (posedge clk_i )
if (rst_i)
    clk_q <= 1'b0;
else
    clk_q <= mmc_clk_o;

// Capture on rising edge
wire capture_w = mmc_clk_o & ~clk_q;

reg       cmd_in_q;
reg [3:0] dat_in_q;

always @ (posedge clk_i )
if (rst_i)
    cmd_in_q <= 1'b1;
else if (capture_w)
    cmd_in_q <= mmc_cmd_in_i;

assign mmc_status_cmd_in_in_w = cmd_in_q;

always @ (posedge clk_i )
if (rst_i)
    dat_in_q <= 4'hF;
else if (capture_w)
    dat_in_q <= mmc_dat_in_i;

assign mmc_status_dat_in_in_w = dat_in_q;


endmodule
