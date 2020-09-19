//-----------------------------------------------------------------
//                     Basic Peripheral SoC
//                           V1.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2020
//
//                 Email: admin@ultra-embedded.com
//
//                         License: GPL
// If you would like a version with a more permissive license for
// use in closed source commercial applications please contact me
// for details.
//-----------------------------------------------------------------
//
// This file is open source HDL; you can redistribute it and/or 
// modify it under the terms of the GNU General Public License as 
// published by the Free Software Foundation; either version 2 of 
// the License, or (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public 
// License along with this file; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
//-----------------------------------------------------------------

//-----------------------------------------------------------------
//                          Generated File
//-----------------------------------------------------------------

module soc_axi_arb
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport0_awvalid_i
    ,input  [ 31:0]  inport0_awaddr_i
    ,input  [  3:0]  inport0_awid_i
    ,input  [  7:0]  inport0_awlen_i
    ,input  [  1:0]  inport0_awburst_i
    ,input           inport0_wvalid_i
    ,input  [ 31:0]  inport0_wdata_i
    ,input  [  3:0]  inport0_wstrb_i
    ,input           inport0_wlast_i
    ,input           inport0_bready_i
    ,input           inport0_arvalid_i
    ,input  [ 31:0]  inport0_araddr_i
    ,input  [  3:0]  inport0_arid_i
    ,input  [  7:0]  inport0_arlen_i
    ,input  [  1:0]  inport0_arburst_i
    ,input           inport0_rready_i
    ,input           inport1_awvalid_i
    ,input  [ 31:0]  inport1_awaddr_i
    ,input  [  3:0]  inport1_awid_i
    ,input  [  7:0]  inport1_awlen_i
    ,input  [  1:0]  inport1_awburst_i
    ,input           inport1_wvalid_i
    ,input  [ 31:0]  inport1_wdata_i
    ,input  [  3:0]  inport1_wstrb_i
    ,input           inport1_wlast_i
    ,input           inport1_bready_i
    ,input           inport1_arvalid_i
    ,input  [ 31:0]  inport1_araddr_i
    ,input  [  3:0]  inport1_arid_i
    ,input  [  7:0]  inport1_arlen_i
    ,input  [  1:0]  inport1_arburst_i
    ,input           inport1_rready_i
    ,input           inport2_awvalid_i
    ,input  [ 31:0]  inport2_awaddr_i
    ,input  [  3:0]  inport2_awid_i
    ,input  [  7:0]  inport2_awlen_i
    ,input  [  1:0]  inport2_awburst_i
    ,input           inport2_wvalid_i
    ,input  [ 31:0]  inport2_wdata_i
    ,input  [  3:0]  inport2_wstrb_i
    ,input           inport2_wlast_i
    ,input           inport2_bready_i
    ,input           inport2_arvalid_i
    ,input  [ 31:0]  inport2_araddr_i
    ,input  [  3:0]  inport2_arid_i
    ,input  [  7:0]  inport2_arlen_i
    ,input  [  1:0]  inport2_arburst_i
    ,input           inport2_rready_i
    ,input           inport3_awvalid_i
    ,input  [ 31:0]  inport3_awaddr_i
    ,input  [  3:0]  inport3_awid_i
    ,input  [  7:0]  inport3_awlen_i
    ,input  [  1:0]  inport3_awburst_i
    ,input           inport3_wvalid_i
    ,input  [ 31:0]  inport3_wdata_i
    ,input  [  3:0]  inport3_wstrb_i
    ,input           inport3_wlast_i
    ,input           inport3_bready_i
    ,input           inport3_arvalid_i
    ,input  [ 31:0]  inport3_araddr_i
    ,input  [  3:0]  inport3_arid_i
    ,input  [  7:0]  inport3_arlen_i
    ,input  [  1:0]  inport3_arburst_i
    ,input           inport3_rready_i
    ,input           inport4_awvalid_i
    ,input  [ 31:0]  inport4_awaddr_i
    ,input  [  3:0]  inport4_awid_i
    ,input  [  7:0]  inport4_awlen_i
    ,input  [  1:0]  inport4_awburst_i
    ,input           inport4_wvalid_i
    ,input  [ 31:0]  inport4_wdata_i
    ,input  [  3:0]  inport4_wstrb_i
    ,input           inport4_wlast_i
    ,input           inport4_bready_i
    ,input           inport4_arvalid_i
    ,input  [ 31:0]  inport4_araddr_i
    ,input  [  3:0]  inport4_arid_i
    ,input  [  7:0]  inport4_arlen_i
    ,input  [  1:0]  inport4_arburst_i
    ,input           inport4_rready_i
    ,input           inport5_awvalid_i
    ,input  [ 31:0]  inport5_awaddr_i
    ,input  [  3:0]  inport5_awid_i
    ,input  [  7:0]  inport5_awlen_i
    ,input  [  1:0]  inport5_awburst_i
    ,input           inport5_wvalid_i
    ,input  [ 31:0]  inport5_wdata_i
    ,input  [  3:0]  inport5_wstrb_i
    ,input           inport5_wlast_i
    ,input           inport5_bready_i
    ,input           inport5_arvalid_i
    ,input  [ 31:0]  inport5_araddr_i
    ,input  [  3:0]  inport5_arid_i
    ,input  [  7:0]  inport5_arlen_i
    ,input  [  1:0]  inport5_arburst_i
    ,input           inport5_rready_i
    ,input           inport6_awvalid_i
    ,input  [ 31:0]  inport6_awaddr_i
    ,input  [  3:0]  inport6_awid_i
    ,input  [  7:0]  inport6_awlen_i
    ,input  [  1:0]  inport6_awburst_i
    ,input           inport6_wvalid_i
    ,input  [ 31:0]  inport6_wdata_i
    ,input  [  3:0]  inport6_wstrb_i
    ,input           inport6_wlast_i
    ,input           inport6_bready_i
    ,input           inport6_arvalid_i
    ,input  [ 31:0]  inport6_araddr_i
    ,input  [  3:0]  inport6_arid_i
    ,input  [  7:0]  inport6_arlen_i
    ,input  [  1:0]  inport6_arburst_i
    ,input           inport6_rready_i
    ,input           inport7_awvalid_i
    ,input  [ 31:0]  inport7_awaddr_i
    ,input  [  3:0]  inport7_awid_i
    ,input  [  7:0]  inport7_awlen_i
    ,input  [  1:0]  inport7_awburst_i
    ,input           inport7_wvalid_i
    ,input  [ 31:0]  inport7_wdata_i
    ,input  [  3:0]  inport7_wstrb_i
    ,input           inport7_wlast_i
    ,input           inport7_bready_i
    ,input           inport7_arvalid_i
    ,input  [ 31:0]  inport7_araddr_i
    ,input  [  3:0]  inport7_arid_i
    ,input  [  7:0]  inport7_arlen_i
    ,input  [  1:0]  inport7_arburst_i
    ,input           inport7_rready_i
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
    ,output          inport0_awready_o
    ,output          inport0_wready_o
    ,output          inport0_bvalid_o
    ,output [  1:0]  inport0_bresp_o
    ,output [  3:0]  inport0_bid_o
    ,output          inport0_arready_o
    ,output          inport0_rvalid_o
    ,output [ 31:0]  inport0_rdata_o
    ,output [  1:0]  inport0_rresp_o
    ,output [  3:0]  inport0_rid_o
    ,output          inport0_rlast_o
    ,output          inport1_awready_o
    ,output          inport1_wready_o
    ,output          inport1_bvalid_o
    ,output [  1:0]  inport1_bresp_o
    ,output [  3:0]  inport1_bid_o
    ,output          inport1_arready_o
    ,output          inport1_rvalid_o
    ,output [ 31:0]  inport1_rdata_o
    ,output [  1:0]  inport1_rresp_o
    ,output [  3:0]  inport1_rid_o
    ,output          inport1_rlast_o
    ,output          inport2_awready_o
    ,output          inport2_wready_o
    ,output          inport2_bvalid_o
    ,output [  1:0]  inport2_bresp_o
    ,output [  3:0]  inport2_bid_o
    ,output          inport2_arready_o
    ,output          inport2_rvalid_o
    ,output [ 31:0]  inport2_rdata_o
    ,output [  1:0]  inport2_rresp_o
    ,output [  3:0]  inport2_rid_o
    ,output          inport2_rlast_o
    ,output          inport3_awready_o
    ,output          inport3_wready_o
    ,output          inport3_bvalid_o
    ,output [  1:0]  inport3_bresp_o
    ,output [  3:0]  inport3_bid_o
    ,output          inport3_arready_o
    ,output          inport3_rvalid_o
    ,output [ 31:0]  inport3_rdata_o
    ,output [  1:0]  inport3_rresp_o
    ,output [  3:0]  inport3_rid_o
    ,output          inport3_rlast_o
    ,output          inport4_awready_o
    ,output          inport4_wready_o
    ,output          inport4_bvalid_o
    ,output [  1:0]  inport4_bresp_o
    ,output [  3:0]  inport4_bid_o
    ,output          inport4_arready_o
    ,output          inport4_rvalid_o
    ,output [ 31:0]  inport4_rdata_o
    ,output [  1:0]  inport4_rresp_o
    ,output [  3:0]  inport4_rid_o
    ,output          inport4_rlast_o
    ,output          inport5_awready_o
    ,output          inport5_wready_o
    ,output          inport5_bvalid_o
    ,output [  1:0]  inport5_bresp_o
    ,output [  3:0]  inport5_bid_o
    ,output          inport5_arready_o
    ,output          inport5_rvalid_o
    ,output [ 31:0]  inport5_rdata_o
    ,output [  1:0]  inport5_rresp_o
    ,output [  3:0]  inport5_rid_o
    ,output          inport5_rlast_o
    ,output          inport6_awready_o
    ,output          inport6_wready_o
    ,output          inport6_bvalid_o
    ,output [  1:0]  inport6_bresp_o
    ,output [  3:0]  inport6_bid_o
    ,output          inport6_arready_o
    ,output          inport6_rvalid_o
    ,output [ 31:0]  inport6_rdata_o
    ,output [  1:0]  inport6_rresp_o
    ,output [  3:0]  inport6_rid_o
    ,output          inport6_rlast_o
    ,output          inport7_awready_o
    ,output          inport7_wready_o
    ,output          inport7_bvalid_o
    ,output [  1:0]  inport7_bresp_o
    ,output [  3:0]  inport7_bid_o
    ,output          inport7_arready_o
    ,output          inport7_rvalid_o
    ,output [ 31:0]  inport7_rdata_o
    ,output [  1:0]  inport7_rresp_o
    ,output [  3:0]  inport7_rid_o
    ,output          inport7_rlast_o
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




