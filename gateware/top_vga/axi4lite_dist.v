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

module axi4lite_dist
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport_awvalid_i
    ,input  [ 31:0]  inport_awaddr_i
    ,input           inport_wvalid_i
    ,input  [ 31:0]  inport_wdata_i
    ,input  [  3:0]  inport_wstrb_i
    ,input           inport_bready_i
    ,input           inport_arvalid_i
    ,input  [ 31:0]  inport_araddr_i
    ,input           inport_rready_i
    ,input           outport0_awready_i
    ,input           outport0_wready_i
    ,input           outport0_bvalid_i
    ,input  [  1:0]  outport0_bresp_i
    ,input           outport0_arready_i
    ,input           outport0_rvalid_i
    ,input  [ 31:0]  outport0_rdata_i
    ,input  [  1:0]  outport0_rresp_i
    ,input           outport1_awready_i
    ,input           outport1_wready_i
    ,input           outport1_bvalid_i
    ,input  [  1:0]  outport1_bresp_i
    ,input           outport1_arready_i
    ,input           outport1_rvalid_i
    ,input  [ 31:0]  outport1_rdata_i
    ,input  [  1:0]  outport1_rresp_i
    ,input           outport2_awready_i
    ,input           outport2_wready_i
    ,input           outport2_bvalid_i
    ,input  [  1:0]  outport2_bresp_i
    ,input           outport2_arready_i
    ,input           outport2_rvalid_i
    ,input  [ 31:0]  outport2_rdata_i
    ,input  [  1:0]  outport2_rresp_i
    ,input           outport3_awready_i
    ,input           outport3_wready_i
    ,input           outport3_bvalid_i
    ,input  [  1:0]  outport3_bresp_i
    ,input           outport3_arready_i
    ,input           outport3_rvalid_i
    ,input  [ 31:0]  outport3_rdata_i
    ,input  [  1:0]  outport3_rresp_i
    ,input           outport4_awready_i
    ,input           outport4_wready_i
    ,input           outport4_bvalid_i
    ,input  [  1:0]  outport4_bresp_i
    ,input           outport4_arready_i
    ,input           outport4_rvalid_i
    ,input  [ 31:0]  outport4_rdata_i
    ,input  [  1:0]  outport4_rresp_i
    ,input           outport5_awready_i
    ,input           outport5_wready_i
    ,input           outport5_bvalid_i
    ,input  [  1:0]  outport5_bresp_i
    ,input           outport5_arready_i
    ,input           outport5_rvalid_i
    ,input  [ 31:0]  outport5_rdata_i
    ,input  [  1:0]  outport5_rresp_i
    ,input           outport6_awready_i
    ,input           outport6_wready_i
    ,input           outport6_bvalid_i
    ,input  [  1:0]  outport6_bresp_i
    ,input           outport6_arready_i
    ,input           outport6_rvalid_i
    ,input  [ 31:0]  outport6_rdata_i
    ,input  [  1:0]  outport6_rresp_i
    ,input           outport7_awready_i
    ,input           outport7_wready_i
    ,input           outport7_bvalid_i
    ,input  [  1:0]  outport7_bresp_i
    ,input           outport7_arready_i
    ,input           outport7_rvalid_i
    ,input  [ 31:0]  outport7_rdata_i
    ,input  [  1:0]  outport7_rresp_i

    // Outputs
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output          outport0_awvalid_o
    ,output [ 31:0]  outport0_awaddr_o
    ,output          outport0_wvalid_o
    ,output [ 31:0]  outport0_wdata_o
    ,output [  3:0]  outport0_wstrb_o
    ,output          outport0_bready_o
    ,output          outport0_arvalid_o
    ,output [ 31:0]  outport0_araddr_o
    ,output          outport0_rready_o
    ,output          outport1_awvalid_o
    ,output [ 31:0]  outport1_awaddr_o
    ,output          outport1_wvalid_o
    ,output [ 31:0]  outport1_wdata_o
    ,output [  3:0]  outport1_wstrb_o
    ,output          outport1_bready_o
    ,output          outport1_arvalid_o
    ,output [ 31:0]  outport1_araddr_o
    ,output          outport1_rready_o
    ,output          outport2_awvalid_o
    ,output [ 31:0]  outport2_awaddr_o
    ,output          outport2_wvalid_o
    ,output [ 31:0]  outport2_wdata_o
    ,output [  3:0]  outport2_wstrb_o
    ,output          outport2_bready_o
    ,output          outport2_arvalid_o
    ,output [ 31:0]  outport2_araddr_o
    ,output          outport2_rready_o
    ,output          outport3_awvalid_o
    ,output [ 31:0]  outport3_awaddr_o
    ,output          outport3_wvalid_o
    ,output [ 31:0]  outport3_wdata_o
    ,output [  3:0]  outport3_wstrb_o
    ,output          outport3_bready_o
    ,output          outport3_arvalid_o
    ,output [ 31:0]  outport3_araddr_o
    ,output          outport3_rready_o
    ,output          outport4_awvalid_o
    ,output [ 31:0]  outport4_awaddr_o
    ,output          outport4_wvalid_o
    ,output [ 31:0]  outport4_wdata_o
    ,output [  3:0]  outport4_wstrb_o
    ,output          outport4_bready_o
    ,output          outport4_arvalid_o
    ,output [ 31:0]  outport4_araddr_o
    ,output          outport4_rready_o
    ,output          outport5_awvalid_o
    ,output [ 31:0]  outport5_awaddr_o
    ,output          outport5_wvalid_o
    ,output [ 31:0]  outport5_wdata_o
    ,output [  3:0]  outport5_wstrb_o
    ,output          outport5_bready_o
    ,output          outport5_arvalid_o
    ,output [ 31:0]  outport5_araddr_o
    ,output          outport5_rready_o
    ,output          outport6_awvalid_o
    ,output [ 31:0]  outport6_awaddr_o
    ,output          outport6_wvalid_o
    ,output [ 31:0]  outport6_wdata_o
    ,output [  3:0]  outport6_wstrb_o
    ,output          outport6_bready_o
    ,output          outport6_arvalid_o
    ,output [ 31:0]  outport6_araddr_o
    ,output          outport6_rready_o
    ,output          outport7_awvalid_o
    ,output [ 31:0]  outport7_awaddr_o
    ,output          outport7_wvalid_o
    ,output [ 31:0]  outport7_wdata_o
    ,output [  3:0]  outport7_wstrb_o
    ,output          outport7_bready_o
    ,output          outport7_arvalid_o
    ,output [ 31:0]  outport7_araddr_o
    ,output          outport7_rready_o
);



