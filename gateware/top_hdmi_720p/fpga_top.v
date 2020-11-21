//-----------------------------------------------------------------
//                      FPGA Media Player
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

module fpga_top
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter CLK_FREQ         = 60000000
    ,parameter BAUDRATE         = 1000000
    ,parameter UART_SPEED       = 1000000
    ,parameter C_SCK_RATIO      = 3
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           clk_sys_i
    ,input           clk_x5_i
    ,input           rst_i
    ,input           dbg_txd_i
    ,input           uart_rx_i
    ,input  [ 31:0]  gpio_input_i
    ,input           axi_awready_i
    ,input           axi_wready_i
    ,input           axi_bvalid_i
    ,input  [  1:0]  axi_bresp_i
    ,input  [  3:0]  axi_bid_i
    ,input           axi_arready_i
    ,input           axi_rvalid_i
    ,input  [ 31:0]  axi_rdata_i
    ,input  [  1:0]  axi_rresp_i
    ,input  [  3:0]  axi_rid_i
    ,input           axi_rlast_i
    ,input           mmc_cmd_in_i
    ,input  [  3:0]  mmc_dat_in_i

    // Outputs
    ,output          dbg_rxd_o
    ,output          uart_tx_o
    ,output [ 31:0]  gpio_output_o
    ,output [ 31:0]  gpio_output_enable_o
    ,output          axi_awvalid_o
    ,output [ 31:0]  axi_awaddr_o
    ,output [  3:0]  axi_awid_o
    ,output [  7:0]  axi_awlen_o
    ,output [  1:0]  axi_awburst_o
    ,output          axi_wvalid_o
    ,output [ 31:0]  axi_wdata_o
    ,output [  3:0]  axi_wstrb_o
    ,output          axi_wlast_o
    ,output          axi_bready_o
    ,output          axi_arvalid_o
    ,output [ 31:0]  axi_araddr_o
    ,output [  3:0]  axi_arid_o
    ,output [  7:0]  axi_arlen_o
    ,output [  1:0]  axi_arburst_o
    ,output          axi_rready_o
    ,output          dvi_red_o
    ,output          dvi_green_o
    ,output          dvi_blue_o
    ,output          dvi_clock_o
    ,output          mmc_clk_o
    ,output          mmc_cmd_out_o
    ,output          mmc_cmd_out_en_o
    ,output [  3:0]  mmc_dat_out_o
    ,output [  3:0]  mmc_dat_out_en_o
    ,output          spdif_o
    ,output          i2s_sck_o
    ,output          i2s_sdata_o
    ,output          i2s_ws_o
);