//-----------------------------------------------------------------
// Read Requestor Select
//-----------------------------------------------------------------

wire [7:0] read_req_w;
reg                      read_hold_q;
wire [7:0] read_grant_w;

assign read_req_w[0] = inport0_arvalid_i;
assign read_req_w[1] = inport1_arvalid_i;
assign read_req_w[2] = inport2_arvalid_i;
assign read_req_w[3] = inport3_arvalid_i;
assign read_req_w[4] = inport4_arvalid_i;
assign read_req_w[5] = inport5_arvalid_i;
assign read_req_w[6] = inport6_arvalid_i;
assign read_req_w[7] = inport7_arvalid_i;

axi4_arb_onehot8
u_rd_arb
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .hold_i(read_hold_q),
    .request_i(read_req_w),
    .grant_o(read_grant_w)
);

//-----------------------------------------------------------------
// Read Hold
//-----------------------------------------------------------------
always @ (posedge clk_i )
if (rst_i)
    read_hold_q  <= 1'b0;
else if (outport_arvalid_o && !outport_arready_i)
    read_hold_q  <= 1'b1;
else if (outport_arready_i)
    read_hold_q  <= 1'b0;

//-----------------------------------------------------------------
// Read Request Mux
//-----------------------------------------------------------------
reg          outport_arvalid_r;
reg [ 31:0]  outport_araddr_r;
reg [  3:0]  outport_arid_r;
reg [  7:0]  outport_arlen_r;
reg [  1:0]  outport_arburst_r;