//-----------------------------------------------------------------
// Read Dist
//-----------------------------------------------------------------
reg [2:0] read_sel_r;
reg [2:0] read_sel_q;
reg read_pending_q;
reg read_pending_r;

always @ *
begin
    read_pending_r = read_pending_q;

    // Read response
    if (inport_rvalid_o && inport_rready_i)
        read_pending_r = 1'b0;
    // New request
    else if (!read_pending_r && inport_arvalid_i)
        read_pending_r = inport_arready_o;

    // Address to port selection
    if (!read_pending_q)
        read_sel_r  = inport_araddr_i[26:24];
    else
        read_sel_r  = read_sel_q;
end

always @ (posedge clk_i )
if (rst_i)
begin
    read_sel_q      <= 3'b0;
    read_pending_q  <= 1'b0;
end
else
begin
    read_sel_q      <= read_sel_r;
    read_pending_q  <= read_pending_r;
end

//-----------------------------------------------------------------
// Read Request
//-----------------------------------------------------------------
assign outport0_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd0) && !read_pending_q;
assign outport0_araddr_o  =  inport_araddr_i;
assign outport1_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd1) && !read_pending_q;
assign outport1_araddr_o  =  inport_araddr_i;
assign outport2_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd2) && !read_pending_q;
assign outport2_araddr_o  =  inport_araddr_i;
assign outport3_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd3) && !read_pending_q;
assign outport3_araddr_o  =  inport_araddr_i;
assign outport4_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd4) && !read_pending_q;
assign outport4_araddr_o  =  inport_araddr_i;
assign outport5_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd5) && !read_pending_q;
assign outport5_araddr_o  =  inport_araddr_i;
assign outport6_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd6) && !read_pending_q;
assign outport6_araddr_o  =  inport_araddr_i;
assign outport7_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd7) && !read_pending_q;
assign outport7_araddr_o  =  inport_araddr_i;

//-----------------------------------------------------------------
// Read Request Accept
//-----------------------------------------------------------------
reg inport_arready_r;