wire           axi_d_awvalid_w;
wire           jpeg_dma_retimed_bready_w;
wire           mmc_cfg_awvalid_w;
wire           axi_dist_inport_wvalid_w;
wire  [  3:0]  axi_d_awid_w;
wire           mem_inport_rvalid_w;
wire  [  1:0]  axi_i_arburst_w;
wire           jpeg_dma_bready_w;
wire  [  3:0]  axi_video_awid_w;
wire           bootrom_bvalid_w;
wire           mmc_cfg_rvalid_w;
wire           axi_dist_inport_bready_w;
wire  [  7:0]  axi_mmc_arlen_w;
wire           axi_video_mmc_retime_rvalid_w;
wire  [  7:0]  axi_mmc_awlen_w;
wire           ext1_cfg_wvalid_w;
wire  [  1:0]  axi_d_bresp_w;
wire           axi_video_wlast_w;
wire  [  3:0]  axi_video_mmc_retime_wstrb_w;
wire  [  7:0]  jpeg_dma_arlen_w;
wire  [  7:0]  mem_inport_arlen_w;
wire  [ 31:0]  mmc_cfg_rdata_w;
wire  [ 31:0]  jpeg_dma_rdata_w;
wire           axi_dist_inport_rvalid_w;
wire           axi_video_mmc_rlast_w;
wire           axi_cfg_awready_w;
wire  [ 31:0]  axi_dist_inport_awaddr_w;
wire  [ 31:0]  axi_t_awaddr_w;
wire  [  1:0]  axi_video_bresp_w;
wire           jpeg_dma_retimed_rready_w;
wire           axi_video_mmc_retime_rready_w;
wire           axi_cfg_awvalid_w;
wire           ext1_cfg_arready_w;
wire           jpeg_cfg_rready_w;
wire           jpeg_dma_wlast_w;
wire           ext1_cfg_rready_w;
wire           axi_mmc_rready_w;
wire  [  1:0]  mem_inport_arburst_w;
wire  [  3:0]  mem_inport_bid_w;
wire           axi_d_rvalid_w;
wire  [ 31:0]  bootrom_rdata_w;
wire  [ 31:0]  axi_dist_inport_araddr_w;
wire           mem_inport_rready_w;
wire  [ 31:0]  axi_i_wdata_w;
wire  [  1:0]  jpeg_dma_retimed_rresp_w;
wire  [  1:0]  bootrom_arburst_w;
wire  [  7:0]  mem_inport_awlen_w;
wire  [  1:0]  axi_t_bresp_w;
wire           jpeg_cfg_bready_w;
wire           jpeg_dma_arvalid_w;
wire           jpeg_dma_bvalid_w;
wire  [  3:0]  axi_dist_inport_awid_w;
wire  [  3:0]  axi_mmc_awid_w;
wire           bootrom_bready_w;
wire           jpeg_dma_awready_w;
wire           jpeg_cfg_arvalid_w;
wire  [  1:0]  axi_d_rresp_w;
wire  [  3:0]  axi_video_mmc_wstrb_w;
wire  [ 31:0]  axi_mmc_awaddr_w;
wire  [ 31:0]  axi_mmc_rdata_w;
wire           axi_video_mmc_bready_w;
wire  [  7:0]  axi_dist_inport_awlen_w;
wire  [  3:0]  jpeg_dma_retimed_rid_w;
wire  [  3:0]  jpeg_cfg_wstrb_w;
wire           axi_t_bready_w;
wire           axi_mmc_wvalid_w;
wire  [  1:0]  mem_inport_bresp_w;
wire  [  3:0]  mem_inport_awid_w;
wire           axi_dist_inport_arready_w;
wire  [  3:0]  jpeg_dma_rid_w;
wire           jpeg_dma_retimed_arready_w;
wire           axi_i_awvalid_w;
wire           axi_video_rready_w;
wire           axi_d_rlast_w;
wire           axi_t_arready_w;
wire  [  7:0]  axi_d_arlen_w;
wire           axi_cfg_rvalid_w;
wire           axi_video_arvalid_w;
wire  [  3:0]  axi_dist_inport_rid_w;
wire  [  7:0]  bootrom_awlen_w;
wire           axi_mmc_arvalid_w;
wire           axi_video_mmc_retime_awready_w;
wire  [  7:0]  jpeg_dma_awlen_w;
wire           axi_i_rlast_w;
wire  [  7:0]  bootrom_arlen_w;
wire           jpeg_dma_retimed_rvalid_w;
wire  [ 31:0]  axi_video_araddr_w;
wire           axi_video_bready_w;
wire  [  1:0]  jpeg_dma_arburst_w;
wire  [  7:0]  axi_i_awlen_w;
wire           axi_dist_inport_bvalid_w;
wire  [  1:0]  axi_video_arburst_w;
wire           axi_video_mmc_arvalid_w;
wire           bootrom_wready_w;
wire           mmc_cfg_arready_w;
wire           axi_video_bvalid_w;
wire           axi_video_mmc_retime_awvalid_w;
wire           axi_mmc_rlast_w;
wire  [  1:0]  axi_cfg_rresp_w;
wire  [  1:0]  axi_video_mmc_retime_rresp_w;
wire  [ 31:0]  axi_t_rdata_w;
wire  [  3:0]  axi_dist_inport_wstrb_w;
wire  [  1:0]  bootrom_awburst_w;
wire  [  3:0]  axi_mmc_rid_w;
wire  [ 31:0]  ext1_cfg_wdata_w;
wire  [  1:0]  axi_video_awburst_w;
wire           axi_mmc_awvalid_w;
wire           axi_video_mmc_awready_w;
wire  [  1:0]  axi_i_bresp_w;
wire  [  3:0]  axi_t_rid_w;
wire  [ 31:0]  axi_cfg_wdata_w;
wire  [  3:0]  axi_mmc_bid_w;
wire           axi_video_mmc_awvalid_w;
wire  [ 31:0]  jpeg_dma_araddr_w;
wire           axi_t_awvalid_w;
wire  [ 31:0]  axi_i_rdata_w;
wire  [  7:0]  axi_i_arlen_w;
wire           jpeg_dma_retimed_wvalid_w;
wire           mem_inport_wvalid_w;
wire           mem_inport_awready_w;
wire           jpeg_dma_rvalid_w;
wire           jpeg_dma_rlast_w;
wire           axi_i_arvalid_w;
wire           interrupt_w;
wire  [  3:0]  axi_video_wstrb_w;
wire  [  3:0]  axi_cfg_wstrb_w;
wire  [  3:0]  jpeg_dma_retimed_bid_w;
wire  [ 31:0]  axi_mmc_araddr_w;
wire           axi_video_mmc_retime_wvalid_w;
wire  [  3:0]  axi_t_wstrb_w;
wire           axi_video_rlast_w;
wire  [ 31:0]  axi_dist_inport_wdata_w;
wire  [  3:0]  bootrom_bid_w;
wire           jpeg_cfg_rvalid_w;
wire  [ 31:0]  jpeg_dma_retimed_awaddr_w;
wire  [  7:0]  jpeg_dma_retimed_awlen_w;
wire  [  3:0]  bootrom_awid_w;
wire           jpeg_dma_awvalid_w;
wire           axi_video_mmc_wready_w;
wire  [  7:0]  axi_video_arlen_w;
wire  [ 31:0]  axi_video_mmc_wdata_w;
wire           mmc_cfg_rready_w;
wire  [ 31:0]  axi_video_mmc_retime_araddr_w;
wire  [ 31:0]  axi_d_rdata_w;
wire           ext1_cfg_wready_w;
wire  [  3:0]  bootrom_rid_w;
wire  [  1:0]  axi_video_mmc_arburst_w;
wire  [ 31:0]  axi_video_rdata_w;
wire  [  3:0]  jpeg_dma_awid_w;
wire  [  1:0]  mmc_cfg_rresp_w;
wire           jpeg_dma_retimed_awvalid_w;
wire  [ 31:0]  axi_video_mmc_retime_rdata_w;
wire           axi_cfg_rready_w;
wire           axi_video_wvalid_w;
wire           bootrom_wlast_w;
wire           jpeg_dma_retimed_bvalid_w;
wire  [  3:0]  axi_t_arid_w;
wire  [  7:0]  axi_t_arlen_w;
wire  [  3:0]  axi_mmc_wstrb_w;
wire           axi_t_wvalid_w;
wire  [  1:0]  axi_i_awburst_w;
wire           ext1_cfg_awready_w;
wire  [  3:0]  axi_t_bid_w;
wire  [  7:0]  axi_t_awlen_w;
wire  [ 31:0]  axi_video_mmc_retime_wdata_w;
wire           axi_video_mmc_rready_w;
wire  [ 31:0]  reset_vector_w;
wire           axi_video_wready_w;
wire           axi_dist_inport_rready_w;
wire  [ 31:0]  axi_i_awaddr_w;
wire  [  7:0]  jpeg_dma_retimed_arlen_w;
wire  [ 31:0]  axi_video_mmc_araddr_w;
wire           jpeg_dma_retimed_wready_w;
wire           axi_i_awready_w;
wire  [ 31:0]  axi_i_araddr_w;
wire  [  3:0]  axi_d_rid_w;
wire           axi_t_bvalid_w;
wire           mem_inport_wready_w;
wire  [ 31:0]  jpeg_cfg_wdata_w;
wire  [ 31:0]  axi_video_awaddr_w;
wire  [  3:0]  jpeg_dma_wstrb_w;
wire           ext1_irq_w;
wire           axi_video_rvalid_w;
wire           axi_video_mmc_retime_arvalid_w;
wire  [  3:0]  mem_inport_arid_w;
wire  [  1:0]  bootrom_bresp_w;
wire           mem_inport_bvalid_w;
wire           axi_mmc_awready_w;
wire           axi_d_arready_w;
wire  [  7:0]  axi_video_mmc_retime_awlen_w;
wire           axi_video_mmc_retime_arready_w;
wire  [ 31:0]  axi_d_araddr_w;
wire           axi_cfg_wvalid_w;
wire  [ 31:0]  axi_video_mmc_retime_awaddr_w;
wire           mmc_irq_w;
wire  [ 31:0]  bootrom_araddr_w;
wire  [ 31:0]  axi_d_wdata_w;
wire  [ 31:0]  ext1_cfg_rdata_w;
wire  [  1:0]  axi_video_mmc_awburst_w;
wire           axi_cfg_wready_w;
wire           ext1_cfg_rvalid_w;
wire           axi_t_wlast_w;
wire           axi_t_arvalid_w;
wire           bootrom_arvalid_w;
wire  [  7:0]  axi_video_mmc_awlen_w;
wire  [  3:0]  axi_mmc_arid_w;
wire           axi_d_arvalid_w;
wire           axi_i_wready_w;
wire           axi_cfg_bvalid_w;
wire  [ 31:0]  ext1_cfg_araddr_w;
wire           axi_mmc_bready_w;
wire           axi_mmc_wlast_w;
wire  [  3:0]  axi_video_rid_w;
wire  [ 31:0]  axi_cfg_rdata_w;
wire  [  3:0]  axi_video_bid_w;
wire           axi_i_wvalid_w;
wire           rst_cpu_w;
wire  [ 31:0]  mem_inport_awaddr_w;
wire  [ 31:0]  jpeg_dma_retimed_wdata_w;
wire  [ 31:0]  axi_d_awaddr_w;
wire  [  1:0]  axi_dist_inport_rresp_w;
wire           axi_cfg_bready_w;
wire  [ 31:0]  mem_inport_rdata_w;
wire           axi_video_awvalid_w;
wire           axi_d_wlast_w;
wire  [  1:0]  axi_dist_inport_awburst_w;
wire  [  1:0]  mem_inport_rresp_w;
wire           axi_d_rready_w;
wire           bootrom_rlast_w;
wire  [  3:0]  jpeg_dma_retimed_arid_w;
wire  [  1:0]  axi_video_rresp_w;
wire           mem_inport_wlast_w;
wire           mmc_cfg_bvalid_w;
wire           jpeg_dma_retimed_wlast_w;
wire  [  3:0]  axi_video_mmc_bid_w;
wire  [  1:0]  bootrom_rresp_w;
wire  [ 31:0]  axi_cfg_araddr_w;
wire           jpeg_cfg_wready_w;
wire           axi_d_wready_w;
wire  [  1:0]  jpeg_dma_retimed_bresp_w;
wire           mem_inport_arready_w;
wire           axi_mmc_rvalid_w;
wire           ext1_cfg_bready_w;
wire  [  3:0]  axi_d_arid_w;
wire  [  3:0]  axi_video_mmc_rid_w;
wire  [ 31:0]  jpeg_dma_retimed_araddr_w;
wire  [  1:0]  jpeg_dma_retimed_arburst_w;
wire  [  3:0]  mmc_cfg_wstrb_w;
wire           axi_dist_inport_arvalid_w;
wire  [ 31:0]  ext1_cfg_awaddr_w;
wire  [  1:0]  ext1_cfg_rresp_w;
wire           axi_t_awready_w;
wire  [  3:0]  jpeg_dma_retimed_awid_w;
wire  [  1:0]  axi_t_rresp_w;
wire  [  1:0]  axi_mmc_arburst_w;
wire           jpeg_cfg_awready_w;
wire  [ 31:0]  axi_t_araddr_w;
wire           mmc_cfg_wready_w;
wire           jpeg_dma_retimed_rlast_w;
wire           jpeg_cfg_bvalid_w;
wire  [  3:0]  axi_video_mmc_retime_bid_w;
wire  [  1:0]  axi_video_mmc_retime_arburst_w;
wire           mmc_cfg_bready_w;
wire  [ 31:0]  jpeg_cfg_araddr_w;
wire  [  3:0]  axi_d_bid_w;
wire           axi_mmc_wready_w;
wire  [  3:0]  mem_inport_wstrb_w;
wire  [  1:0]  axi_d_awburst_w;
wire           jpeg_cfg_wvalid_w;
wire  [  3:0]  axi_i_awid_w;
wire           axi_dist_inport_wready_w;
wire           axi_dist_inport_awvalid_w;
wire           ext1_cfg_awvalid_w;
wire           axi_video_mmc_retime_bvalid_w;
wire  [  3:0]  axi_i_wstrb_w;
wire           axi_dist_inport_rlast_w;
wire  [ 31:0]  mmc_cfg_wdata_w;
wire  [  1:0]  axi_video_mmc_retime_awburst_w;
wire  [  3:0]  ext1_cfg_wstrb_w;
wire           ext1_cfg_bvalid_w;
wire  [  1:0]  axi_dist_inport_bresp_w;
wire           jpeg_cfg_awvalid_w;
wire  [ 31:0]  mem_inport_araddr_w;
wire  [ 31:0]  bootrom_wdata_w;
wire           axi_dist_inport_wlast_w;
wire  [  7:0]  axi_dist_inport_arlen_w;
wire  [  3:0]  axi_video_mmc_awid_w;
wire           axi_d_bready_w;
wire  [  1:0]  axi_mmc_awburst_w;
wire  [ 31:0]  axi_cfg_awaddr_w;
wire           jpeg_dma_retimed_awready_w;
wire           axi_video_mmc_wvalid_w;
wire  [  1:0]  axi_cfg_bresp_w;
wire  [  1:0]  axi_video_mmc_retime_bresp_w;
wire           axi_cfg_arready_w;
wire  [  1:0]  mmc_cfg_bresp_w;
wire           axi_mmc_bvalid_w;
wire  [  1:0]  axi_i_rresp_w;
wire  [  3:0]  jpeg_dma_bid_w;
wire  [  1:0]  jpeg_dma_awburst_w;
wire           jpeg_dma_rready_w;
wire           mem_inport_bready_w;
wire           axi_i_rvalid_w;
wire  [  7:0]  axi_d_awlen_w;
wire           axi_video_mmc_retime_wready_w;
wire  [ 31:0]  jpeg_dma_retimed_rdata_w;
wire           axi_d_awready_w;
wire  [  3:0]  bootrom_arid_w;
wire  [  3:0]  axi_video_mmc_retime_rid_w;
wire           axi_video_mmc_retime_wlast_w;
wire  [  3:0]  bootrom_wstrb_w;
wire  [ 31:0]  axi_dist_inport_rdata_w;
wire           ext1_cfg_arvalid_w;
wire  [  1:0]  ext1_cfg_bresp_w;
wire  [  1:0]  axi_t_awburst_w;
wire  [  7:0]  axi_video_mmc_retime_arlen_w;
wire           axi_i_rready_w;
wire  [  1:0]  axi_mmc_bresp_w;
wire  [ 31:0]  axi_t_wdata_w;
wire           axi_t_rlast_w;
wire  [ 31:0]  jpeg_cfg_awaddr_w;
wire           axi_d_wvalid_w;
wire           axi_t_rready_w;
wire           axi_cfg_arvalid_w;
wire  [  1:0]  jpeg_cfg_bresp_w;
wire           axi_i_wlast_w;
wire           jpeg_dma_retimed_arvalid_w;
wire  [  3:0]  axi_i_bid_w;
wire           jpeg_dma_wvalid_w;
wire  [ 31:0]  axi_mmc_wdata_w;
wire           bootrom_awvalid_w;
wire  [  1:0]  axi_video_mmc_bresp_w;
wire           axi_video_mmc_arready_w;
wire           jpeg_dma_wready_w;
wire           bootrom_awready_w;
wire  [ 31:0]  axi_video_mmc_rdata_w;
wire  [  3:0]  axi_t_awid_w;
wire           axi_video_mmc_retime_bready_w;
wire  [  7:0]  axi_video_mmc_arlen_w;
wire           axi_i_bvalid_w;
wire  [  3:0]  mem_inport_rid_w;
wire           mem_inport_awvalid_w;
wire  [  7:0]  axi_video_awlen_w;
wire  [  3:0]  axi_video_mmc_retime_awid_w;
wire           mem_inport_arvalid_w;
wire  [  1:0]  jpeg_dma_rresp_w;
wire           axi_i_arready_w;
wire  [ 31:0]  jpeg_dma_awaddr_w;
wire           axi_video_awready_w;
wire           axi_i_bready_w;
wire  [  1:0]  axi_d_arburst_w;
wire  [ 31:0]  mmc_cfg_awaddr_w;
wire  [ 31:0]  mem_inport_wdata_w;
wire           axi_dist_inport_awready_w;
wire           mmc_cfg_arvalid_w;
wire           axi_video_mmc_retime_rlast_w;
wire  [ 31:0]  axi_video_mmc_awaddr_w;
wire  [  3:0]  axi_i_rid_w;
wire           axi_d_bvalid_w;
wire           axi_video_mmc_rvalid_w;
wire  [  1:0]  jpeg_dma_retimed_awburst_w;
wire  [  1:0]  axi_mmc_rresp_w;
wire  [  3:0]  axi_dist_inport_bid_w;
wire  [  3:0]  jpeg_dma_arid_w;
wire           mmc_cfg_wvalid_w;
wire           bootrom_wvalid_w;
wire  [ 31:0]  axi_video_wdata_w;
wire  [  1:0]  axi_t_arburst_w;
wire  [  1:0]  axi_video_mmc_rresp_w;
wire  [ 31:0]  jpeg_dma_wdata_w;
wire  [  1:0]  jpeg_cfg_rresp_w;
wire  [  3:0]  axi_dist_inport_arid_w;
wire  [ 31:0]  enable_w;
wire           bootrom_arready_w;
wire  [  3:0]  jpeg_dma_retimed_wstrb_w;
wire  [ 31:0]  bootrom_awaddr_w;
wire           mmc_cfg_awready_w;
wire  [  3:0]  axi_video_mmc_arid_w;
wire  [  3:0]  axi_d_wstrb_w;
wire           axi_t_rvalid_w;
wire           axi_mmc_arready_w;
wire  [  1:0]  axi_dist_inport_arburst_w;
wire           axi_video_mmc_wlast_w;
wire           mem_inport_rlast_w;
wire           jpeg_dma_arready_w;
wire  [ 31:0]  jpeg_cfg_rdata_w;
wire  [  3:0]  axi_video_mmc_retime_arid_w;
wire           axi_video_arready_w;
wire  [  3:0]  axi_video_arid_w;
wire  [  1:0]  jpeg_dma_bresp_w;
wire  [  3:0]  axi_i_arid_w;
wire           axi_video_mmc_bvalid_w;
wire           axi_t_wready_w;
wire           bootrom_rvalid_w;
wire  [ 31:0]  mmc_cfg_araddr_w;
wire  [  1:0]  mem_inport_awburst_w;
wire           bootrom_rready_w;
wire           jpeg_cfg_arready_w;


