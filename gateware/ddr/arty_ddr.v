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

module arty_ddr
(
    // Inputs
     input           clk100_i
    ,input           clk200_i
    ,input           inport_awvalid_i
    ,input  [ 31:0]  inport_awaddr_i
    ,input  [  3:0]  inport_awid_i
    ,input  [  7:0]  inport_awlen_i
    ,input  [  1:0]  inport_awburst_i
    ,input           inport_wvalid_i
    ,input  [ 31:0]  inport_wdata_i
    ,input  [  3:0]  inport_wstrb_i
    ,input           inport_wlast_i
    ,input           inport_bready_i
    ,input           inport_arvalid_i
    ,input  [ 31:0]  inport_araddr_i
    ,input  [  3:0]  inport_arid_i
    ,input  [  7:0]  inport_arlen_i
    ,input  [  1:0]  inport_arburst_i
    ,input           inport_rready_i

    // Outputs
    ,output          clk_out_o
    ,output          rst_out_o
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output [  3:0]  inport_bid_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output [  3:0]  inport_rid_o
    ,output          inport_rlast_o
    ,output          ddr_ck_p_o
    ,output          ddr_ck_n_o
    ,output          ddr_cke_o
    ,output          ddr_reset_n_o
    ,output          ddr_ras_n_o
    ,output          ddr_cas_n_o
    ,output          ddr_we_n_o
    ,output          ddr_cs_n_o
    ,output [  2:0]  ddr_ba_o
    ,output [ 13:0]  ddr_addr_o
    ,output          ddr_odt_o
    ,output [  1:0]  ddr_dm_o
    ,inout [  1:0]  ddr_dqs_p_io
    ,inout [  1:0]  ddr_dqs_n_io
    ,inout [ 15:0]  ddr_data_io
);



// Other wires ...
wire         init_calib_complete, mmcm_locked;
wire         app_sr_active, app_ref_ack, app_zq_ack;
wire         app_sr_req, app_ref_req, app_zq_req;
wire         w_sys_reset;
wire [11:0]  w_device_temp;

mig_axis mig_sdram
(
    // DDR Pins
    .ddr3_ck_p(ddr_ck_p_o),
    .ddr3_ck_n(ddr_ck_n_o),
    .ddr3_reset_n(ddr_reset_n_o),
    .ddr3_cke(ddr_cke_o),
    .ddr3_cs_n(ddr_cs_n_o),
    .ddr3_ras_n(ddr_ras_n_o),
    .ddr3_we_n(ddr_we_n_o),
    .ddr3_cas_n(ddr_cas_n_o),
    .ddr3_ba(ddr_ba_o),
    .ddr3_addr(ddr_addr_o),
    .ddr3_odt(ddr_odt_o),
    .ddr3_dqs_p(ddr_dqs_p_io),
    .ddr3_dqs_n(ddr_dqs_n_io),
    .ddr3_dq(ddr_data_io),
    .ddr3_dm(ddr_dm_o),

    // Misc
    .sys_clk_i(clk100_i),
    .clk_ref_i(clk200_i),
    .ui_clk(clk_out_o),
    .ui_clk_sync_rst(w_sys_reset),
    .mmcm_locked(mmcm_locked),
    .aresetn(1'b1),
    .app_sr_req(1'b0),
    .app_ref_req(1'b0),
    .app_zq_req(1'b0),
    .app_sr_active(app_sr_active),
    .app_ref_ack(app_ref_ack),
    .app_zq_ack(app_zq_ack),

    // AXI
    .s_axi_awid(inport_awid_i),
    .s_axi_awaddr(inport_awaddr_i[27:0]),
    .s_axi_awlen(inport_awlen_i),
    .s_axi_awsize(3'b010),
    .s_axi_awburst(inport_awburst_i),
    .s_axi_awlock(1'b0),
    .s_axi_awcache(4'h2),
    .s_axi_awprot(3'b010),
    .s_axi_awqos(4'h0), 
    .s_axi_awvalid(inport_awvalid_i),
    .s_axi_awready(inport_awready_o),
    //
    .s_axi_wready(  inport_wready_o),
    .s_axi_wdata(   inport_wdata_i),
    .s_axi_wstrb(   inport_wstrb_i),
    .s_axi_wlast(   inport_wlast_i),
    .s_axi_wvalid(  inport_wvalid_i),
    //
    .s_axi_bready(inport_bready_i),
    .s_axi_bid(inport_bid_o),
    .s_axi_bresp(inport_bresp_o),
    .s_axi_bvalid(inport_bvalid_o),
    //
    .s_axi_arid(inport_arid_i),
    .s_axi_araddr(inport_araddr_i[27:0]),
    .s_axi_arlen(inport_arlen_i),
    .s_axi_arsize(3'b010),
    .s_axi_arburst(inport_arburst_i),
    .s_axi_arlock(1'b0),
    .s_axi_arcache(4'h2),
    .s_axi_arprot(3'b010),
    .s_axi_arqos(4'h0),
    .s_axi_arvalid(inport_arvalid_i),
    .s_axi_arready(inport_arready_o),
    // 
    .s_axi_rready(inport_rready_i),
    .s_axi_rid(inport_rid_o),
    .s_axi_rdata(inport_rdata_o),
    .s_axi_rresp(inport_rresp_o),
    .s_axi_rlast(inport_rlast_o),
    .s_axi_rvalid(inport_rvalid_o),
    .init_calib_complete(init_calib_complete),
    .sys_rst(1'b1),
    .device_temp(w_device_temp)
);

// Convert from active low to active high, *and* hold the system in
// reset until the memory comes up. 
reg sys_rst_o;
initial sys_rst_o = 1'b1;
always @(posedge clk_out_o)
    sys_rst_o <= w_sys_reset || (!init_calib_complete) || (!mmcm_locked);

assign rst_out_o = sys_rst_o;

endmodule
