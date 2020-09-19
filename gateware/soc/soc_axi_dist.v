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

module soc_axi_dist
(
    // Inputs
     input           clk_i
    ,input           rst_i
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
    ,input           outport_peripheral0_awready_i
    ,input           outport_peripheral0_wready_i
    ,input           outport_peripheral0_bvalid_i
    ,input  [  1:0]  outport_peripheral0_bresp_i
    ,input           outport_peripheral0_arready_i
    ,input           outport_peripheral0_rvalid_i
    ,input  [ 31:0]  outport_peripheral0_rdata_i
    ,input  [  1:0]  outport_peripheral0_rresp_i

    // Outputs
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
    ,output          outport_peripheral0_awvalid_o
    ,output [ 31:0]  outport_peripheral0_awaddr_o
    ,output          outport_peripheral0_wvalid_o
    ,output [ 31:0]  outport_peripheral0_wdata_o
    ,output [  3:0]  outport_peripheral0_wstrb_o
    ,output          outport_peripheral0_bready_o
    ,output          outport_peripheral0_arvalid_o
    ,output [ 31:0]  outport_peripheral0_araddr_o
    ,output          outport_peripheral0_rready_o
);



`define ADDR_SEL_W         1
`define PERIPH0_ADDR         32'h90000000
`define PERIPH0_MASK         32'hf0000000

//-----------------------------------------------------------------
// AXI: Read
//-----------------------------------------------------------------
reg [3:0]              read_pending_q;
reg [3:0]              read_pending_r;
reg [3:0]              arid_q;
reg [`ADDR_SEL_W-1:0]  read_port_q;
reg [`ADDR_SEL_W-1:0]  read_port_r;

always @ *
begin
    read_port_r = `ADDR_SEL_W'b0;
    if ((inport_araddr_i & `PERIPH0_MASK) == `PERIPH0_ADDR) read_port_r = `ADDR_SEL_W'd1;
end

wire read_incr_w = (inport_arvalid_i && inport_arready_o);
wire read_decr_w = (inport_rvalid_o  && inport_rlast_o && inport_rready_i);

always @ *
begin
    read_pending_r = read_pending_q;

    if (read_incr_w && !read_decr_w)
        read_pending_r = read_pending_r + 4'd1;
    else if (!read_incr_w && read_decr_w)
        read_pending_r = read_pending_r - 4'd1;
end

always @ (posedge clk_i )
if (rst_i)
begin
    read_pending_q <= 4'b0;
    arid_q         <= 4'b0;
    read_port_q    <= `ADDR_SEL_W'b0;
end
else 
begin
    read_pending_q <= read_pending_r;

    // Read command accepted
    if (inport_arvalid_i && inport_arready_o)
    begin
        arid_q      <= inport_arid_i;
        read_port_q <= read_port_r;
    end
end

wire read_accept_w       = (read_port_q == read_port_r && read_pending_q != 4'hF) || (read_pending_q == 4'h0);

assign outport_arvalid_o = inport_arvalid_i & read_accept_w & (read_port_r == `ADDR_SEL_W'd0);
assign outport_araddr_o  = inport_araddr_i;
assign outport_arid_o    = inport_arid_i;
assign outport_arlen_o   = inport_arlen_i;
assign outport_arburst_o = inport_arburst_i;
assign outport_rready_o  = inport_rready_i;

assign outport_peripheral0_arvalid_o = inport_arvalid_i & read_accept_w & (read_port_r == `ADDR_SEL_W'd1);
assign outport_peripheral0_araddr_o  = inport_araddr_i;
assign outport_peripheral0_rready_o  = inport_rready_i;

reg        outport_rvalid_r;
reg [31:0] outport_rdata_r;
reg [1:0]  outport_rresp_r;
reg [3:0]  outport_rid_r;
reg        outport_rlast_r;

always @ *
begin
    case (read_port_q)
    `ADDR_SEL_W'd1:
    begin
        outport_rvalid_r = outport_peripheral0_rvalid_i;
        outport_rdata_r  = outport_peripheral0_rdata_i;
        outport_rresp_r  = outport_peripheral0_rresp_i;
        outport_rid_r    = arid_q;
        outport_rlast_r  = 1'b1;
    end
    default:
    begin
        outport_rvalid_r = outport_rvalid_i;
        outport_rdata_r  = outport_rdata_i;
        outport_rresp_r  = outport_rresp_i;
        outport_rid_r    = outport_rid_i;
        outport_rlast_r  = outport_rlast_i;
    end
    endcase
end

assign inport_rvalid_o  = outport_rvalid_r;
assign inport_rdata_o   = outport_rdata_r;
assign inport_rresp_o   = outport_rresp_r;
assign inport_rid_o     = outport_rid_r;
assign inport_rlast_o   = outport_rlast_r;

reg inport_arready_r;
always @ *
begin
    case (read_port_r)
    `ADDR_SEL_W'd1:
        inport_arready_r = outport_peripheral0_arready_i;
    default:
        inport_arready_r = outport_arready_i;
    endcase
end

assign inport_arready_o = read_accept_w & inport_arready_r;

//-------------------------------------------------------------
// Write Request
//-------------------------------------------------------------
reg awvalid_q;
reg wvalid_q;
reg wlast_q;

wire wr_cmd_accepted_w  = (inport_awvalid_i && inport_awready_o) || awvalid_q;
wire wr_data_accepted_w = (inport_wvalid_i  && inport_wready_o)  || wvalid_q;
wire wr_data_last_w     = (wvalid_q & wlast_q) || (inport_wvalid_i && inport_wready_o && inport_wlast_i);

always @ (posedge clk_i )
if (rst_i)
    awvalid_q <= 1'b0;
else if (inport_awvalid_i && inport_awready_o && (!wr_data_accepted_w || !wr_data_last_w))
    awvalid_q <= 1'b1;
else if (wr_data_accepted_w && wr_data_last_w)
    awvalid_q <= 1'b0;

always @ (posedge clk_i )
if (rst_i)
    wvalid_q <= 1'b0;
else if (inport_wvalid_i && inport_wready_o && !wr_cmd_accepted_w)
    wvalid_q <= 1'b1;
else if (wr_cmd_accepted_w)
    wvalid_q <= 1'b0;

always @ (posedge clk_i )
if (rst_i)
    wlast_q <= 1'b0;
else if (inport_wvalid_i && inport_wready_o)
    wlast_q <= inport_wlast_i;

//-----------------------------------------------------------------
// AXI: Write
//-----------------------------------------------------------------
reg [3:0]              write_pending_q;
reg [3:0]              write_pending_r;
reg [3:0]              awid_q;
reg [`ADDR_SEL_W-1:0]  write_port_q;
reg [`ADDR_SEL_W-1:0]  write_port_r;

always @ *
begin    
    if (inport_awvalid_i & ~awvalid_q)
    begin
        write_port_r = `ADDR_SEL_W'b0;
        if ((inport_awaddr_i & `PERIPH0_MASK) == `PERIPH0_ADDR) write_port_r = `ADDR_SEL_W'd1;
    end
    else
        write_port_r = write_port_q;
end

wire write_incr_w = (inport_awvalid_i && inport_awready_o);
wire write_decr_w = (inport_bvalid_o  && inport_bready_i);

always @ *
begin
    write_pending_r = write_pending_q;

    if (write_incr_w && !write_decr_w)
        write_pending_r = write_pending_r + 4'd1;
    else if (!write_incr_w && write_decr_w)
        write_pending_r = write_pending_r - 4'd1;
end

always @ (posedge clk_i )
if (rst_i)
begin
    write_pending_q <= 4'b0;
    awid_q          <= 4'b0;
    write_port_q    <= `ADDR_SEL_W'b0;
end
else 
begin
    write_pending_q <= write_pending_r;

    // Write command accepted
    if (inport_awvalid_i && inport_awready_o)
    begin
        awid_q       <= inport_awid_i;
        write_port_q <= write_port_r;
    end
end

wire write_accept_w      = (write_port_q == write_port_r && write_pending_q != 4'hF) || (write_pending_q == 4'h0);

assign outport_awvalid_o = inport_awvalid_i & ~awvalid_q & write_accept_w & (write_port_r == `ADDR_SEL_W'd0);
assign outport_awaddr_o  = inport_awaddr_i;
assign outport_awid_o    = inport_awid_i;
assign outport_awlen_o   = inport_awlen_i;
assign outport_awburst_o = inport_awburst_i;
assign outport_wvalid_o  = inport_wvalid_i & ~wvalid_q & (inport_awvalid_i || awvalid_q) & (write_port_r == `ADDR_SEL_W'd0);
assign outport_wdata_o   = inport_wdata_i;
assign outport_wstrb_o   = inport_wstrb_i;
assign outport_wlast_o   = inport_wlast_i;
assign outport_bready_o  = inport_bready_i;

assign outport_peripheral0_awvalid_o = inport_awvalid_i & ~awvalid_q & write_accept_w & (write_port_r == `ADDR_SEL_W'd1);
assign outport_peripheral0_awaddr_o  = inport_awaddr_i;
assign outport_peripheral0_wvalid_o  = inport_wvalid_i & ~wvalid_q & ((inport_awvalid_i && write_accept_w) || awvalid_q) & (write_port_r == `ADDR_SEL_W'd1);
assign outport_peripheral0_wdata_o   = inport_wdata_i;
assign outport_peripheral0_wstrb_o   = inport_wstrb_i;
assign outport_peripheral0_bready_o  = inport_bready_i;

reg        outport_bvalid_r;
reg [1:0]  outport_bresp_r;
reg [3:0]  outport_bid_r;

always @ *
begin
    case (write_port_q)
    `ADDR_SEL_W'd1:
    begin
        outport_bvalid_r = outport_peripheral0_bvalid_i;
        outport_bresp_r  = outport_peripheral0_bresp_i;
        outport_bid_r    = awid_q;
    end
    default:
    begin
        outport_bvalid_r = outport_bvalid_i;
        outport_bresp_r  = outport_bresp_i;
        outport_bid_r    = outport_bid_i;
    end
    endcase
end

assign inport_bvalid_o  = outport_bvalid_r;
assign inport_bresp_o   = outport_bresp_r;
assign inport_bid_o     = outport_bid_r;

reg inport_awready_r;
reg inport_wready_r;

always @ *
begin
    case (write_port_r)
    `ADDR_SEL_W'd1:
    begin
        inport_awready_r = outport_peripheral0_awready_i;
        inport_wready_r  = outport_peripheral0_wready_i;
    end
    default:
    begin
        inport_awready_r = outport_awready_i;
        inport_wready_r  = outport_wready_i;
    end        
    endcase
end

assign inport_awready_o = write_accept_w & ~awvalid_q & inport_awready_r;
assign inport_wready_o  = write_accept_w & ~wvalid_q & inport_wready_r;


endmodule