always @ *
begin
    inport_arready_r  = 1'b0;

    case (read_sel_r)
    3'd0:
        inport_arready_r = outport0_arready_i;
    3'd1:
        inport_arready_r = outport1_arready_i;
    3'd2:
        inport_arready_r = outport2_arready_i;
    3'd3:
        inport_arready_r = outport3_arready_i;
    3'd4:
        inport_arready_r = outport4_arready_i;
    3'd5:
        inport_arready_r = outport5_arready_i;
    3'd6:
        inport_arready_r = outport6_arready_i;
    3'd7:
        inport_arready_r = outport7_arready_i;
    default :
        ;
    endcase
end

assign inport_arready_o = inport_arready_r && !read_pending_q;

//-----------------------------------------------------------------
// Read Response
//-----------------------------------------------------------------
reg        inport_rvalid_r;
reg [31:0] inport_rdata_r;
reg [1:0]  inport_rresp_r;

always @ *
begin
    inport_rvalid_r  = 1'b0;
    inport_rdata_r   = 32'b0;
    inport_rresp_r   = 2'b0;

    case (read_sel_q)
    3'd0:
    begin
        inport_rvalid_r = outport0_rvalid_i;
        inport_rdata_r  = outport0_rdata_i;
        inport_rresp_r  = outport0_rresp_i;
    end
    3'd1:
    begin
        inport_rvalid_r = outport1_rvalid_i;
        inport_rdata_r  = outport1_rdata_i;
        inport_rresp_r  = outport1_rresp_i;
    end
    3'd2:
    begin
        inport_rvalid_r = outport2_rvalid_i;
        inport_rdata_r  = outport2_rdata_i;
        inport_rresp_r  = outport2_rresp_i;
    end
    3'd3:
    begin
        inport_rvalid_r = outport3_rvalid_i;
        inport_rdata_r  = outport3_rdata_i;
        inport_rresp_r  = outport3_rresp_i;
    end
    3'd4:
    begin
        inport_rvalid_r = outport4_rvalid_i;
        inport_rdata_r  = outport4_rdata_i;
        inport_rresp_r  = outport4_rresp_i;
    end
    3'd5:
    begin
        inport_rvalid_r = outport5_rvalid_i;
        inport_rdata_r  = outport5_rdata_i;
        inport_rresp_r  = outport5_rresp_i;
    end
    3'd6:
    begin
        inport_rvalid_r = outport6_rvalid_i;
        inport_rdata_r  = outport6_rdata_i;
        inport_rresp_r  = outport6_rresp_i;
    end
    3'd7:
    begin
        inport_rvalid_r = outport7_rvalid_i;
        inport_rdata_r  = outport7_rdata_i;
        inport_rresp_r  = outport7_rresp_i;
    end
    default :
        ;
    endcase
end

assign inport_rvalid_o = inport_rvalid_r;
assign inport_rdata_o  = inport_rdata_r;
assign inport_rresp_o  = inport_rresp_r;