axi4_dist
u_mem_dist
(
    // Inputs
     .clk_i(clk_sys_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(mem_inport_awvalid_w)
    ,.inport_awaddr_i(mem_inport_awaddr_w)
    ,.inport_awid_i(mem_inport_awid_w)
    ,.inport_awlen_i(mem_inport_awlen_w)
    ,.inport_awburst_i(mem_inport_awburst_w)
    ,.inport_wvalid_i(mem_inport_wvalid_w)
    ,.inport_wdata_i(mem_inport_wdata_w)
    ,.inport_wstrb_i(mem_inport_wstrb_w)
    ,.inport_wlast_i(mem_inport_wlast_w)
    ,.inport_bready_i(mem_inport_bready_w)
    ,.inport_arvalid_i(mem_inport_arvalid_w)
    ,.inport_araddr_i(mem_inport_araddr_w)
    ,.inport_arid_i(mem_inport_arid_w)
    ,.inport_arlen_i(mem_inport_arlen_w)
    ,.inport_arburst_i(mem_inport_arburst_w)
    ,.inport_rready_i(mem_inport_rready_w)
    ,.outport0_awready_i(axi_awready_i)
    ,.outport0_wready_i(axi_wready_i)
    ,.outport0_bvalid_i(axi_bvalid_i)
    ,.outport0_bresp_i(axi_bresp_i)
    ,.outport0_bid_i(axi_bid_i)
    ,.outport0_arready_i(axi_arready_i)
    ,.outport0_rvalid_i(axi_rvalid_i)
    ,.outport0_rdata_i(axi_rdata_i)
    ,.outport0_rresp_i(axi_rresp_i)
    ,.outport0_rid_i(axi_rid_i)
    ,.outport0_rlast_i(axi_rlast_i)
    ,.outport1_awready_i(bootrom_awready_w)
    ,.outport1_wready_i(bootrom_wready_w)
    ,.outport1_bvalid_i(bootrom_bvalid_w)
    ,.outport1_bresp_i(bootrom_bresp_w)
    ,.outport1_bid_i(bootrom_bid_w)
    ,.outport1_arready_i(bootrom_arready_w)
    ,.outport1_rvalid_i(bootrom_rvalid_w)
    ,.outport1_rdata_i(bootrom_rdata_w)
    ,.outport1_rresp_i(bootrom_rresp_w)
    ,.outport1_rid_i(bootrom_rid_w)
    ,.outport1_rlast_i(bootrom_rlast_w)

    // Outputs
    ,.inport_awready_o(mem_inport_awready_w)
    ,.inport_wready_o(mem_inport_wready_w)
    ,.inport_bvalid_o(mem_inport_bvalid_w)
    ,.inport_bresp_o(mem_inport_bresp_w)
    ,.inport_bid_o(mem_inport_bid_w)
    ,.inport_arready_o(mem_inport_arready_w)
    ,.inport_rvalid_o(mem_inport_rvalid_w)
    ,.inport_rdata_o(mem_inport_rdata_w)
    ,.inport_rresp_o(mem_inport_rresp_w)
    ,.inport_rid_o(mem_inport_rid_w)
    ,.inport_rlast_o(mem_inport_rlast_w)
    ,.outport0_awvalid_o(axi_awvalid_o)
    ,.outport0_awaddr_o(axi_awaddr_o)
    ,.outport0_awid_o(axi_awid_o)
    ,.outport0_awlen_o(axi_awlen_o)
    ,.outport0_awburst_o(axi_awburst_o)
    ,.outport0_wvalid_o(axi_wvalid_o)
    ,.outport0_wdata_o(axi_wdata_o)
    ,.outport0_wstrb_o(axi_wstrb_o)
    ,.outport0_wlast_o(axi_wlast_o)
    ,.outport0_bready_o(axi_bready_o)
    ,.outport0_arvalid_o(axi_arvalid_o)
    ,.outport0_araddr_o(axi_araddr_o)
    ,.outport0_arid_o(axi_arid_o)
    ,.outport0_arlen_o(axi_arlen_o)
    ,.outport0_arburst_o(axi_arburst_o)
    ,.outport0_rready_o(axi_rready_o)
    ,.outport1_awvalid_o(bootrom_awvalid_w)
    ,.outport1_awaddr_o(bootrom_awaddr_w)
    ,.outport1_awid_o(bootrom_awid_w)
    ,.outport1_awlen_o(bootrom_awlen_w)
    ,.outport1_awburst_o(bootrom_awburst_w)
    ,.outport1_wvalid_o(bootrom_wvalid_w)
    ,.outport1_wdata_o(bootrom_wdata_w)
    ,.outport1_wstrb_o(bootrom_wstrb_w)
    ,.outport1_wlast_o(bootrom_wlast_w)
    ,.outport1_bready_o(bootrom_bready_w)
    ,.outport1_arvalid_o(bootrom_arvalid_w)
    ,.outport1_araddr_o(bootrom_araddr_w)
    ,.outport1_arid_o(bootrom_arid_w)
    ,.outport1_arlen_o(bootrom_arlen_w)
    ,.outport1_arburst_o(bootrom_arburst_w)
    ,.outport1_rready_o(bootrom_rready_w)
);


axi4_cdc
u_cdc
(
    // Inputs
     .wr_clk_i(clk_i)
    ,.wr_rst_i(rst_i)
    ,.inport_awvalid_i(axi_dist_inport_awvalid_w)
    ,.inport_awaddr_i(axi_dist_inport_awaddr_w)
    ,.inport_awid_i(axi_dist_inport_awid_w)
    ,.inport_awlen_i(axi_dist_inport_awlen_w)
    ,.inport_awburst_i(axi_dist_inport_awburst_w)
    ,.inport_wvalid_i(axi_dist_inport_wvalid_w)
    ,.inport_wdata_i(axi_dist_inport_wdata_w)
    ,.inport_wstrb_i(axi_dist_inport_wstrb_w)
    ,.inport_wlast_i(axi_dist_inport_wlast_w)
    ,.inport_bready_i(axi_dist_inport_bready_w)
    ,.inport_arvalid_i(axi_dist_inport_arvalid_w)
    ,.inport_araddr_i(axi_dist_inport_araddr_w)
    ,.inport_arid_i(axi_dist_inport_arid_w)
    ,.inport_arlen_i(axi_dist_inport_arlen_w)
    ,.inport_arburst_i(axi_dist_inport_arburst_w)
    ,.inport_rready_i(axi_dist_inport_rready_w)
    ,.rd_clk_i(clk_sys_i)
    ,.rd_rst_i(rst_i)
    ,.outport_awready_i(mem_inport_awready_w)
    ,.outport_wready_i(mem_inport_wready_w)
    ,.outport_bvalid_i(mem_inport_bvalid_w)
    ,.outport_bresp_i(mem_inport_bresp_w)
    ,.outport_bid_i(mem_inport_bid_w)
    ,.outport_arready_i(mem_inport_arready_w)
    ,.outport_rvalid_i(mem_inport_rvalid_w)
    ,.outport_rdata_i(mem_inport_rdata_w)
    ,.outport_rresp_i(mem_inport_rresp_w)
    ,.outport_rid_i(mem_inport_rid_w)
    ,.outport_rlast_i(mem_inport_rlast_w)

    // Outputs
    ,.inport_awready_o(axi_dist_inport_awready_w)
    ,.inport_wready_o(axi_dist_inport_wready_w)
    ,.inport_bvalid_o(axi_dist_inport_bvalid_w)
    ,.inport_bresp_o(axi_dist_inport_bresp_w)
    ,.inport_bid_o(axi_dist_inport_bid_w)
    ,.inport_arready_o(axi_dist_inport_arready_w)
    ,.inport_rvalid_o(axi_dist_inport_rvalid_w)
    ,.inport_rdata_o(axi_dist_inport_rdata_w)
    ,.inport_rresp_o(axi_dist_inport_rresp_w)
    ,.inport_rid_o(axi_dist_inport_rid_w)
    ,.inport_rlast_o(axi_dist_inport_rlast_w)
    ,.outport_awvalid_o(mem_inport_awvalid_w)
    ,.outport_awaddr_o(mem_inport_awaddr_w)
    ,.outport_awid_o(mem_inport_awid_w)
    ,.outport_awlen_o(mem_inport_awlen_w)
    ,.outport_awburst_o(mem_inport_awburst_w)
    ,.outport_wvalid_o(mem_inport_wvalid_w)
    ,.outport_wdata_o(mem_inport_wdata_w)
    ,.outport_wstrb_o(mem_inport_wstrb_w)
    ,.outport_wlast_o(mem_inport_wlast_w)
    ,.outport_bready_o(mem_inport_bready_w)
    ,.outport_arvalid_o(mem_inport_arvalid_w)
    ,.outport_araddr_o(mem_inport_araddr_w)
    ,.outport_arid_o(mem_inport_arid_w)
    ,.outport_arlen_o(mem_inport_arlen_w)
    ,.outport_arburst_o(mem_inport_arburst_w)
    ,.outport_rready_o(mem_inport_rready_w)
);


dvi_framebuffer
#(
     .VIDEO_FB_RAM('h3000000)
    ,.VIDEO_X2_MODE(0)
    ,.VIDEO_HEIGHT(720)
    ,.VIDEO_REFRESH(50)
    ,.VIDEO_WIDTH(1280)
    ,.VIDEO_ENABLE(1)
)
u_dvi
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.clk_x5_i(clk_x5_i)
    ,.cfg_awvalid_i(ext1_cfg_awvalid_w)
    ,.cfg_awaddr_i(ext1_cfg_awaddr_w)
    ,.cfg_wvalid_i(ext1_cfg_wvalid_w)
    ,.cfg_wdata_i(ext1_cfg_wdata_w)
    ,.cfg_wstrb_i(ext1_cfg_wstrb_w)
    ,.cfg_bready_i(ext1_cfg_bready_w)
    ,.cfg_arvalid_i(ext1_cfg_arvalid_w)
    ,.cfg_araddr_i(ext1_cfg_araddr_w)
    ,.cfg_rready_i(ext1_cfg_rready_w)
    ,.outport_awready_i(axi_video_awready_w)
    ,.outport_wready_i(axi_video_wready_w)
    ,.outport_bvalid_i(axi_video_bvalid_w)
    ,.outport_bresp_i(axi_video_bresp_w)
    ,.outport_bid_i(axi_video_bid_w)
    ,.outport_arready_i(axi_video_arready_w)
    ,.outport_rvalid_i(axi_video_rvalid_w)
    ,.outport_rdata_i(axi_video_rdata_w)
    ,.outport_rresp_i(axi_video_rresp_w)
    ,.outport_rid_i(axi_video_rid_w)
    ,.outport_rlast_i(axi_video_rlast_w)

    // Outputs
    ,.cfg_awready_o(ext1_cfg_awready_w)
    ,.cfg_wready_o(ext1_cfg_wready_w)
    ,.cfg_bvalid_o(ext1_cfg_bvalid_w)
    ,.cfg_bresp_o(ext1_cfg_bresp_w)
    ,.cfg_arready_o(ext1_cfg_arready_w)
    ,.cfg_rvalid_o(ext1_cfg_rvalid_w)
    ,.cfg_rdata_o(ext1_cfg_rdata_w)
    ,.cfg_rresp_o(ext1_cfg_rresp_w)
    ,.intr_o(ext1_irq_w)
    ,.outport_awvalid_o(axi_video_awvalid_w)
    ,.outport_awaddr_o(axi_video_awaddr_w)
    ,.outport_awid_o(axi_video_awid_w)
    ,.outport_awlen_o(axi_video_awlen_w)
    ,.outport_awburst_o(axi_video_awburst_w)
    ,.outport_wvalid_o(axi_video_wvalid_w)
    ,.outport_wdata_o(axi_video_wdata_w)
    ,.outport_wstrb_o(axi_video_wstrb_w)
    ,.outport_wlast_o(axi_video_wlast_w)
    ,.outport_bready_o(axi_video_bready_w)
    ,.outport_arvalid_o(axi_video_arvalid_w)
    ,.outport_araddr_o(axi_video_araddr_w)
    ,.outport_arid_o(axi_video_arid_w)
    ,.outport_arlen_o(axi_video_arlen_w)
    ,.outport_arburst_o(axi_video_arburst_w)
    ,.outport_rready_o(axi_video_rready_w)
    ,.dvi_red_o(dvi_red_o)
    ,.dvi_green_o(dvi_green_o)
    ,.dvi_blue_o(dvi_blue_o)
    ,.dvi_clock_o(dvi_clock_o)
);


