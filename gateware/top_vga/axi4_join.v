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

module axi4_join
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport_wr_awvalid_i
    ,input  [ 31:0]  inport_wr_awaddr_i
    ,input  [  3:0]  inport_wr_awid_i
    ,input  [  7:0]  inport_wr_awlen_i
    ,input  [  1:0]  inport_wr_awburst_i
    ,input           inport_wr_wvalid_i
    ,input  [ 31:0]  inport_wr_wdata_i
    ,input  [  3:0]  inport_wr_wstrb_i
    ,input           inport_wr_wlast_i
    ,input           inport_wr_bready_i
    ,input           inport_wr_arvalid_i
    ,input  [ 31:0]  inport_wr_araddr_i
    ,input  [  3:0]  inport_wr_arid_i
    ,input  [  7:0]  inport_wr_arlen_i
    ,input  [  1:0]  inport_wr_arburst_i
    ,input           inport_wr_rready_i
    ,input           inport_rd_awvalid_i
    ,input  [ 31:0]  inport_rd_awaddr_i
    ,input  [  3:0]  inport_rd_awid_i
    ,input  [  7:0]  inport_rd_awlen_i
    ,input  [  1:0]  inport_rd_awburst_i
    ,input           inport_rd_wvalid_i
    ,input  [ 31:0]  inport_rd_wdata_i
    ,input  [  3:0]  inport_rd_wstrb_i
    ,input           inport_rd_wlast_i
    ,input           inport_rd_bready_i
    ,input           inport_rd_arvalid_i
    ,input  [ 31:0]  inport_rd_araddr_i
    ,input  [  3:0]  inport_rd_arid_i
    ,input  [  7:0]  inport_rd_arlen_i
    ,input  [  1:0]  inport_rd_arburst_i
    ,input           inport_rd_rready_i
    ,input           outport_awready_i
    ,input           outport_wready_i
    ,input           outport_bvalid_i
    ,input  [  1:0]  outport_bresp_i
    ,input  [  3:0]  outport_bid_i
    ,input           outport_arready_i
    ,input           outport_rvalid_i
    ,input  [ 31:0]  outport_rdata_i
    ,input  [  1:0]  outport_rresp_i
    ,input  [  3:0]  outport_rid_i
    ,input           outport_rlast_i

    // Outputs
    ,output          inport_wr_awready_o
    ,output          inport_wr_wready_o
    ,output          inport_wr_bvalid_o
    ,output [  1:0]  inport_wr_bresp_o
    ,output [  3:0]  inport_wr_bid_o
    ,output          inport_wr_arready_o
    ,output          inport_wr_rvalid_o
    ,output [ 31:0]  inport_wr_rdata_o
    ,output [  1:0]  inport_wr_rresp_o
    ,output [  3:0]  inport_wr_rid_o
    ,output          inport_wr_rlast_o
    ,output          inport_rd_awready_o
    ,output          inport_rd_wready_o
    ,output          inport_rd_bvalid_o
    ,output [  1:0]  inport_rd_bresp_o
    ,output [  3:0]  inport_rd_bid_o
    ,output          inport_rd_arready_o
    ,output          inport_rd_rvalid_o
    ,output [ 31:0]  inport_rd_rdata_o
    ,output [  1:0]  inport_rd_rresp_o
    ,output [  3:0]  inport_rd_rid_o
    ,output          inport_rd_rlast_o
    ,output          outport_awvalid_o
    ,output [ 31:0]  outport_awaddr_o
    ,output [  3:0]  outport_awid_o
    ,output [  7:0]  outport_awlen_o
    ,output [  1:0]  outport_awburst_o
    ,output          outport_wvalid_o
    ,output [ 31:0]  outport_wdata_o
    ,output [  3:0]  outport_wstrb_o
    ,output          outport_wlast_o
    ,output          outport_bready_o
    ,output          outport_arvalid_o
    ,output [ 31:0]  outport_araddr_o
    ,output [  3:0]  outport_arid_o
    ,output [  7:0]  outport_arlen_o
    ,output [  1:0]  outport_arburst_o
    ,output          outport_rready_o
);



// Write
assign outport_awvalid_o   = inport_wr_awvalid_i;
assign outport_awaddr_o    = inport_wr_awaddr_i;
assign outport_awid_o      = inport_wr_awid_i;
assign outport_awlen_o     = inport_wr_awlen_i;
assign outport_awburst_o   = inport_wr_awburst_i;
assign outport_wvalid_o    = inport_wr_wvalid_i;
assign outport_wdata_o     = inport_wr_wdata_i;
assign outport_wstrb_o     = inport_wr_wstrb_i;
assign outport_wlast_o     = inport_wr_wlast_i;
assign outport_bready_o    = inport_wr_bready_i;

assign inport_wr_awready_o = outport_awready_i;
assign inport_wr_wready_o  = outport_wready_i;
assign inport_wr_bvalid_o  = outport_bvalid_i;
assign inport_wr_bresp_o   = outport_bresp_i;
assign inport_wr_bid_o     = outport_bid_i;
assign inport_wr_arready_o = outport_arready_i;
assign inport_wr_rvalid_o  = 1'b0;
assign inport_wr_rdata_o   = 32'b0;
assign inport_wr_rresp_o   = 2'b0;
assign inport_wr_rid_o     = 4'b0;
assign inport_wr_rlast_o   = 1'b0;

// Read
assign outport_arvalid_o   = inport_rd_arvalid_i;
assign outport_araddr_o    = inport_rd_araddr_i;
assign outport_arid_o      = inport_rd_arid_i;
assign outport_arlen_o     = inport_rd_arlen_i;
assign outport_arburst_o   = inport_rd_arburst_i;
assign outport_rready_o    = inport_rd_rready_i;

assign inport_rd_awready_o = 1'b0;
assign inport_rd_wready_o  = 1'b0;
assign inport_rd_bvalid_o  = 1'b0;
assign inport_rd_bresp_o   = 2'b0;
assign inport_rd_bid_o     = 4'b0;
assign inport_rd_arready_o = outport_arready_i;
assign inport_rd_rvalid_o  = outport_rvalid_i;
assign inport_rd_rdata_o   = outport_rdata_i;
assign inport_rd_rresp_o   = outport_rresp_i;
assign inport_rd_rid_o     = outport_rid_i;
assign inport_rd_rlast_o   = outport_rlast_i;


endmodule