always @ *
begin
    outport_arvalid_r = 1'b0;
    outport_araddr_r  = 32'b0;
    outport_arid_r    = 4'b0;
    outport_arlen_r   = 8'b0;
    outport_arburst_r = 2'b0;

    case (1'b1)
    default: // Input 0
    begin
        outport_arvalid_r = inport0_arvalid_i;
        outport_araddr_r  = inport0_araddr_i;
        outport_arid_r    = inport0_arid_i;
        outport_arlen_r   = inport0_arlen_i;
        outport_arburst_r = inport0_arburst_i;
    end
    read_grant_w[1]:
    begin
        outport_arvalid_r = inport1_arvalid_i;
        outport_araddr_r  = inport1_araddr_i;
        outport_arid_r    = inport1_arid_i;
        outport_arlen_r   = inport1_arlen_i;
        outport_arburst_r = inport1_arburst_i;
    end
    read_grant_w[2]:
    begin
        outport_arvalid_r = inport2_arvalid_i;
        outport_araddr_r  = inport2_araddr_i;
        outport_arid_r    = inport2_arid_i;
        outport_arlen_r   = inport2_arlen_i;
        outport_arburst_r = inport2_arburst_i;
    end
    read_grant_w[3]:
    begin
        outport_arvalid_r = inport3_arvalid_i;
        outport_araddr_r  = inport3_araddr_i;
        outport_arid_r    = inport3_arid_i;
        outport_arlen_r   = inport3_arlen_i;
        outport_arburst_r = inport3_arburst_i;
    end
    read_grant_w[4]:
    begin
        outport_arvalid_r = inport4_arvalid_i;
        outport_araddr_r  = inport4_araddr_i;
        outport_arid_r    = inport4_arid_i;
        outport_arlen_r   = inport4_arlen_i;
        outport_arburst_r = inport4_arburst_i;
    end
    read_grant_w[5]:
    begin
        outport_arvalid_r = inport5_arvalid_i;
        outport_araddr_r  = inport5_araddr_i;
        outport_arid_r    = inport5_arid_i;
        outport_arlen_r   = inport5_arlen_i;
        outport_arburst_r = inport5_arburst_i;
    end
    read_grant_w[6]:
    begin
        outport_arvalid_r = inport6_arvalid_i;
        outport_araddr_r  = inport6_araddr_i;
        outport_arid_r    = inport6_arid_i;
        outport_arlen_r   = inport6_arlen_i;
        outport_arburst_r = inport6_arburst_i;
    end
    read_grant_w[7]:
    begin
        outport_arvalid_r = inport7_arvalid_i;
        outport_araddr_r  = inport7_araddr_i;
        outport_arid_r    = inport7_arid_i;
        outport_arlen_r   = inport7_arlen_i;
        outport_arburst_r = inport7_arburst_i;
    end
    endcase
end

assign outport_arvalid_o = outport_arvalid_r;
assign outport_araddr_o  = outport_araddr_r;
assign outport_arid_o    = outport_arid_r;
assign outport_arlen_o   = outport_arlen_r;
assign outport_arburst_o = outport_arburst_r;

//-----------------------------------------------------------------
// Read Handshaking Demux
//-----------------------------------------------------------------
assign inport0_arready_o = read_grant_w[0] ? outport_arready_i : 1'b0;
assign inport1_arready_o = read_grant_w[1] ? outport_arready_i : 1'b0;
assign inport2_arready_o = read_grant_w[2] ? outport_arready_i : 1'b0;
assign inport3_arready_o = read_grant_w[3] ? outport_arready_i : 1'b0;
assign inport4_arready_o = read_grant_w[4] ? outport_arready_i : 1'b0;
assign inport5_arready_o = read_grant_w[5] ? outport_arready_i : 1'b0;
assign inport6_arready_o = read_grant_w[6] ? outport_arready_i : 1'b0;
assign inport7_arready_o = read_grant_w[7] ? outport_arready_i : 1'b0;

//-----------------------------------------------------------------
// Read Response Routing
//-----------------------------------------------------------------
reg [7:0] rd_resp_target_r;

always @ *
begin
    rd_resp_target_r = 8'b0;

    case (outport_rid_i[3:1])
    3'd0:
        rd_resp_target_r[0] = 1'b1;
    3'd1:
        rd_resp_target_r[1] = 1'b1;
    3'd2:
        rd_resp_target_r[2] = 1'b1;
    3'd3:
        rd_resp_target_r[3] = 1'b1;
    3'd4:
        rd_resp_target_r[4] = 1'b1;
    3'd5:
        rd_resp_target_r[5] = 1'b1;
    3'd6:
        rd_resp_target_r[6] = 1'b1;
    3'd7:
        rd_resp_target_r[7] = 1'b1;
    default:
        rd_resp_target_r[0] = 1'b1;
    endcase
end

wire [7:0] inport_rready_w;
assign inport_rready_w[0] = inport0_rready_i;
assign inport_rready_w[1] = inport1_rready_i;
assign inport_rready_w[2] = inport2_rready_i;
assign inport_rready_w[3] = inport3_rready_i;
assign inport_rready_w[4] = inport4_rready_i;
assign inport_rready_w[5] = inport5_rready_i;
assign inport_rready_w[6] = inport6_rready_i;
assign inport_rready_w[7] = inport7_rready_i;

assign outport_rready_o = (inport_rready_w & rd_resp_target_r) != 8'b0;


assign inport0_rvalid_o = outport_rvalid_i & rd_resp_target_r[0];
assign inport0_rdata_o  = outport_rdata_i;
assign inport0_rid_o    = outport_rid_i;
assign inport0_rresp_o  = outport_rresp_i;
assign inport0_rlast_o  = outport_rlast_i;
assign inport1_rvalid_o = outport_rvalid_i & rd_resp_target_r[1];
assign inport1_rdata_o  = outport_rdata_i;
assign inport1_rid_o    = outport_rid_i;
assign inport1_rresp_o  = outport_rresp_i;
assign inport1_rlast_o  = outport_rlast_i;
assign inport2_rvalid_o = outport_rvalid_i & rd_resp_target_r[2];
assign inport2_rdata_o  = outport_rdata_i;
assign inport2_rid_o    = outport_rid_i;
assign inport2_rresp_o  = outport_rresp_i;
assign inport2_rlast_o  = outport_rlast_i;
assign inport3_rvalid_o = outport_rvalid_i & rd_resp_target_r[3];
assign inport3_rdata_o  = outport_rdata_i;
assign inport3_rid_o    = outport_rid_i;
assign inport3_rresp_o  = outport_rresp_i;
assign inport3_rlast_o  = outport_rlast_i;
assign inport4_rvalid_o = outport_rvalid_i & rd_resp_target_r[4];
assign inport4_rdata_o  = outport_rdata_i;
assign inport4_rid_o    = outport_rid_i;
assign inport4_rresp_o  = outport_rresp_i;
assign inport4_rlast_o  = outport_rlast_i;
assign inport5_rvalid_o = outport_rvalid_i & rd_resp_target_r[5];
assign inport5_rdata_o  = outport_rdata_i;
assign inport5_rid_o    = outport_rid_i;
assign inport5_rresp_o  = outport_rresp_i;
assign inport5_rlast_o  = outport_rlast_i;
assign inport6_rvalid_o = outport_rvalid_i & rd_resp_target_r[6];
assign inport6_rdata_o  = outport_rdata_i;
assign inport6_rid_o    = outport_rid_i;
assign inport6_rresp_o  = outport_rresp_i;
assign inport6_rlast_o  = outport_rlast_i;
assign inport7_rvalid_o = outport_rvalid_i & rd_resp_target_r[7];
assign inport7_rdata_o  = outport_rdata_i;
assign inport7_rid_o    = outport_rid_i;
assign inport7_rresp_o  = outport_rresp_i;
assign inport7_rlast_o  = outport_rlast_i;

//-----------------------------------------------------------------
// Write Requestor Select
//-----------------------------------------------------------------
wire [7:0] write_req_w;
reg        write_hold_q;

wire [7:0] write_grant_w;

assign write_req_w[0] = inport0_awvalid_i;
assign write_req_w[1] = inport1_awvalid_i;
assign write_req_w[2] = inport2_awvalid_i;
assign write_req_w[3] = inport3_awvalid_i;
assign write_req_w[4] = inport4_awvalid_i;
assign write_req_w[5] = inport5_awvalid_i;
assign write_req_w[6] = inport6_awvalid_i;
assign write_req_w[7] = inport7_awvalid_i;

axi4_arb_onehot8
u_wr_arb
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .hold_i(write_hold_q),
    .request_i(write_req_w),
    .grant_o(write_grant_w)
);