core_soc
#(
     .CLK_FREQ(CLK_FREQ)
    ,.BAUDRATE(BAUDRATE)
    ,.C_SCK_RATIO(C_SCK_RATIO)
)
u_soc
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi_cfg_awvalid_w)
    ,.inport_awaddr_i(axi_cfg_awaddr_w)
    ,.inport_wvalid_i(axi_cfg_wvalid_w)
    ,.inport_wdata_i(axi_cfg_wdata_w)
    ,.inport_wstrb_i(axi_cfg_wstrb_w)
    ,.inport_bready_i(axi_cfg_bready_w)
    ,.inport_arvalid_i(axi_cfg_arvalid_w)
    ,.inport_araddr_i(axi_cfg_araddr_w)
    ,.inport_rready_i(axi_cfg_rready_w)
    ,.uart_rx_i(uart_rx_i)
    ,.gpio_input_i(gpio_input_i)
    ,.ext1_cfg_awready_i(ext1_cfg_awready_w)
    ,.ext1_cfg_wready_i(ext1_cfg_wready_w)
    ,.ext1_cfg_bvalid_i(ext1_cfg_bvalid_w)
    ,.ext1_cfg_bresp_i(ext1_cfg_bresp_w)
    ,.ext1_cfg_arready_i(ext1_cfg_arready_w)
    ,.ext1_cfg_rvalid_i(ext1_cfg_rvalid_w)
    ,.ext1_cfg_rdata_i(ext1_cfg_rdata_w)
    ,.ext1_cfg_rresp_i(ext1_cfg_rresp_w)
    ,.ext1_irq_i(ext1_irq_w)
    ,.ext2_cfg_awready_i(mmc_cfg_awready_w)
    ,.ext2_cfg_wready_i(mmc_cfg_wready_w)
    ,.ext2_cfg_bvalid_i(mmc_cfg_bvalid_w)
    ,.ext2_cfg_bresp_i(mmc_cfg_bresp_w)
    ,.ext2_cfg_arready_i(mmc_cfg_arready_w)
    ,.ext2_cfg_rvalid_i(mmc_cfg_rvalid_w)
    ,.ext2_cfg_rdata_i(mmc_cfg_rdata_w)
    ,.ext2_cfg_rresp_i(mmc_cfg_rresp_w)
    ,.ext2_irq_i(mmc_irq_w)
    ,.ext3_cfg_awready_i(jpeg_cfg_awready_w)
    ,.ext3_cfg_wready_i(jpeg_cfg_wready_w)
    ,.ext3_cfg_bvalid_i(jpeg_cfg_bvalid_w)
    ,.ext3_cfg_bresp_i(jpeg_cfg_bresp_w)
    ,.ext3_cfg_arready_i(jpeg_cfg_arready_w)
    ,.ext3_cfg_rvalid_i(jpeg_cfg_rvalid_w)
    ,.ext3_cfg_rdata_i(jpeg_cfg_rdata_w)
    ,.ext3_cfg_rresp_i(jpeg_cfg_rresp_w)
    ,.ext3_irq_i(1'b0)

    // Outputs
    ,.intr_o(interrupt_w)
    ,.inport_awready_o(axi_cfg_awready_w)
    ,.inport_wready_o(axi_cfg_wready_w)
    ,.inport_bvalid_o(axi_cfg_bvalid_w)
    ,.inport_bresp_o(axi_cfg_bresp_w)
    ,.inport_arready_o(axi_cfg_arready_w)
    ,.inport_rvalid_o(axi_cfg_rvalid_w)
    ,.inport_rdata_o(axi_cfg_rdata_w)
    ,.inport_rresp_o(axi_cfg_rresp_w)
    ,.uart_tx_o(uart_tx_o)
    ,.gpio_output_o(gpio_output_o)
    ,.gpio_output_enable_o(gpio_output_enable_o)
    ,.spdif_o(spdif_o)
    ,.i2s_sck_o(i2s_sck_o)
    ,.i2s_sdata_o(i2s_sdata_o)
    ,.i2s_ws_o(i2s_ws_o)
    ,.ext1_cfg_awvalid_o(ext1_cfg_awvalid_w)
    ,.ext1_cfg_awaddr_o(ext1_cfg_awaddr_w)
    ,.ext1_cfg_wvalid_o(ext1_cfg_wvalid_w)
    ,.ext1_cfg_wdata_o(ext1_cfg_wdata_w)
    ,.ext1_cfg_wstrb_o(ext1_cfg_wstrb_w)
    ,.ext1_cfg_bready_o(ext1_cfg_bready_w)
    ,.ext1_cfg_arvalid_o(ext1_cfg_arvalid_w)
    ,.ext1_cfg_araddr_o(ext1_cfg_araddr_w)
    ,.ext1_cfg_rready_o(ext1_cfg_rready_w)
    ,.ext2_cfg_awvalid_o(mmc_cfg_awvalid_w)
    ,.ext2_cfg_awaddr_o(mmc_cfg_awaddr_w)
    ,.ext2_cfg_wvalid_o(mmc_cfg_wvalid_w)
    ,.ext2_cfg_wdata_o(mmc_cfg_wdata_w)
    ,.ext2_cfg_wstrb_o(mmc_cfg_wstrb_w)
    ,.ext2_cfg_bready_o(mmc_cfg_bready_w)
    ,.ext2_cfg_arvalid_o(mmc_cfg_arvalid_w)
    ,.ext2_cfg_araddr_o(mmc_cfg_araddr_w)
    ,.ext2_cfg_rready_o(mmc_cfg_rready_w)
    ,.ext3_cfg_awvalid_o(jpeg_cfg_awvalid_w)
    ,.ext3_cfg_awaddr_o(jpeg_cfg_awaddr_w)
    ,.ext3_cfg_wvalid_o(jpeg_cfg_wvalid_w)
    ,.ext3_cfg_wdata_o(jpeg_cfg_wdata_w)
    ,.ext3_cfg_wstrb_o(jpeg_cfg_wstrb_w)
    ,.ext3_cfg_bready_o(jpeg_cfg_bready_w)
    ,.ext3_cfg_arvalid_o(jpeg_cfg_arvalid_w)
    ,.ext3_cfg_araddr_o(jpeg_cfg_araddr_w)
    ,.ext3_cfg_rready_o(jpeg_cfg_rready_w)
);