//-----------------------------------------------------------------
// Read Response accept
//-----------------------------------------------------------------
assign outport0_rready_o = inport_rready_i && (read_sel_q == 3'd0);
assign outport1_rready_o = inport_rready_i && (read_sel_q == 3'd1);
assign outport2_rready_o = inport_rready_i && (read_sel_q == 3'd2);
assign outport3_rready_o = inport_rready_i && (read_sel_q == 3'd3);
assign outport4_rready_o = inport_rready_i && (read_sel_q == 3'd4);
assign outport5_rready_o = inport_rready_i && (read_sel_q == 3'd5);
assign outport6_rready_o = inport_rready_i && (read_sel_q == 3'd6);
assign outport7_rready_o = inport_rready_i && (read_sel_q == 3'd7);

//-----------------------------------------------------------------
// Write command tracking
//-----------------------------------------------------------------
reg  awvalid_q;
reg  wvalid_q;
wire wr_cmd_accepted_w  = (inport_awvalid_i && inport_awready_o) || awvalid_q;
wire wr_data_accepted_w = (inport_wvalid_i  && inport_wready_o)  || wvalid_q;

reg awvalid_r;

always @ *
begin
    awvalid_r   = awvalid_q;

    // Address ready, data not ready
    if (inport_awvalid_i && inport_awready_o && !wr_data_accepted_w)
        awvalid_r = 1'b1;
    else if (wr_data_accepted_w)
        awvalid_r = 1'b0;
end

always @ (posedge clk_i )
if (rst_i)
    awvalid_q   <= 1'b0;
else
    awvalid_q   <= awvalid_r;

//-----------------------------------------------------------------
// Write data tracking
//-----------------------------------------------------------------
reg wvalid_r;

always @ *
begin
    wvalid_r   = wvalid_q;

    // Data ready, address not ready
    if (inport_wvalid_i && inport_wready_o && !wr_cmd_accepted_w)
        wvalid_r = 1'b1;
    else if (wr_cmd_accepted_w)
        wvalid_r = 1'b0;
end

always @ (posedge clk_i )
if (rst_i)
    wvalid_q   <= 1'b0;
else
    wvalid_q   <= wvalid_r;

//-----------------------------------------------------------------
// Write Dist
//-----------------------------------------------------------------
reg [2:0] write_sel_r;
reg [2:0] write_sel_q;
reg write_pending_q;
reg write_pending_r;

always @ *
begin
    write_pending_r  = write_pending_q;
    write_sel_r      = write_sel_q;

    // Write response
    if (inport_bvalid_o && inport_bready_i)
        write_pending_r = 1'b0;
    // New request - both command and data accepted
    else if (wr_cmd_accepted_w && wr_data_accepted_w)
        write_pending_r = 1'b1;

    // New request - latch address to port selection
    if (inport_awvalid_i && !awvalid_q && !write_pending_q)
        write_sel_r     = inport_awaddr_i[26:24];
end

always @ (posedge clk_i )
if (rst_i)
begin
    write_sel_q      <= 3'b0;
    write_pending_q  <= 1'b0;
end
else
begin
    write_sel_q      <= write_sel_r;
    write_pending_q  <= write_pending_r;
end

//-----------------------------------------------------------------
// Write Request
//-----------------------------------------------------------------
assign outport0_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd0) && !awvalid_q && !write_pending_q;
assign outport0_awaddr_o  =  inport_awaddr_i;
assign outport0_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd0) && !wvalid_q && !write_pending_q;
assign outport0_wdata_o   =  inport_wdata_i;
assign outport0_wstrb_o   =  inport_wstrb_i;
assign outport1_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd1) && !awvalid_q && !write_pending_q;
assign outport1_awaddr_o  =  inport_awaddr_i;
assign outport1_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd1) && !wvalid_q && !write_pending_q;
assign outport1_wdata_o   =  inport_wdata_i;
assign outport1_wstrb_o   =  inport_wstrb_i;
assign outport2_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd2) && !awvalid_q && !write_pending_q;
assign outport2_awaddr_o  =  inport_awaddr_i;
assign outport2_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd2) && !wvalid_q && !write_pending_q;
assign outport2_wdata_o   =  inport_wdata_i;
assign outport2_wstrb_o   =  inport_wstrb_i;
assign outport3_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd3) && !awvalid_q && !write_pending_q;
assign outport3_awaddr_o  =  inport_awaddr_i;
assign outport3_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd3) && !wvalid_q && !write_pending_q;
assign outport3_wdata_o   =  inport_wdata_i;
assign outport3_wstrb_o   =  inport_wstrb_i;
assign outport4_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd4) && !awvalid_q && !write_pending_q;
assign outport4_awaddr_o  =  inport_awaddr_i;
assign outport4_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd4) && !wvalid_q && !write_pending_q;
assign outport4_wdata_o   =  inport_wdata_i;
assign outport4_wstrb_o   =  inport_wstrb_i;
assign outport5_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd5) && !awvalid_q && !write_pending_q;
assign outport5_awaddr_o  =  inport_awaddr_i;
assign outport5_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd5) && !wvalid_q && !write_pending_q;
assign outport5_wdata_o   =  inport_wdata_i;
assign outport5_wstrb_o   =  inport_wstrb_i;
assign outport6_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd6) && !awvalid_q && !write_pending_q;
assign outport6_awaddr_o  =  inport_awaddr_i;
assign outport6_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd6) && !wvalid_q && !write_pending_q;
assign outport6_wdata_o   =  inport_wdata_i;
assign outport6_wstrb_o   =  inport_wstrb_i;
assign outport7_awvalid_o =  inport_awvalid_i && (write_sel_r == 3'd7) && !awvalid_q && !write_pending_q;
assign outport7_awaddr_o  =  inport_awaddr_i;
assign outport7_wvalid_o  =  inport_wvalid_i && (inport_awvalid_i || awvalid_q) && (write_sel_r == 3'd7) && !wvalid_q && !write_pending_q;
assign outport7_wdata_o   =  inport_wdata_i;
assign outport7_wstrb_o   =  inport_wstrb_i;

//-----------------------------------------------------------------
// Write Request Accept
//-----------------------------------------------------------------
reg inport_awready_r;
reg inport_wready_r;

always @ *
begin
    inport_awready_r  = 1'b0;
    inport_wready_r   = 1'b0;

    case (write_sel_r)
    3'd0:
    begin
        inport_awready_r = outport0_awready_i;
        inport_wready_r  = outport0_wready_i;
    end
    3'd1:
    begin
        inport_awready_r = outport1_awready_i;
        inport_wready_r  = outport1_wready_i;
    end
    3'd2:
    begin
        inport_awready_r = outport2_awready_i;
        inport_wready_r  = outport2_wready_i;
    end
    3'd3:
    begin
        inport_awready_r = outport3_awready_i;
        inport_wready_r  = outport3_wready_i;
    end
    3'd4:
    begin
        inport_awready_r = outport4_awready_i;
        inport_wready_r  = outport4_wready_i;
    end
    3'd5:
    begin
        inport_awready_r = outport5_awready_i;
        inport_wready_r  = outport5_wready_i;
    end
    3'd6:
    begin
        inport_awready_r = outport6_awready_i;
        inport_wready_r  = outport6_wready_i;
    end
    3'd7:
    begin
        inport_awready_r = outport7_awready_i;
        inport_wready_r  = outport7_wready_i;
    end
    default :
        ;
    endcase
end

assign inport_awready_o = inport_awready_r && !awvalid_q && !write_pending_q;
assign inport_wready_o  = inport_wready_r  && !wvalid_q  && !write_pending_q;

//-----------------------------------------------------------------
// Write Response
//-----------------------------------------------------------------
reg        inport_bvalid_r;
reg [1:0]  inport_bresp_r;

always @ *
begin
    inport_bvalid_r  = 1'b0;
    inport_bresp_r   = 2'b0;

    case (write_sel_q)
    3'd0:
    begin
        inport_bvalid_r = outport0_bvalid_i;
        inport_bresp_r  = outport0_bresp_i;
    end
    3'd1:
    begin
        inport_bvalid_r = outport1_bvalid_i;
        inport_bresp_r  = outport1_bresp_i;
    end
    3'd2:
    begin
        inport_bvalid_r = outport2_bvalid_i;
        inport_bresp_r  = outport2_bresp_i;
    end
    3'd3:
    begin
        inport_bvalid_r = outport3_bvalid_i;
        inport_bresp_r  = outport3_bresp_i;
    end
    3'd4:
    begin
        inport_bvalid_r = outport4_bvalid_i;
        inport_bresp_r  = outport4_bresp_i;
    end
    3'd5:
    begin
        inport_bvalid_r = outport5_bvalid_i;
        inport_bresp_r  = outport5_bresp_i;
    end
    3'd6:
    begin
        inport_bvalid_r = outport6_bvalid_i;
        inport_bresp_r  = outport6_bresp_i;
    end
    3'd7:
    begin
        inport_bvalid_r = outport7_bvalid_i;
        inport_bresp_r  = outport7_bresp_i;
    end
    default :
        ;
    endcase
end

assign inport_bvalid_o = inport_bvalid_r;
assign inport_bresp_o  = inport_bresp_r;

//-----------------------------------------------------------------
// Write Response accept
//-----------------------------------------------------------------
assign outport0_bready_o = inport_bready_i && (write_sel_q == 3'd0);
assign outport1_bready_o = inport_bready_i && (write_sel_q == 3'd1);
assign outport2_bready_o = inport_bready_i && (write_sel_q == 3'd2);
assign outport3_bready_o = inport_bready_i && (write_sel_q == 3'd3);
assign outport4_bready_o = inport_bready_i && (write_sel_q == 3'd4);
assign outport5_bready_o = inport_bready_i && (write_sel_q == 3'd5);
assign outport6_bready_o = inport_bready_i && (write_sel_q == 3'd6);
assign outport7_bready_o = inport_bready_i && (write_sel_q == 3'd7);



endmodule