//-----------------------------------------------------------------
// Write state tracking
//-----------------------------------------------------------------
reg awvalid_q;
reg wvalid_q;
reg wlast_q;

wire wr_cmd_accepted_w  = (outport_awvalid_o && outport_awready_i) || awvalid_q;
wire wr_data_accepted_w = (outport_wvalid_o  && outport_wready_i)  || wvalid_q;
wire wr_data_last_w     = (wvalid_q & wlast_q) || (outport_wvalid_o && outport_wready_i && outport_wlast_o);

always @ (posedge clk_i )
if (rst_i)
    awvalid_q <= 1'b0;
else if (outport_awvalid_o && outport_awready_i && (!wr_data_accepted_w || !wr_data_last_w))
    awvalid_q <= 1'b1;
else if (wr_data_accepted_w && wr_data_last_w)
    awvalid_q <= 1'b0;

always @ (posedge clk_i )
if (rst_i)
    wvalid_q <= 1'b0;
else if (outport_wvalid_o && outport_wready_i && !wr_cmd_accepted_w)
    wvalid_q <= 1'b1;
else if (wr_cmd_accepted_w)
    wvalid_q <= 1'b0;

always @ (posedge clk_i )
if (rst_i)
    wlast_q <= 1'b0;
else if (outport_wvalid_o && outport_wready_i)
    wlast_q <= outport_wlast_o;