axi4_join
u_join
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_wr_awvalid_i(axi_mmc_awvalid_w)
    ,.inport_wr_awaddr_i(axi_mmc_awaddr_w)
    ,.inport_wr_awid_i(axi_mmc_awid_w)
    ,.inport_wr_awlen_i(axi_mmc_awlen_w)
    ,.inport_wr_awburst_i(axi_mmc_awburst_w)
    ,.inport_wr_wvalid_i(axi_mmc_wvalid_w)
    ,.inport_wr_wdata_i(axi_mmc_wdata_w)
    ,.inport_wr_wstrb_i(axi_mmc_wstrb_w)
    ,.inport_wr_wlast_i(axi_mmc_wlast_w)
    ,.inport_wr_bready_i(axi_mmc_bready_w)
    ,.inport_wr_arvalid_i(axi_mmc_arvalid_w)
    ,.inport_wr_araddr_i(axi_mmc_araddr_w)
    ,.inport_wr_arid_i(axi_mmc_arid_w)
    ,.inport_wr_arlen_i(axi_mmc_arlen_w)
    ,.inport_wr_arburst_i(axi_mmc_arburst_w)
    ,.inport_wr_rready_i(axi_mmc_rready_w)
    ,.inport_rd_awvalid_i(axi_video_awvalid_w)
    ,.inport_rd_awaddr_i(axi_video_awaddr_w)
    ,.inport_rd_awid_i(axi_video_awid_w)
    ,.inport_rd_awlen_i(axi_video_awlen_w)
    ,.inport_rd_awburst_i(axi_video_awburst_w)
    ,.inport_rd_wvalid_i(axi_video_wvalid_w)
    ,.inport_rd_wdata_i(axi_video_wdata_w)
    ,.inport_rd_wstrb_i(axi_video_wstrb_w)
    ,.inport_rd_wlast_i(axi_video_wlast_w)
    ,.inport_rd_bready_i(axi_video_bready_w)
    ,.inport_rd_arvalid_i(axi_video_arvalid_w)
    ,.inport_rd_araddr_i(axi_video_araddr_w)
    ,.inport_rd_arid_i(axi_video_arid_w)
    ,.inport_rd_arlen_i(axi_video_arlen_w)
    ,.inport_rd_arburst_i(axi_video_arburst_w)
    ,.inport_rd_rready_i(axi_video_rready_w)
    ,.outport_awready_i(axi_video_mmc_awready_w)
    ,.outport_wready_i(axi_video_mmc_wready_w)
    ,.outport_bvalid_i(axi_video_mmc_bvalid_w)
    ,.outport_bresp_i(axi_video_mmc_bresp_w)
    ,.outport_bid_i(axi_video_mmc_bid_w)
    ,.outport_arready_i(axi_video_mmc_arready_w)
    ,.outport_rvalid_i(axi_video_mmc_rvalid_w)
    ,.outport_rdata_i(axi_video_mmc_rdata_w)
    ,.outport_rresp_i(axi_video_mmc_rresp_w)
    ,.outport_rid_i(axi_video_mmc_rid_w)
    ,.outport_rlast_i(axi_video_mmc_rlast_w)

    // Outputs
    ,.inport_wr_awready_o(axi_mmc_awready_w)
    ,.inport_wr_wready_o(axi_mmc_wready_w)
    ,.inport_wr_bvalid_o(axi_mmc_bvalid_w)
    ,.inport_wr_bresp_o(axi_mmc_bresp_w)
    ,.inport_wr_bid_o(axi_mmc_bid_w)
    ,.inport_wr_arready_o(axi_mmc_arready_w)
    ,.inport_wr_rvalid_o(axi_mmc_rvalid_w)
    ,.inport_wr_rdata_o(axi_mmc_rdata_w)
    ,.inport_wr_rresp_o(axi_mmc_rresp_w)
    ,.inport_wr_rid_o(axi_mmc_rid_w)
    ,.inport_wr_rlast_o(axi_mmc_rlast_w)
    ,.inport_rd_awready_o(axi_video_awready_w)
    ,.inport_rd_wready_o(axi_video_wready_w)
    ,.inport_rd_bvalid_o(axi_video_bvalid_w)
    ,.inport_rd_bresp_o(axi_video_bresp_w)
    ,.inport_rd_bid_o(axi_video_bid_w)
    ,.inport_rd_arready_o(axi_video_arready_w)
    ,.inport_rd_rvalid_o(axi_video_rvalid_w)
    ,.inport_rd_rdata_o(axi_video_rdata_w)
    ,.inport_rd_rresp_o(axi_video_rresp_w)
    ,.inport_rd_rid_o(axi_video_rid_w)
    ,.inport_rd_rlast_o(axi_video_rlast_w)
    ,.outport_awvalid_o(axi_video_mmc_awvalid_w)
    ,.outport_awaddr_o(axi_video_mmc_awaddr_w)
    ,.outport_awid_o(axi_video_mmc_awid_w)
    ,.outport_awlen_o(axi_video_mmc_awlen_w)
    ,.outport_awburst_o(axi_video_mmc_awburst_w)
    ,.outport_wvalid_o(axi_video_mmc_wvalid_w)
    ,.outport_wdata_o(axi_video_mmc_wdata_w)
    ,.outport_wstrb_o(axi_video_mmc_wstrb_w)
    ,.outport_wlast_o(axi_video_mmc_wlast_w)
    ,.outport_bready_o(axi_video_mmc_bready_w)
    ,.outport_arvalid_o(axi_video_mmc_arvalid_w)
    ,.outport_araddr_o(axi_video_mmc_araddr_w)
    ,.outport_arid_o(axi_video_mmc_arid_w)
    ,.outport_arlen_o(axi_video_mmc_arlen_w)
    ,.outport_arburst_o(axi_video_mmc_arburst_w)
    ,.outport_rready_o(axi_video_mmc_rready_w)
);


dbg_bridge
#(
     .CLK_FREQ(CLK_FREQ)
    ,.GPIO_ADDRESS('hf0000000)
    ,.AXI_ID(0)
    ,.STS_ADDRESS('hf0000004)
    ,.UART_SPEED(UART_SPEED)
)
u_dbg
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.uart_rxd_i(dbg_txd_i)
    ,.mem_awready_i(axi_t_awready_w)
    ,.mem_wready_i(axi_t_wready_w)
    ,.mem_bvalid_i(axi_t_bvalid_w)
    ,.mem_bresp_i(axi_t_bresp_w)
    ,.mem_bid_i(axi_t_bid_w)
    ,.mem_arready_i(axi_t_arready_w)
    ,.mem_rvalid_i(axi_t_rvalid_w)
    ,.mem_rdata_i(axi_t_rdata_w)
    ,.mem_rresp_i(axi_t_rresp_w)
    ,.mem_rid_i(axi_t_rid_w)
    ,.mem_rlast_i(axi_t_rlast_w)

    // Outputs
    ,.uart_txd_o(dbg_rxd_o)
    ,.mem_awvalid_o(axi_t_awvalid_w)
    ,.mem_awaddr_o(axi_t_awaddr_w)
    ,.mem_awid_o(axi_t_awid_w)
    ,.mem_awlen_o(axi_t_awlen_w)
    ,.mem_awburst_o(axi_t_awburst_w)
    ,.mem_wvalid_o(axi_t_wvalid_w)
    ,.mem_wdata_o(axi_t_wdata_w)
    ,.mem_wstrb_o(axi_t_wstrb_w)
    ,.mem_wlast_o(axi_t_wlast_w)
    ,.mem_bready_o(axi_t_bready_w)
    ,.mem_arvalid_o(axi_t_arvalid_w)
    ,.mem_araddr_o(axi_t_araddr_w)
    ,.mem_arid_o(axi_t_arid_w)
    ,.mem_arlen_o(axi_t_arlen_w)
    ,.mem_arburst_o(axi_t_arburst_w)
    ,.mem_rready_o(axi_t_rready_w)
    ,.gpio_outputs_o(enable_w)
);


axi4_retime
#(
     .AXI4_RETIME_RD_RESP(1)
    ,.AXI4_RETIME_WR_RESP(1)
    ,.AXI4_RETIME_RD_REQ(1)
    ,.AXI4_RETIME_WR_REQ(1)
)
u_jpeg_retime
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(jpeg_dma_awvalid_w)
    ,.inport_awaddr_i(jpeg_dma_awaddr_w)
    ,.inport_awid_i(jpeg_dma_awid_w)
    ,.inport_awlen_i(jpeg_dma_awlen_w)
    ,.inport_awburst_i(jpeg_dma_awburst_w)
    ,.inport_wvalid_i(jpeg_dma_wvalid_w)
    ,.inport_wdata_i(jpeg_dma_wdata_w)
    ,.inport_wstrb_i(jpeg_dma_wstrb_w)
    ,.inport_wlast_i(jpeg_dma_wlast_w)
    ,.inport_bready_i(jpeg_dma_bready_w)
    ,.inport_arvalid_i(jpeg_dma_arvalid_w)
    ,.inport_araddr_i(jpeg_dma_araddr_w)
    ,.inport_arid_i(jpeg_dma_arid_w)
    ,.inport_arlen_i(jpeg_dma_arlen_w)
    ,.inport_arburst_i(jpeg_dma_arburst_w)
    ,.inport_rready_i(jpeg_dma_rready_w)
    ,.outport_awready_i(jpeg_dma_retimed_awready_w)
    ,.outport_wready_i(jpeg_dma_retimed_wready_w)
    ,.outport_bvalid_i(jpeg_dma_retimed_bvalid_w)
    ,.outport_bresp_i(jpeg_dma_retimed_bresp_w)
    ,.outport_bid_i(jpeg_dma_retimed_bid_w)
    ,.outport_arready_i(jpeg_dma_retimed_arready_w)
    ,.outport_rvalid_i(jpeg_dma_retimed_rvalid_w)
    ,.outport_rdata_i(jpeg_dma_retimed_rdata_w)
    ,.outport_rresp_i(jpeg_dma_retimed_rresp_w)
    ,.outport_rid_i(jpeg_dma_retimed_rid_w)
    ,.outport_rlast_i(jpeg_dma_retimed_rlast_w)

    // Outputs
    ,.inport_awready_o(jpeg_dma_awready_w)
    ,.inport_wready_o(jpeg_dma_wready_w)
    ,.inport_bvalid_o(jpeg_dma_bvalid_w)
    ,.inport_bresp_o(jpeg_dma_bresp_w)
    ,.inport_bid_o(jpeg_dma_bid_w)
    ,.inport_arready_o(jpeg_dma_arready_w)
    ,.inport_rvalid_o(jpeg_dma_rvalid_w)
    ,.inport_rdata_o(jpeg_dma_rdata_w)
    ,.inport_rresp_o(jpeg_dma_rresp_w)
    ,.inport_rid_o(jpeg_dma_rid_w)
    ,.inport_rlast_o(jpeg_dma_rlast_w)
    ,.outport_awvalid_o(jpeg_dma_retimed_awvalid_w)
    ,.outport_awaddr_o(jpeg_dma_retimed_awaddr_w)
    ,.outport_awid_o(jpeg_dma_retimed_awid_w)
    ,.outport_awlen_o(jpeg_dma_retimed_awlen_w)
    ,.outport_awburst_o(jpeg_dma_retimed_awburst_w)
    ,.outport_wvalid_o(jpeg_dma_retimed_wvalid_w)
    ,.outport_wdata_o(jpeg_dma_retimed_wdata_w)
    ,.outport_wstrb_o(jpeg_dma_retimed_wstrb_w)
    ,.outport_wlast_o(jpeg_dma_retimed_wlast_w)
    ,.outport_bready_o(jpeg_dma_retimed_bready_w)
    ,.outport_arvalid_o(jpeg_dma_retimed_arvalid_w)
    ,.outport_araddr_o(jpeg_dma_retimed_araddr_w)
    ,.outport_arid_o(jpeg_dma_retimed_arid_w)
    ,.outport_arlen_o(jpeg_dma_retimed_arlen_w)
    ,.outport_arburst_o(jpeg_dma_retimed_arburst_w)
    ,.outport_rready_o(jpeg_dma_retimed_rready_w)
);