//-----------------------------------------------------------------
// Write Hold
//-----------------------------------------------------------------
reg write_hold_r;

always @ *
begin
    write_hold_r = write_hold_q;

    // Write hold - check for both command and data (last) accepted
    if (write_hold_r)
    begin
        if (wr_cmd_accepted_w && wr_data_accepted_w && wr_data_last_w)
            write_hold_r = 1'b0;
    end
    // Single transaction accepted in one go - no hold
    else if (wr_cmd_accepted_w && wr_data_accepted_w && wr_data_last_w)
        write_hold_r = 1'b0;
    // Either command or data presented - hold until transaction complete
    else if (outport_awvalid_o || outport_wvalid_o)
        write_hold_r = 1'b1;
end

always @ (posedge clk_i )
if (rst_i)
    write_hold_q      <= 1'b0;
else
    write_hold_q      <= write_hold_r;

//-----------------------------------------------------------------
// Write Request Mux
//-----------------------------------------------------------------
reg          outport_awvalid_r;
reg [ 31:0]  outport_awaddr_r;
reg [  3:0]  outport_awid_r;
reg [  7:0]  outport_awlen_r;
reg [  1:0]  outport_awburst_r;

reg          outport_wvalid_r;
reg [ 31:0]  outport_wdata_r;
reg [  3:0]  outport_wstrb_r;
reg          outport_wlast_r;