jpeg_decoder
#(
     .AXI_ID(2)
)
u_jpeg
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(jpeg_cfg_awvalid_w)
    ,.cfg_awaddr_i(jpeg_cfg_awaddr_w)
    ,.cfg_wvalid_i(jpeg_cfg_wvalid_w)
    ,.cfg_wdata_i(jpeg_cfg_wdata_w)
    ,.cfg_wstrb_i(jpeg_cfg_wstrb_w)
    ,.cfg_bready_i(jpeg_cfg_bready_w)
    ,.cfg_arvalid_i(jpeg_cfg_arvalid_w)
    ,.cfg_araddr_i(jpeg_cfg_araddr_w)
    ,.cfg_rready_i(jpeg_cfg_rready_w)
    ,.outport_awready_i(jpeg_dma_awready_w)
    ,.outport_wready_i(jpeg_dma_wready_w)
    ,.outport_bvalid_i(jpeg_dma_bvalid_w)
    ,.outport_bresp_i(jpeg_dma_bresp_w)
    ,.outport_bid_i(jpeg_dma_bid_w)
    ,.outport_arready_i(jpeg_dma_arready_w)
    ,.outport_rvalid_i(jpeg_dma_rvalid_w)
    ,.outport_rdata_i(jpeg_dma_rdata_w)
    ,.outport_rresp_i(jpeg_dma_rresp_w)
    ,.outport_rid_i(jpeg_dma_rid_w)
    ,.outport_rlast_i(jpeg_dma_rlast_w)

    // Outputs
    ,.cfg_awready_o(jpeg_cfg_awready_w)
    ,.cfg_wready_o(jpeg_cfg_wready_w)
    ,.cfg_bvalid_o(jpeg_cfg_bvalid_w)
    ,.cfg_bresp_o(jpeg_cfg_bresp_w)
    ,.cfg_arready_o(jpeg_cfg_arready_w)
    ,.cfg_rvalid_o(jpeg_cfg_rvalid_w)
    ,.cfg_rdata_o(jpeg_cfg_rdata_w)
    ,.cfg_rresp_o(jpeg_cfg_rresp_w)
    ,.outport_awvalid_o(jpeg_dma_awvalid_w)
    ,.outport_awaddr_o(jpeg_dma_awaddr_w)
    ,.outport_awid_o(jpeg_dma_awid_w)
    ,.outport_awlen_o(jpeg_dma_awlen_w)
    ,.outport_awburst_o(jpeg_dma_awburst_w)
    ,.outport_wvalid_o(jpeg_dma_wvalid_w)
    ,.outport_wdata_o(jpeg_dma_wdata_w)
    ,.outport_wstrb_o(jpeg_dma_wstrb_w)
    ,.outport_wlast_o(jpeg_dma_wlast_w)
    ,.outport_bready_o(jpeg_dma_bready_w)
    ,.outport_arvalid_o(jpeg_dma_arvalid_w)
    ,.outport_araddr_o(jpeg_dma_araddr_w)
    ,.outport_arid_o(jpeg_dma_arid_w)
    ,.outport_arlen_o(jpeg_dma_arlen_w)
    ,.outport_arburst_o(jpeg_dma_arburst_w)
    ,.outport_rready_o(jpeg_dma_rready_w)
);


axi4_retime
#(
     .AXI4_RETIME_RD_RESP(1)
    ,.AXI4_RETIME_WR_RESP(1)
    ,.AXI4_RETIME_RD_REQ(1)
    ,.AXI4_RETIME_WR_REQ(1)
)
u_retime
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi_video_mmc_awvalid_w)
    ,.inport_awaddr_i(axi_video_mmc_awaddr_w)
    ,.inport_awid_i(axi_video_mmc_awid_w)
    ,.inport_awlen_i(axi_video_mmc_awlen_w)
    ,.inport_awburst_i(axi_video_mmc_awburst_w)
    ,.inport_wvalid_i(axi_video_mmc_wvalid_w)
    ,.inport_wdata_i(axi_video_mmc_wdata_w)
    ,.inport_wstrb_i(axi_video_mmc_wstrb_w)
    ,.inport_wlast_i(axi_video_mmc_wlast_w)
    ,.inport_bready_i(axi_video_mmc_bready_w)
    ,.inport_arvalid_i(axi_video_mmc_arvalid_w)
    ,.inport_araddr_i(axi_video_mmc_araddr_w)
    ,.inport_arid_i(axi_video_mmc_arid_w)
    ,.inport_arlen_i(axi_video_mmc_arlen_w)
    ,.inport_arburst_i(axi_video_mmc_arburst_w)
    ,.inport_rready_i(axi_video_mmc_rready_w)
    ,.outport_awready_i(axi_video_mmc_retime_awready_w)
    ,.outport_wready_i(axi_video_mmc_retime_wready_w)
    ,.outport_bvalid_i(axi_video_mmc_retime_bvalid_w)
    ,.outport_bresp_i(axi_video_mmc_retime_bresp_w)
    ,.outport_bid_i(axi_video_mmc_retime_bid_w)
    ,.outport_arready_i(axi_video_mmc_retime_arready_w)
    ,.outport_rvalid_i(axi_video_mmc_retime_rvalid_w)
    ,.outport_rdata_i(axi_video_mmc_retime_rdata_w)
    ,.outport_rresp_i(axi_video_mmc_retime_rresp_w)
    ,.outport_rid_i(axi_video_mmc_retime_rid_w)
    ,.outport_rlast_i(axi_video_mmc_retime_rlast_w)

    // Outputs
    ,.inport_awready_o(axi_video_mmc_awready_w)
    ,.inport_wready_o(axi_video_mmc_wready_w)
    ,.inport_bvalid_o(axi_video_mmc_bvalid_w)
    ,.inport_bresp_o(axi_video_mmc_bresp_w)
    ,.inport_bid_o(axi_video_mmc_bid_w)
    ,.inport_arready_o(axi_video_mmc_arready_w)
    ,.inport_rvalid_o(axi_video_mmc_rvalid_w)
    ,.inport_rdata_o(axi_video_mmc_rdata_w)
    ,.inport_rresp_o(axi_video_mmc_rresp_w)
    ,.inport_rid_o(axi_video_mmc_rid_w)
    ,.inport_rlast_o(axi_video_mmc_rlast_w)
    ,.outport_awvalid_o(axi_video_mmc_retime_awvalid_w)
    ,.outport_awaddr_o(axi_video_mmc_retime_awaddr_w)
    ,.outport_awid_o(axi_video_mmc_retime_awid_w)
    ,.outport_awlen_o(axi_video_mmc_retime_awlen_w)
    ,.outport_awburst_o(axi_video_mmc_retime_awburst_w)
    ,.outport_wvalid_o(axi_video_mmc_retime_wvalid_w)
    ,.outport_wdata_o(axi_video_mmc_retime_wdata_w)
    ,.outport_wstrb_o(axi_video_mmc_retime_wstrb_w)
    ,.outport_wlast_o(axi_video_mmc_retime_wlast_w)
    ,.outport_bready_o(axi_video_mmc_retime_bready_w)
    ,.outport_arvalid_o(axi_video_mmc_retime_arvalid_w)
    ,.outport_araddr_o(axi_video_mmc_retime_araddr_w)
    ,.outport_arid_o(axi_video_mmc_retime_arid_w)
    ,.outport_arlen_o(axi_video_mmc_retime_arlen_w)
    ,.outport_arburst_o(axi_video_mmc_retime_arburst_w)
    ,.outport_rready_o(axi_video_mmc_retime_rready_w)
);


soc_arb
u_arb
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.debug_awvalid_i(axi_t_awvalid_w)
    ,.debug_awaddr_i(axi_t_awaddr_w)
    ,.debug_awid_i(axi_t_awid_w)
    ,.debug_awlen_i(axi_t_awlen_w)
    ,.debug_awburst_i(axi_t_awburst_w)
    ,.debug_wvalid_i(axi_t_wvalid_w)
    ,.debug_wdata_i(axi_t_wdata_w)
    ,.debug_wstrb_i(axi_t_wstrb_w)
    ,.debug_wlast_i(axi_t_wlast_w)
    ,.debug_bready_i(axi_t_bready_w)
    ,.debug_arvalid_i(axi_t_arvalid_w)
    ,.debug_araddr_i(axi_t_araddr_w)
    ,.debug_arid_i(axi_t_arid_w)
    ,.debug_arlen_i(axi_t_arlen_w)
    ,.debug_arburst_i(axi_t_arburst_w)
    ,.debug_rready_i(axi_t_rready_w)
    ,.mem_awready_i(axi_dist_inport_awready_w)
    ,.mem_wready_i(axi_dist_inport_wready_w)
    ,.mem_bvalid_i(axi_dist_inport_bvalid_w)
    ,.mem_bresp_i(axi_dist_inport_bresp_w)
    ,.mem_bid_i(axi_dist_inport_bid_w)
    ,.mem_arready_i(axi_dist_inport_arready_w)
    ,.mem_rvalid_i(axi_dist_inport_rvalid_w)
    ,.mem_rdata_i(axi_dist_inport_rdata_w)
    ,.mem_rresp_i(axi_dist_inport_rresp_w)
    ,.mem_rid_i(axi_dist_inport_rid_w)
    ,.mem_rlast_i(axi_dist_inport_rlast_w)
    ,.soc_awready_i(axi_cfg_awready_w)
    ,.soc_wready_i(axi_cfg_wready_w)
    ,.soc_bvalid_i(axi_cfg_bvalid_w)
    ,.soc_bresp_i(axi_cfg_bresp_w)
    ,.soc_arready_i(axi_cfg_arready_w)
    ,.soc_rvalid_i(axi_cfg_rvalid_w)
    ,.soc_rdata_i(axi_cfg_rdata_w)
    ,.soc_rresp_i(axi_cfg_rresp_w)
    ,.cpu_i_awvalid_i(axi_i_awvalid_w)
    ,.cpu_i_awaddr_i(axi_i_awaddr_w)
    ,.cpu_i_awid_i(axi_i_awid_w)
    ,.cpu_i_awlen_i(axi_i_awlen_w)
    ,.cpu_i_awburst_i(axi_i_awburst_w)
    ,.cpu_i_wvalid_i(axi_i_wvalid_w)
    ,.cpu_i_wdata_i(axi_i_wdata_w)
    ,.cpu_i_wstrb_i(axi_i_wstrb_w)
    ,.cpu_i_wlast_i(axi_i_wlast_w)
    ,.cpu_i_bready_i(axi_i_bready_w)
    ,.cpu_i_arvalid_i(axi_i_arvalid_w)
    ,.cpu_i_araddr_i(axi_i_araddr_w)
    ,.cpu_i_arid_i(axi_i_arid_w)
    ,.cpu_i_arlen_i(axi_i_arlen_w)
    ,.cpu_i_arburst_i(axi_i_arburst_w)
    ,.cpu_i_rready_i(axi_i_rready_w)
    ,.cpu_d_awvalid_i(axi_d_awvalid_w)
    ,.cpu_d_awaddr_i(axi_d_awaddr_w)
    ,.cpu_d_awid_i(axi_d_awid_w)
    ,.cpu_d_awlen_i(axi_d_awlen_w)
    ,.cpu_d_awburst_i(axi_d_awburst_w)
    ,.cpu_d_wvalid_i(axi_d_wvalid_w)
    ,.cpu_d_wdata_i(axi_d_wdata_w)
    ,.cpu_d_wstrb_i(axi_d_wstrb_w)
    ,.cpu_d_wlast_i(axi_d_wlast_w)
    ,.cpu_d_bready_i(axi_d_bready_w)
    ,.cpu_d_arvalid_i(axi_d_arvalid_w)
    ,.cpu_d_araddr_i(axi_d_araddr_w)
    ,.cpu_d_arid_i(axi_d_arid_w)
    ,.cpu_d_arlen_i(axi_d_arlen_w)
    ,.cpu_d_arburst_i(axi_d_arburst_w)
    ,.cpu_d_rready_i(axi_d_rready_w)
    ,.dma0_awvalid_i(axi_video_mmc_retime_awvalid_w)
    ,.dma0_awaddr_i(axi_video_mmc_retime_awaddr_w)
    ,.dma0_awid_i(axi_video_mmc_retime_awid_w)
    ,.dma0_awlen_i(axi_video_mmc_retime_awlen_w)
    ,.dma0_awburst_i(axi_video_mmc_retime_awburst_w)
    ,.dma0_wvalid_i(axi_video_mmc_retime_wvalid_w)
    ,.dma0_wdata_i(axi_video_mmc_retime_wdata_w)
    ,.dma0_wstrb_i(axi_video_mmc_retime_wstrb_w)
    ,.dma0_wlast_i(axi_video_mmc_retime_wlast_w)
    ,.dma0_bready_i(axi_video_mmc_retime_bready_w)
    ,.dma0_arvalid_i(axi_video_mmc_retime_arvalid_w)
    ,.dma0_araddr_i(axi_video_mmc_retime_araddr_w)
    ,.dma0_arid_i(axi_video_mmc_retime_arid_w)
    ,.dma0_arlen_i(axi_video_mmc_retime_arlen_w)
    ,.dma0_arburst_i(axi_video_mmc_retime_arburst_w)
    ,.dma0_rready_i(axi_video_mmc_retime_rready_w)
    ,.dma1_awvalid_i(jpeg_dma_retimed_awvalid_w)
    ,.dma1_awaddr_i(jpeg_dma_retimed_awaddr_w)
    ,.dma1_awid_i(jpeg_dma_retimed_awid_w)
    ,.dma1_awlen_i(jpeg_dma_retimed_awlen_w)
    ,.dma1_awburst_i(jpeg_dma_retimed_awburst_w)
    ,.dma1_wvalid_i(jpeg_dma_retimed_wvalid_w)
    ,.dma1_wdata_i(jpeg_dma_retimed_wdata_w)
    ,.dma1_wstrb_i(jpeg_dma_retimed_wstrb_w)
    ,.dma1_wlast_i(jpeg_dma_retimed_wlast_w)
    ,.dma1_bready_i(jpeg_dma_retimed_bready_w)
    ,.dma1_arvalid_i(jpeg_dma_retimed_arvalid_w)
    ,.dma1_araddr_i(jpeg_dma_retimed_araddr_w)
    ,.dma1_arid_i(jpeg_dma_retimed_arid_w)
    ,.dma1_arlen_i(jpeg_dma_retimed_arlen_w)
    ,.dma1_arburst_i(jpeg_dma_retimed_arburst_w)
    ,.dma1_rready_i(jpeg_dma_retimed_rready_w)
    ,.dma2_awvalid_i(1'b0)
    ,.dma2_awaddr_i(32'b0)
    ,.dma2_awid_i(4'b0)
    ,.dma2_awlen_i(8'b0)
    ,.dma2_awburst_i(2'b0)
    ,.dma2_wvalid_i(1'b0)
    ,.dma2_wdata_i(32'b0)
    ,.dma2_wstrb_i(4'b0)
    ,.dma2_wlast_i(1'b0)
    ,.dma2_bready_i(1'b0)
    ,.dma2_arvalid_i(1'b0)
    ,.dma2_araddr_i(32'b0)
    ,.dma2_arid_i(4'b0)
    ,.dma2_arlen_i(8'b0)
    ,.dma2_arburst_i(2'b0)
    ,.dma2_rready_i(1'b0)
    ,.dma3_awvalid_i(1'b0)
    ,.dma3_awaddr_i(32'b0)
    ,.dma3_awid_i(4'b0)
    ,.dma3_awlen_i(8'b0)
    ,.dma3_awburst_i(2'b0)
    ,.dma3_wvalid_i(1'b0)
    ,.dma3_wdata_i(32'b0)
    ,.dma3_wstrb_i(4'b0)
    ,.dma3_wlast_i(1'b0)
    ,.dma3_bready_i(1'b0)
    ,.dma3_arvalid_i(1'b0)
    ,.dma3_araddr_i(32'b0)
    ,.dma3_arid_i(4'b0)
    ,.dma3_arlen_i(8'b0)
    ,.dma3_arburst_i(2'b0)
    ,.dma3_rready_i(1'b0)

    // Outputs
    ,.debug_awready_o(axi_t_awready_w)
    ,.debug_wready_o(axi_t_wready_w)
    ,.debug_bvalid_o(axi_t_bvalid_w)
    ,.debug_bresp_o(axi_t_bresp_w)
    ,.debug_bid_o(axi_t_bid_w)
    ,.debug_arready_o(axi_t_arready_w)
    ,.debug_rvalid_o(axi_t_rvalid_w)
    ,.debug_rdata_o(axi_t_rdata_w)
    ,.debug_rresp_o(axi_t_rresp_w)
    ,.debug_rid_o(axi_t_rid_w)
    ,.debug_rlast_o(axi_t_rlast_w)
    ,.mem_awvalid_o(axi_dist_inport_awvalid_w)
    ,.mem_awaddr_o(axi_dist_inport_awaddr_w)
    ,.mem_awid_o(axi_dist_inport_awid_w)
    ,.mem_awlen_o(axi_dist_inport_awlen_w)
    ,.mem_awburst_o(axi_dist_inport_awburst_w)
    ,.mem_wvalid_o(axi_dist_inport_wvalid_w)
    ,.mem_wdata_o(axi_dist_inport_wdata_w)
    ,.mem_wstrb_o(axi_dist_inport_wstrb_w)
    ,.mem_wlast_o(axi_dist_inport_wlast_w)
    ,.mem_bready_o(axi_dist_inport_bready_w)
    ,.mem_arvalid_o(axi_dist_inport_arvalid_w)
    ,.mem_araddr_o(axi_dist_inport_araddr_w)
    ,.mem_arid_o(axi_dist_inport_arid_w)
    ,.mem_arlen_o(axi_dist_inport_arlen_w)
    ,.mem_arburst_o(axi_dist_inport_arburst_w)
    ,.mem_rready_o(axi_dist_inport_rready_w)
    ,.soc_awvalid_o(axi_cfg_awvalid_w)
    ,.soc_awaddr_o(axi_cfg_awaddr_w)
    ,.soc_wvalid_o(axi_cfg_wvalid_w)
    ,.soc_wdata_o(axi_cfg_wdata_w)
    ,.soc_wstrb_o(axi_cfg_wstrb_w)
    ,.soc_bready_o(axi_cfg_bready_w)
    ,.soc_arvalid_o(axi_cfg_arvalid_w)
    ,.soc_araddr_o(axi_cfg_araddr_w)
    ,.soc_rready_o(axi_cfg_rready_w)
    ,.cpu_i_awready_o(axi_i_awready_w)
    ,.cpu_i_wready_o(axi_i_wready_w)
    ,.cpu_i_bvalid_o(axi_i_bvalid_w)
    ,.cpu_i_bresp_o(axi_i_bresp_w)
    ,.cpu_i_bid_o(axi_i_bid_w)
    ,.cpu_i_arready_o(axi_i_arready_w)
    ,.cpu_i_rvalid_o(axi_i_rvalid_w)
    ,.cpu_i_rdata_o(axi_i_rdata_w)
    ,.cpu_i_rresp_o(axi_i_rresp_w)
    ,.cpu_i_rid_o(axi_i_rid_w)
    ,.cpu_i_rlast_o(axi_i_rlast_w)
    ,.cpu_d_awready_o(axi_d_awready_w)
    ,.cpu_d_wready_o(axi_d_wready_w)
    ,.cpu_d_bvalid_o(axi_d_bvalid_w)
    ,.cpu_d_bresp_o(axi_d_bresp_w)
    ,.cpu_d_bid_o(axi_d_bid_w)
    ,.cpu_d_arready_o(axi_d_arready_w)
    ,.cpu_d_rvalid_o(axi_d_rvalid_w)
    ,.cpu_d_rdata_o(axi_d_rdata_w)
    ,.cpu_d_rresp_o(axi_d_rresp_w)
    ,.cpu_d_rid_o(axi_d_rid_w)
    ,.cpu_d_rlast_o(axi_d_rlast_w)
    ,.dma0_awready_o(axi_video_mmc_retime_awready_w)
    ,.dma0_wready_o(axi_video_mmc_retime_wready_w)
    ,.dma0_bvalid_o(axi_video_mmc_retime_bvalid_w)
    ,.dma0_bresp_o(axi_video_mmc_retime_bresp_w)
    ,.dma0_bid_o(axi_video_mmc_retime_bid_w)
    ,.dma0_arready_o(axi_video_mmc_retime_arready_w)
    ,.dma0_rvalid_o(axi_video_mmc_retime_rvalid_w)
    ,.dma0_rdata_o(axi_video_mmc_retime_rdata_w)
    ,.dma0_rresp_o(axi_video_mmc_retime_rresp_w)
    ,.dma0_rid_o(axi_video_mmc_retime_rid_w)
    ,.dma0_rlast_o(axi_video_mmc_retime_rlast_w)
    ,.dma1_awready_o(jpeg_dma_retimed_awready_w)
    ,.dma1_wready_o(jpeg_dma_retimed_wready_w)
    ,.dma1_bvalid_o(jpeg_dma_retimed_bvalid_w)
    ,.dma1_bresp_o(jpeg_dma_retimed_bresp_w)
    ,.dma1_bid_o(jpeg_dma_retimed_bid_w)
    ,.dma1_arready_o(jpeg_dma_retimed_arready_w)
    ,.dma1_rvalid_o(jpeg_dma_retimed_rvalid_w)
    ,.dma1_rdata_o(jpeg_dma_retimed_rdata_w)
    ,.dma1_rresp_o(jpeg_dma_retimed_rresp_w)
    ,.dma1_rid_o(jpeg_dma_retimed_rid_w)
    ,.dma1_rlast_o(jpeg_dma_retimed_rlast_w)
    ,.dma2_awready_o()
    ,.dma2_wready_o()
    ,.dma2_bvalid_o()
    ,.dma2_bresp_o()
    ,.dma2_bid_o()
    ,.dma2_arready_o()
    ,.dma2_rvalid_o()
    ,.dma2_rdata_o()
    ,.dma2_rresp_o()
    ,.dma2_rid_o()
    ,.dma2_rlast_o()
    ,.dma3_awready_o()
    ,.dma3_wready_o()
    ,.dma3_bvalid_o()
    ,.dma3_bresp_o()
    ,.dma3_bid_o()
    ,.dma3_arready_o()
    ,.dma3_rvalid_o()
    ,.dma3_rdata_o()
    ,.dma3_rresp_o()
    ,.dma3_rid_o()
    ,.dma3_rlast_o()
);


bootrom
u_bootrom
(
    // Inputs
     .clk_i(clk_sys_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(bootrom_awvalid_w)
    ,.inport_awaddr_i(bootrom_awaddr_w)
    ,.inport_awid_i(bootrom_awid_w)
    ,.inport_awlen_i(bootrom_awlen_w)
    ,.inport_awburst_i(bootrom_awburst_w)
    ,.inport_wvalid_i(bootrom_wvalid_w)
    ,.inport_wdata_i(bootrom_wdata_w)
    ,.inport_wstrb_i(bootrom_wstrb_w)
    ,.inport_wlast_i(bootrom_wlast_w)
    ,.inport_bready_i(bootrom_bready_w)
    ,.inport_arvalid_i(bootrom_arvalid_w)
    ,.inport_araddr_i(bootrom_araddr_w)
    ,.inport_arid_i(bootrom_arid_w)
    ,.inport_arlen_i(bootrom_arlen_w)
    ,.inport_arburst_i(bootrom_arburst_w)
    ,.inport_rready_i(bootrom_rready_w)

    // Outputs
    ,.inport_awready_o(bootrom_awready_w)
    ,.inport_wready_o(bootrom_wready_w)
    ,.inport_bvalid_o(bootrom_bvalid_w)
    ,.inport_bresp_o(bootrom_bresp_w)
    ,.inport_bid_o(bootrom_bid_w)
    ,.inport_arready_o(bootrom_arready_w)
    ,.inport_rvalid_o(bootrom_rvalid_w)
    ,.inport_rdata_o(bootrom_rdata_w)
    ,.inport_rresp_o(bootrom_rresp_w)
    ,.inport_rid_o(bootrom_rid_w)
    ,.inport_rlast_o(bootrom_rlast_w)
);


mmc_card
#(
     .MMC_FIFO_DEPTH_W(10)
    ,.AXI_ID(12)
    ,.MMC_FIFO_DEPTH(1024)
)
u_mmc
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(mmc_cfg_awvalid_w)
    ,.cfg_awaddr_i(mmc_cfg_awaddr_w)
    ,.cfg_wvalid_i(mmc_cfg_wvalid_w)
    ,.cfg_wdata_i(mmc_cfg_wdata_w)
    ,.cfg_wstrb_i(mmc_cfg_wstrb_w)
    ,.cfg_bready_i(mmc_cfg_bready_w)
    ,.cfg_arvalid_i(mmc_cfg_arvalid_w)
    ,.cfg_araddr_i(mmc_cfg_araddr_w)
    ,.cfg_rready_i(mmc_cfg_rready_w)
    ,.mmc_cmd_in_i(mmc_cmd_in_i)
    ,.mmc_dat_in_i(mmc_dat_in_i)
    ,.outport_awready_i(axi_mmc_awready_w)
    ,.outport_wready_i(axi_mmc_wready_w)
    ,.outport_bvalid_i(axi_mmc_bvalid_w)
    ,.outport_bresp_i(axi_mmc_bresp_w)
    ,.outport_bid_i(axi_mmc_bid_w)
    ,.outport_arready_i(axi_mmc_arready_w)
    ,.outport_rvalid_i(axi_mmc_rvalid_w)
    ,.outport_rdata_i(axi_mmc_rdata_w)
    ,.outport_rresp_i(axi_mmc_rresp_w)
    ,.outport_rid_i(axi_mmc_rid_w)
    ,.outport_rlast_i(axi_mmc_rlast_w)

    // Outputs
    ,.cfg_awready_o(mmc_cfg_awready_w)
    ,.cfg_wready_o(mmc_cfg_wready_w)
    ,.cfg_bvalid_o(mmc_cfg_bvalid_w)
    ,.cfg_bresp_o(mmc_cfg_bresp_w)
    ,.cfg_arready_o(mmc_cfg_arready_w)
    ,.cfg_rvalid_o(mmc_cfg_rvalid_w)
    ,.cfg_rdata_o(mmc_cfg_rdata_w)
    ,.cfg_rresp_o(mmc_cfg_rresp_w)
    ,.mmc_clk_o(mmc_clk_o)
    ,.mmc_cmd_out_o(mmc_cmd_out_o)
    ,.mmc_cmd_out_en_o(mmc_cmd_out_en_o)
    ,.mmc_dat_out_o(mmc_dat_out_o)
    ,.mmc_dat_out_en_o(mmc_dat_out_en_o)
    ,.intr_o(mmc_irq_w)
    ,.outport_awvalid_o(axi_mmc_awvalid_w)
    ,.outport_awaddr_o(axi_mmc_awaddr_w)
    ,.outport_awid_o(axi_mmc_awid_w)
    ,.outport_awlen_o(axi_mmc_awlen_w)
    ,.outport_awburst_o(axi_mmc_awburst_w)
    ,.outport_wvalid_o(axi_mmc_wvalid_w)
    ,.outport_wdata_o(axi_mmc_wdata_w)
    ,.outport_wstrb_o(axi_mmc_wstrb_w)
    ,.outport_wlast_o(axi_mmc_wlast_w)
    ,.outport_bready_o(axi_mmc_bready_w)
    ,.outport_arvalid_o(axi_mmc_arvalid_w)
    ,.outport_araddr_o(axi_mmc_araddr_w)
    ,.outport_arid_o(axi_mmc_arid_w)
    ,.outport_arlen_o(axi_mmc_arlen_w)
    ,.outport_arburst_o(axi_mmc_arburst_w)
    ,.outport_rready_o(axi_mmc_rready_w)
);


riscv_top
#(
     .CORE_ID(0)
    ,.MEM_CACHE_ADDR_MAX('h8fffffff)
    ,.MEM_CACHE_ADDR_MIN('h80000000)
)
u_cpu
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_cpu_w)
    ,.axi_i_awready_i(axi_i_awready_w)
    ,.axi_i_wready_i(axi_i_wready_w)
    ,.axi_i_bvalid_i(axi_i_bvalid_w)
    ,.axi_i_bresp_i(axi_i_bresp_w)
    ,.axi_i_bid_i(axi_i_bid_w)
    ,.axi_i_arready_i(axi_i_arready_w)
    ,.axi_i_rvalid_i(axi_i_rvalid_w)
    ,.axi_i_rdata_i(axi_i_rdata_w)
    ,.axi_i_rresp_i(axi_i_rresp_w)
    ,.axi_i_rid_i(axi_i_rid_w)
    ,.axi_i_rlast_i(axi_i_rlast_w)
    ,.axi_d_awready_i(axi_d_awready_w)
    ,.axi_d_wready_i(axi_d_wready_w)
    ,.axi_d_bvalid_i(axi_d_bvalid_w)
    ,.axi_d_bresp_i(axi_d_bresp_w)
    ,.axi_d_bid_i(axi_d_bid_w)
    ,.axi_d_arready_i(axi_d_arready_w)
    ,.axi_d_rvalid_i(axi_d_rvalid_w)
    ,.axi_d_rdata_i(axi_d_rdata_w)
    ,.axi_d_rresp_i(axi_d_rresp_w)
    ,.axi_d_rid_i(axi_d_rid_w)
    ,.axi_d_rlast_i(axi_d_rlast_w)
    ,.intr_i(interrupt_w)
    ,.reset_vector_i(reset_vector_w)

    // Outputs
    ,.axi_i_awvalid_o(axi_i_awvalid_w)
    ,.axi_i_awaddr_o(axi_i_awaddr_w)
    ,.axi_i_awid_o(axi_i_awid_w)
    ,.axi_i_awlen_o(axi_i_awlen_w)
    ,.axi_i_awburst_o(axi_i_awburst_w)
    ,.axi_i_wvalid_o(axi_i_wvalid_w)
    ,.axi_i_wdata_o(axi_i_wdata_w)
    ,.axi_i_wstrb_o(axi_i_wstrb_w)
    ,.axi_i_wlast_o(axi_i_wlast_w)
    ,.axi_i_bready_o(axi_i_bready_w)
    ,.axi_i_arvalid_o(axi_i_arvalid_w)
    ,.axi_i_araddr_o(axi_i_araddr_w)
    ,.axi_i_arid_o(axi_i_arid_w)
    ,.axi_i_arlen_o(axi_i_arlen_w)
    ,.axi_i_arburst_o(axi_i_arburst_w)
    ,.axi_i_rready_o(axi_i_rready_w)
    ,.axi_d_awvalid_o(axi_d_awvalid_w)
    ,.axi_d_awaddr_o(axi_d_awaddr_w)
    ,.axi_d_awid_o(axi_d_awid_w)
    ,.axi_d_awlen_o(axi_d_awlen_w)
    ,.axi_d_awburst_o(axi_d_awburst_w)
    ,.axi_d_wvalid_o(axi_d_wvalid_w)
    ,.axi_d_wdata_o(axi_d_wdata_w)
    ,.axi_d_wstrb_o(axi_d_wstrb_w)
    ,.axi_d_wlast_o(axi_d_wlast_w)
    ,.axi_d_bready_o(axi_d_bready_w)
    ,.axi_d_arvalid_o(axi_d_arvalid_w)
    ,.axi_d_araddr_o(axi_d_araddr_w)
    ,.axi_d_arid_o(axi_d_arid_w)
    ,.axi_d_arlen_o(axi_d_arlen_w)
    ,.axi_d_arburst_o(axi_d_arburst_w)
    ,.axi_d_rready_o(axi_d_rready_w)
);


`define DBG_BIT_RELEASE_RESET 0
`define DBG_BIT_ENABLE_DEBUG  1
`define DBG_BIT_CAPTURE_HI    2
`define DBG_BIT_CAPTURE_LO    3
`define DBG_BIT_DEBUG_WRITE   4
`define DBG_BIT_BOOTADDR      5




reg [31:0] reset_vector_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    reset_vector_q <= 32'h40000000;
else if (enable_w[`DBG_BIT_CAPTURE_HI] && enable_w[`DBG_BIT_BOOTADDR])
    reset_vector_q <= {enable_w[31:16], reset_vector_q[15:0]};
else if (enable_w[`DBG_BIT_CAPTURE_LO] && enable_w[`DBG_BIT_BOOTADDR])
    reset_vector_q <= {reset_vector_q[31:16], enable_w[31:16]};

assign reset_vector_w  = reset_vector_q;

reg reset_initial_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    reset_initial_q <= 1'b1;
else
    reset_initial_q <= 1'b0;

assign rst_cpu_w       = reset_initial_q | ~enable_w[0];

endmodule