always @ *
begin
    outport_awvalid_r = 1'b0;
    outport_awaddr_r  = 32'b0;
    outport_awid_r    = 4'b0;
    outport_awlen_r   = 8'b0;
    outport_awburst_r = 2'b0;
    outport_wvalid_r  = 1'b0;
    outport_wdata_r   = 32'b0;
    outport_wstrb_r   = 4'b0;
    outport_wlast_r   = 1'b0;

    case (1'b1)
    default: // Input 0
    begin
        outport_awvalid_r = inport0_awvalid_i;
        outport_awaddr_r  = inport0_awaddr_i;
        outport_awid_r    = inport0_awid_i;
        outport_awlen_r   = inport0_awlen_i;
        outport_awburst_r = inport0_awburst_i;
        outport_wvalid_r  = inport0_wvalid_i;
        outport_wdata_r   = inport0_wdata_i;
        outport_wstrb_r   = inport0_wstrb_i;
        outport_wlast_r   = inport0_wlast_i;
    end
    write_grant_w[1]:
    begin
        outport_awvalid_r = inport1_awvalid_i;
        outport_awaddr_r  = inport1_awaddr_i;
        outport_awid_r    = inport1_awid_i;
        outport_awlen_r   = inport1_awlen_i;
        outport_awburst_r = inport1_awburst_i;
        outport_wvalid_r  = inport1_wvalid_i;
        outport_wdata_r   = inport1_wdata_i;
        outport_wstrb_r   = inport1_wstrb_i;
        outport_wlast_r   = inport1_wlast_i;
    end
    write_grant_w[2]:
    begin
        outport_awvalid_r = inport2_awvalid_i;
        outport_awaddr_r  = inport2_awaddr_i;
        outport_awid_r    = inport2_awid_i;
        outport_awlen_r   = inport2_awlen_i;
        outport_awburst_r = inport2_awburst_i;
        outport_wvalid_r  = inport2_wvalid_i;
        outport_wdata_r   = inport2_wdata_i;
        outport_wstrb_r   = inport2_wstrb_i;
        outport_wlast_r   = inport2_wlast_i;
    end
    write_grant_w[3]:
    begin
        outport_awvalid_r = inport3_awvalid_i;
        outport_awaddr_r  = inport3_awaddr_i;
        outport_awid_r    = inport3_awid_i;
        outport_awlen_r   = inport3_awlen_i;
        outport_awburst_r = inport3_awburst_i;
        outport_wvalid_r  = inport3_wvalid_i;
        outport_wdata_r   = inport3_wdata_i;
        outport_wstrb_r   = inport3_wstrb_i;
        outport_wlast_r   = inport3_wlast_i;
    end
    write_grant_w[4]:
    begin
        outport_awvalid_r = inport4_awvalid_i;
        outport_awaddr_r  = inport4_awaddr_i;
        outport_awid_r    = inport4_awid_i;
        outport_awlen_r   = inport4_awlen_i;
        outport_awburst_r = inport4_awburst_i;
        outport_wvalid_r  = inport4_wvalid_i;
        outport_wdata_r   = inport4_wdata_i;
        outport_wstrb_r   = inport4_wstrb_i;
        outport_wlast_r   = inport4_wlast_i;
    end
    write_grant_w[5]:
    begin
        outport_awvalid_r = inport5_awvalid_i;
        outport_awaddr_r  = inport5_awaddr_i;
        outport_awid_r    = inport5_awid_i;
        outport_awlen_r   = inport5_awlen_i;
        outport_awburst_r = inport5_awburst_i;
        outport_wvalid_r  = inport5_wvalid_i;
        outport_wdata_r   = inport5_wdata_i;
        outport_wstrb_r   = inport5_wstrb_i;
        outport_wlast_r   = inport5_wlast_i;
    end
    write_grant_w[6]:
    begin
        outport_awvalid_r = inport6_awvalid_i;
        outport_awaddr_r  = inport6_awaddr_i;
        outport_awid_r    = inport6_awid_i;
        outport_awlen_r   = inport6_awlen_i;
        outport_awburst_r = inport6_awburst_i;
        outport_wvalid_r  = inport6_wvalid_i;
        outport_wdata_r   = inport6_wdata_i;
        outport_wstrb_r   = inport6_wstrb_i;
        outport_wlast_r   = inport6_wlast_i;
    end
    write_grant_w[7]:
    begin
        outport_awvalid_r = inport7_awvalid_i;
        outport_awaddr_r  = inport7_awaddr_i;
        outport_awid_r    = inport7_awid_i;
        outport_awlen_r   = inport7_awlen_i;
        outport_awburst_r = inport7_awburst_i;
        outport_wvalid_r  = inport7_wvalid_i;
        outport_wdata_r   = inport7_wdata_i;
        outport_wstrb_r   = inport7_wstrb_i;
        outport_wlast_r   = inport7_wlast_i;
    end
    endcase
end

assign outport_awvalid_o = outport_awvalid_r & ~awvalid_q;
assign outport_awaddr_o  = outport_awaddr_r;
assign outport_awid_o    = outport_awid_r;
assign outport_awlen_o   = outport_awlen_r;
assign outport_awburst_o = outport_awburst_r;
assign outport_wvalid_o  = outport_wvalid_r & ~wvalid_q;
assign outport_wdata_o   = outport_wdata_r;
assign outport_wstrb_o   = outport_wstrb_r;
assign outport_wlast_o   = outport_wlast_r;

//-----------------------------------------------------------------
// Write Handshaking Demux
//-----------------------------------------------------------------
assign inport0_awready_o = write_grant_w[0] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport0_wready_o  = write_grant_w[0] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport1_awready_o = write_grant_w[1] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport1_wready_o  = write_grant_w[1] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport2_awready_o = write_grant_w[2] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport2_wready_o  = write_grant_w[2] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport3_awready_o = write_grant_w[3] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport3_wready_o  = write_grant_w[3] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport4_awready_o = write_grant_w[4] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport4_wready_o  = write_grant_w[4] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport5_awready_o = write_grant_w[5] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport5_wready_o  = write_grant_w[5] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport6_awready_o = write_grant_w[6] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport6_wready_o  = write_grant_w[6] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;
assign inport7_awready_o = write_grant_w[7] ? (outport_awready_i & ~awvalid_q) : 1'b0;
assign inport7_wready_o  = write_grant_w[7] ? (outport_wready_i  & ~wvalid_q)  : 1'b0;

//-----------------------------------------------------------------
// Write Response Routing
//-----------------------------------------------------------------
reg [7:0] wr_resp_target_r;

always @ *
begin
    wr_resp_target_r = 8'b0;

    case (outport_bid_i[3:1])
    3'd0:
        wr_resp_target_r[0] = 1'b1;
    3'd1:
        wr_resp_target_r[1] = 1'b1;
    3'd2:
        wr_resp_target_r[2] = 1'b1;
    3'd3:
        wr_resp_target_r[3] = 1'b1;
    3'd4:
        wr_resp_target_r[4] = 1'b1;
    3'd5:
        wr_resp_target_r[5] = 1'b1;
    3'd6:
        wr_resp_target_r[6] = 1'b1;
    3'd7:
        wr_resp_target_r[7] = 1'b1;
    default:
        wr_resp_target_r[0] = 1'b1;
    endcase
end

wire [7:0] inport_bready_w;
assign inport_bready_w[0] = inport0_bready_i;
assign inport_bready_w[1] = inport1_bready_i;
assign inport_bready_w[2] = inport2_bready_i;
assign inport_bready_w[3] = inport3_bready_i;
assign inport_bready_w[4] = inport4_bready_i;
assign inport_bready_w[5] = inport5_bready_i;
assign inport_bready_w[6] = inport6_bready_i;
assign inport_bready_w[7] = inport7_bready_i;

assign outport_bready_o = (inport_bready_w & wr_resp_target_r) != 8'b0;

assign inport0_bvalid_o = outport_bvalid_i & wr_resp_target_r[0];
assign inport0_bid_o    = outport_bid_i;
assign inport0_bresp_o  = outport_bresp_i;
assign inport1_bvalid_o = outport_bvalid_i & wr_resp_target_r[1];
assign inport1_bid_o    = outport_bid_i;
assign inport1_bresp_o  = outport_bresp_i;
assign inport2_bvalid_o = outport_bvalid_i & wr_resp_target_r[2];
assign inport2_bid_o    = outport_bid_i;
assign inport2_bresp_o  = outport_bresp_i;
assign inport3_bvalid_o = outport_bvalid_i & wr_resp_target_r[3];
assign inport3_bid_o    = outport_bid_i;
assign inport3_bresp_o  = outport_bresp_i;
assign inport4_bvalid_o = outport_bvalid_i & wr_resp_target_r[4];
assign inport4_bid_o    = outport_bid_i;
assign inport4_bresp_o  = outport_bresp_i;
assign inport5_bvalid_o = outport_bvalid_i & wr_resp_target_r[5];
assign inport5_bid_o    = outport_bid_i;
assign inport5_bresp_o  = outport_bresp_i;
assign inport6_bvalid_o = outport_bvalid_i & wr_resp_target_r[6];
assign inport6_bid_o    = outport_bid_i;
assign inport6_bresp_o  = outport_bresp_i;
assign inport7_bvalid_o = outport_bvalid_i & wr_resp_target_r[7];
assign inport7_bid_o    = outport_bid_i;
assign inport7_bresp_o  = outport_bresp_i;

endmodule

//-----------------------------------------------------------------
// Round robin One Hot Arbiter
//-----------------------------------------------------------------
module axi4_arb_onehot8
(
    // Inputs
     input                       clk_i
    ,input                       rst_i
    ,input                       hold_i
    ,input  [7:0]  request_i

    // Outputs
    ,output [7:0]  grant_o
);


//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
wire [7:0] req_ffs_masked_w;
wire [7:0] req_ffs_unmasked_w;
wire [7:0] req_ffs_w;

reg  [7:0] mask_next_q;
reg  [7:0] grant_last_q;
wire [7:0] grant_new_w;

//-----------------------------------------------------------------
// ffs: Find first set
//-----------------------------------------------------------------
function [7:0] ffs;
    input [7:0] request;
begin
    ffs[0] = request[0];
    ffs[1] = ffs[0] | request[1];
    ffs[2] = ffs[1] | request[2];
    ffs[3] = ffs[2] | request[3];
    ffs[4] = ffs[3] | request[4];
    ffs[5] = ffs[4] | request[5];
    ffs[6] = ffs[5] | request[6];
    ffs[7] = ffs[6] | request[7];
end
endfunction

assign req_ffs_masked_w = ffs(request_i & mask_next_q);
assign req_ffs_unmasked_w = ffs(request_i);

assign req_ffs_w = (|req_ffs_masked_w) ? req_ffs_masked_w : req_ffs_unmasked_w;

always @ (posedge clk_i )
   if (rst_i == 1'b1)
   begin
        mask_next_q <= {8{1'b1}};
        grant_last_q <= 8'b0;
   end
   else
   begin
        if (~hold_i)
            mask_next_q <= {req_ffs_w[6:0], 1'b0};
        
        grant_last_q <= grant_o;
   end

assign grant_new_w = req_ffs_w ^ {req_ffs_w[6:0], 1'b0};
assign grant_o = hold_i ? grant_last_q : grant_new_w;


endmodule
