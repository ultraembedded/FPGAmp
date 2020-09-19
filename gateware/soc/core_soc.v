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

module core_soc
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter CLK_FREQ         = 50000000
    ,parameter BAUDRATE         = 1000000
    ,parameter C_SCK_RATIO      = 3
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
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
    ,input           uart_rx_i
    ,input  [ 31:0]  gpio_input_i
    ,input           ext1_cfg_awready_i
    ,input           ext1_cfg_wready_i
    ,input           ext1_cfg_bvalid_i
    ,input  [  1:0]  ext1_cfg_bresp_i
    ,input           ext1_cfg_arready_i
    ,input           ext1_cfg_rvalid_i
    ,input  [ 31:0]  ext1_cfg_rdata_i
    ,input  [  1:0]  ext1_cfg_rresp_i
    ,input           ext1_irq_i
    ,input           ext2_cfg_awready_i
    ,input           ext2_cfg_wready_i
    ,input           ext2_cfg_bvalid_i
    ,input  [  1:0]  ext2_cfg_bresp_i
    ,input           ext2_cfg_arready_i
    ,input           ext2_cfg_rvalid_i
    ,input  [ 31:0]  ext2_cfg_rdata_i
    ,input  [  1:0]  ext2_cfg_rresp_i
    ,input           ext2_irq_i
    ,input           ext3_cfg_awready_i
    ,input           ext3_cfg_wready_i
    ,input           ext3_cfg_bvalid_i
    ,input  [  1:0]  ext3_cfg_bresp_i
    ,input           ext3_cfg_arready_i
    ,input           ext3_cfg_rvalid_i
    ,input  [ 31:0]  ext3_cfg_rdata_i
    ,input  [  1:0]  ext3_cfg_rresp_i
    ,input           ext3_irq_i

    // Outputs
    ,output          intr_o
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output          uart_tx_o
    ,output [ 31:0]  gpio_output_o
    ,output [ 31:0]  gpio_output_enable_o
    ,output          spdif_o
    ,output          i2s_sck_o
    ,output          i2s_sdata_o
    ,output          i2s_ws_o
    ,output          ext1_cfg_awvalid_o
    ,output [ 31:0]  ext1_cfg_awaddr_o
    ,output          ext1_cfg_wvalid_o
    ,output [ 31:0]  ext1_cfg_wdata_o
    ,output [  3:0]  ext1_cfg_wstrb_o
    ,output          ext1_cfg_bready_o
    ,output          ext1_cfg_arvalid_o
    ,output [ 31:0]  ext1_cfg_araddr_o
    ,output          ext1_cfg_rready_o
    ,output          ext2_cfg_awvalid_o
    ,output [ 31:0]  ext2_cfg_awaddr_o
    ,output          ext2_cfg_wvalid_o
    ,output [ 31:0]  ext2_cfg_wdata_o
    ,output [  3:0]  ext2_cfg_wstrb_o
    ,output          ext2_cfg_bready_o
    ,output          ext2_cfg_arvalid_o
    ,output [ 31:0]  ext2_cfg_araddr_o
    ,output          ext2_cfg_rready_o
    ,output          ext3_cfg_awvalid_o
    ,output [ 31:0]  ext3_cfg_awaddr_o
    ,output          ext3_cfg_wvalid_o
    ,output [ 31:0]  ext3_cfg_wdata_o
    ,output [  3:0]  ext3_cfg_wstrb_o
    ,output          ext3_cfg_bready_o
    ,output          ext3_cfg_arvalid_o
    ,output [ 31:0]  ext3_cfg_araddr_o
    ,output          ext3_cfg_rready_o
);

wire  [  3:0]  periph4_wstrb_w;
wire  [  1:0]  periph4_rresp_w;
wire  [  1:0]  periph0_bresp_w;
wire           periph2_awvalid_w;
wire  [  1:0]  periph3_rresp_w;
wire           periph2_rready_w;
wire           interrupt2_w;
wire  [ 31:0]  periph2_awaddr_w;
wire           periph2_bvalid_w;
wire           periph2_wready_w;
wire           periph4_arready_w;
wire  [  3:0]  periph2_wstrb_w;
wire           periph4_awvalid_w;
wire  [ 31:0]  periph0_wdata_w;
wire           interrupt3_w;
wire           periph0_wready_w;
wire           periph2_arready_w;
wire           periph3_arvalid_w;
wire  [ 31:0]  periph4_rdata_w;
wire  [  3:0]  periph3_wstrb_w;
wire           periph4_rready_w;
wire  [ 31:0]  periph4_wdata_w;
wire           periph0_awready_w;
wire           periph3_awready_w;
wire           periph3_bready_w;
wire           periph3_wready_w;
wire  [ 31:0]  periph4_araddr_w;
wire           interrupt1_w;
wire  [ 31:0]  periph0_awaddr_w;
wire           periph0_bvalid_w;
wire           periph4_bvalid_w;
wire           periph0_rready_w;
wire           periph4_arvalid_w;
wire           periph2_bready_w;
wire           periph0_arvalid_w;
wire           periph3_bvalid_w;
wire           periph0_rvalid_w;
wire  [ 31:0]  periph3_rdata_w;
wire  [  1:0]  periph0_rresp_w;
wire           periph4_rvalid_w;
wire           periph0_bready_w;
wire           periph3_arready_w;
wire           periph2_awready_w;
wire           periph2_arvalid_w;
wire  [  1:0]  periph2_rresp_w;
wire           periph4_awready_w;
wire  [  1:0]  periph3_bresp_w;
wire  [  1:0]  periph2_bresp_w;
wire           periph0_arready_w;
wire           periph3_awvalid_w;
wire  [ 31:0]  periph2_rdata_w;
wire           periph4_wready_w;
wire  [ 31:0]  periph2_araddr_w;
wire  [ 31:0]  periph3_awaddr_w;
wire           periph4_wvalid_w;
wire  [ 31:0]  periph0_rdata_w;
wire  [ 31:0]  periph2_wdata_w;
wire           periph0_wvalid_w;
wire  [  1:0]  periph4_bresp_w;
wire  [ 31:0]  periph3_araddr_w;
wire           periph2_rvalid_w;
wire           periph0_awvalid_w;
wire  [ 31:0]  periph0_araddr_w;
wire           periph4_bready_w;
wire           periph2_wvalid_w;
wire  [ 31:0]  periph4_awaddr_w;
wire           periph3_wvalid_w;
wire           periph3_rvalid_w;
wire  [  3:0]  periph0_wstrb_w;
wire           periph3_rready_w;
wire  [ 31:0]  periph3_wdata_w;


audio
u_audio
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(periph3_awvalid_w)
    ,.cfg_awaddr_i(periph3_awaddr_w)
    ,.cfg_wvalid_i(periph3_wvalid_w)
    ,.cfg_wdata_i(periph3_wdata_w)
    ,.cfg_wstrb_i(periph3_wstrb_w)
    ,.cfg_bready_i(periph3_bready_w)
    ,.cfg_arvalid_i(periph3_arvalid_w)
    ,.cfg_araddr_i(periph3_araddr_w)
    ,.cfg_rready_i(periph3_rready_w)

    // Outputs
    ,.cfg_awready_o(periph3_awready_w)
    ,.cfg_wready_o(periph3_wready_w)
    ,.cfg_bvalid_o(periph3_bvalid_w)
    ,.cfg_bresp_o(periph3_bresp_w)
    ,.cfg_arready_o(periph3_arready_w)
    ,.cfg_rvalid_o(periph3_rvalid_w)
    ,.cfg_rdata_o(periph3_rdata_w)
    ,.cfg_rresp_o(periph3_rresp_w)
    ,.spdif_o(spdif_o)
    ,.i2s_sck_o(i2s_sck_o)
    ,.i2s_sdata_o(i2s_sdata_o)
    ,.i2s_ws_o(i2s_ws_o)
    ,.intr_o(interrupt2_w)
);


uart_lite
#(
     .CLK_FREQ(CLK_FREQ)
    ,.BAUDRATE(BAUDRATE)
)
u_uart
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(periph2_awvalid_w)
    ,.cfg_awaddr_i(periph2_awaddr_w)
    ,.cfg_wvalid_i(periph2_wvalid_w)
    ,.cfg_wdata_i(periph2_wdata_w)
    ,.cfg_wstrb_i(periph2_wstrb_w)
    ,.cfg_bready_i(periph2_bready_w)
    ,.cfg_arvalid_i(periph2_arvalid_w)
    ,.cfg_araddr_i(periph2_araddr_w)
    ,.cfg_rready_i(periph2_rready_w)
    ,.rx_i(uart_rx_i)

    // Outputs
    ,.cfg_awready_o(periph2_awready_w)
    ,.cfg_wready_o(periph2_wready_w)
    ,.cfg_bvalid_o(periph2_bvalid_w)
    ,.cfg_bresp_o(periph2_bresp_w)
    ,.cfg_arready_o(periph2_arready_w)
    ,.cfg_rvalid_o(periph2_rvalid_w)
    ,.cfg_rdata_o(periph2_rdata_w)
    ,.cfg_rresp_o(periph2_rresp_w)
    ,.tx_o(uart_tx_o)
    ,.intr_o(interrupt1_w)
);


gpio
u_gpio
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(periph4_awvalid_w)
    ,.cfg_awaddr_i(periph4_awaddr_w)
    ,.cfg_wvalid_i(periph4_wvalid_w)
    ,.cfg_wdata_i(periph4_wdata_w)
    ,.cfg_wstrb_i(periph4_wstrb_w)
    ,.cfg_bready_i(periph4_bready_w)
    ,.cfg_arvalid_i(periph4_arvalid_w)
    ,.cfg_araddr_i(periph4_araddr_w)
    ,.cfg_rready_i(periph4_rready_w)
    ,.gpio_input_i(gpio_input_i)

    // Outputs
    ,.cfg_awready_o(periph4_awready_w)
    ,.cfg_wready_o(periph4_wready_w)
    ,.cfg_bvalid_o(periph4_bvalid_w)
    ,.cfg_bresp_o(periph4_bresp_w)
    ,.cfg_arready_o(periph4_arready_w)
    ,.cfg_rvalid_o(periph4_rvalid_w)
    ,.cfg_rdata_o(periph4_rdata_w)
    ,.cfg_rresp_o(periph4_rresp_w)
    ,.gpio_output_o(gpio_output_o)
    ,.gpio_output_enable_o(gpio_output_enable_o)
    ,.intr_o(interrupt3_w)
);


irq_ctrl
u_intc
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(periph0_awvalid_w)
    ,.cfg_awaddr_i(periph0_awaddr_w)
    ,.cfg_wvalid_i(periph0_wvalid_w)
    ,.cfg_wdata_i(periph0_wdata_w)
    ,.cfg_wstrb_i(periph0_wstrb_w)
    ,.cfg_bready_i(periph0_bready_w)
    ,.cfg_arvalid_i(periph0_arvalid_w)
    ,.cfg_araddr_i(periph0_araddr_w)
    ,.cfg_rready_i(periph0_rready_w)
    ,.interrupt0_i(1'b0)
    ,.interrupt1_i(interrupt1_w)
    ,.interrupt2_i(interrupt2_w)
    ,.interrupt3_i(interrupt3_w)
    ,.interrupt4_i(ext1_irq_i)
    ,.interrupt5_i(ext2_irq_i)
    ,.interrupt6_i(ext3_irq_i)

    // Outputs
    ,.cfg_awready_o(periph0_awready_w)
    ,.cfg_wready_o(periph0_wready_w)
    ,.cfg_bvalid_o(periph0_bvalid_w)
    ,.cfg_bresp_o(periph0_bresp_w)
    ,.cfg_arready_o(periph0_arready_w)
    ,.cfg_rvalid_o(periph0_rvalid_w)
    ,.cfg_rdata_o(periph0_rdata_w)
    ,.cfg_rresp_o(periph0_rresp_w)
    ,.intr_o(intr_o)
);


axi4lite_dist
u_dist
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(inport_awvalid_i)
    ,.inport_awaddr_i(inport_awaddr_i)
    ,.inport_wvalid_i(inport_wvalid_i)
    ,.inport_wdata_i(inport_wdata_i)
    ,.inport_wstrb_i(inport_wstrb_i)
    ,.inport_bready_i(inport_bready_i)
    ,.inport_arvalid_i(inport_arvalid_i)
    ,.inport_araddr_i(inport_araddr_i)
    ,.inport_rready_i(inport_rready_i)
    ,.outport0_awready_i(periph0_awready_w)
    ,.outport0_wready_i(periph0_wready_w)
    ,.outport0_bvalid_i(periph0_bvalid_w)
    ,.outport0_bresp_i(periph0_bresp_w)
    ,.outport0_arready_i(periph0_arready_w)
    ,.outport0_rvalid_i(periph0_rvalid_w)
    ,.outport0_rdata_i(periph0_rdata_w)
    ,.outport0_rresp_i(periph0_rresp_w)
    ,.outport1_awready_i(1'b0)
    ,.outport1_wready_i(1'b0)
    ,.outport1_bvalid_i(1'b0)
    ,.outport1_bresp_i(2'b0)
    ,.outport1_arready_i(1'b0)
    ,.outport1_rvalid_i(1'b0)
    ,.outport1_rdata_i(32'b0)
    ,.outport1_rresp_i(2'b0)
    ,.outport2_awready_i(periph2_awready_w)
    ,.outport2_wready_i(periph2_wready_w)
    ,.outport2_bvalid_i(periph2_bvalid_w)
    ,.outport2_bresp_i(periph2_bresp_w)
    ,.outport2_arready_i(periph2_arready_w)
    ,.outport2_rvalid_i(periph2_rvalid_w)
    ,.outport2_rdata_i(periph2_rdata_w)
    ,.outport2_rresp_i(periph2_rresp_w)
    ,.outport3_awready_i(periph3_awready_w)
    ,.outport3_wready_i(periph3_wready_w)
    ,.outport3_bvalid_i(periph3_bvalid_w)
    ,.outport3_bresp_i(periph3_bresp_w)
    ,.outport3_arready_i(periph3_arready_w)
    ,.outport3_rvalid_i(periph3_rvalid_w)
    ,.outport3_rdata_i(periph3_rdata_w)
    ,.outport3_rresp_i(periph3_rresp_w)
    ,.outport4_awready_i(periph4_awready_w)
    ,.outport4_wready_i(periph4_wready_w)
    ,.outport4_bvalid_i(periph4_bvalid_w)
    ,.outport4_bresp_i(periph4_bresp_w)
    ,.outport4_arready_i(periph4_arready_w)
    ,.outport4_rvalid_i(periph4_rvalid_w)
    ,.outport4_rdata_i(periph4_rdata_w)
    ,.outport4_rresp_i(periph4_rresp_w)
    ,.outport5_awready_i(ext1_cfg_awready_i)
    ,.outport5_wready_i(ext1_cfg_wready_i)
    ,.outport5_bvalid_i(ext1_cfg_bvalid_i)
    ,.outport5_bresp_i(ext1_cfg_bresp_i)
    ,.outport5_arready_i(ext1_cfg_arready_i)
    ,.outport5_rvalid_i(ext1_cfg_rvalid_i)
    ,.outport5_rdata_i(ext1_cfg_rdata_i)
    ,.outport5_rresp_i(ext1_cfg_rresp_i)
    ,.outport6_awready_i(ext2_cfg_awready_i)
    ,.outport6_wready_i(ext2_cfg_wready_i)
    ,.outport6_bvalid_i(ext2_cfg_bvalid_i)
    ,.outport6_bresp_i(ext2_cfg_bresp_i)
    ,.outport6_arready_i(ext2_cfg_arready_i)
    ,.outport6_rvalid_i(ext2_cfg_rvalid_i)
    ,.outport6_rdata_i(ext2_cfg_rdata_i)
    ,.outport6_rresp_i(ext2_cfg_rresp_i)
    ,.outport7_awready_i(ext3_cfg_awready_i)
    ,.outport7_wready_i(ext3_cfg_wready_i)
    ,.outport7_bvalid_i(ext3_cfg_bvalid_i)
    ,.outport7_bresp_i(ext3_cfg_bresp_i)
    ,.outport7_arready_i(ext3_cfg_arready_i)
    ,.outport7_rvalid_i(ext3_cfg_rvalid_i)
    ,.outport7_rdata_i(ext3_cfg_rdata_i)
    ,.outport7_rresp_i(ext3_cfg_rresp_i)

    // Outputs
    ,.inport_awready_o(inport_awready_o)
    ,.inport_wready_o(inport_wready_o)
    ,.inport_bvalid_o(inport_bvalid_o)
    ,.inport_bresp_o(inport_bresp_o)
    ,.inport_arready_o(inport_arready_o)
    ,.inport_rvalid_o(inport_rvalid_o)
    ,.inport_rdata_o(inport_rdata_o)
    ,.inport_rresp_o(inport_rresp_o)
    ,.outport0_awvalid_o(periph0_awvalid_w)
    ,.outport0_awaddr_o(periph0_awaddr_w)
    ,.outport0_wvalid_o(periph0_wvalid_w)
    ,.outport0_wdata_o(periph0_wdata_w)
    ,.outport0_wstrb_o(periph0_wstrb_w)
    ,.outport0_bready_o(periph0_bready_w)
    ,.outport0_arvalid_o(periph0_arvalid_w)
    ,.outport0_araddr_o(periph0_araddr_w)
    ,.outport0_rready_o(periph0_rready_w)
    ,.outport1_awvalid_o()
    ,.outport1_awaddr_o()
    ,.outport1_wvalid_o()
    ,.outport1_wdata_o()
    ,.outport1_wstrb_o()
    ,.outport1_bready_o()
    ,.outport1_arvalid_o()
    ,.outport1_araddr_o()
    ,.outport1_rready_o()
    ,.outport2_awvalid_o(periph2_awvalid_w)
    ,.outport2_awaddr_o(periph2_awaddr_w)
    ,.outport2_wvalid_o(periph2_wvalid_w)
    ,.outport2_wdata_o(periph2_wdata_w)
    ,.outport2_wstrb_o(periph2_wstrb_w)
    ,.outport2_bready_o(periph2_bready_w)
    ,.outport2_arvalid_o(periph2_arvalid_w)
    ,.outport2_araddr_o(periph2_araddr_w)
    ,.outport2_rready_o(periph2_rready_w)
    ,.outport3_awvalid_o(periph3_awvalid_w)
    ,.outport3_awaddr_o(periph3_awaddr_w)
    ,.outport3_wvalid_o(periph3_wvalid_w)
    ,.outport3_wdata_o(periph3_wdata_w)
    ,.outport3_wstrb_o(periph3_wstrb_w)
    ,.outport3_bready_o(periph3_bready_w)
    ,.outport3_arvalid_o(periph3_arvalid_w)
    ,.outport3_araddr_o(periph3_araddr_w)
    ,.outport3_rready_o(periph3_rready_w)
    ,.outport4_awvalid_o(periph4_awvalid_w)
    ,.outport4_awaddr_o(periph4_awaddr_w)
    ,.outport4_wvalid_o(periph4_wvalid_w)
    ,.outport4_wdata_o(periph4_wdata_w)
    ,.outport4_wstrb_o(periph4_wstrb_w)
    ,.outport4_bready_o(periph4_bready_w)
    ,.outport4_arvalid_o(periph4_arvalid_w)
    ,.outport4_araddr_o(periph4_araddr_w)
    ,.outport4_rready_o(periph4_rready_w)
    ,.outport5_awvalid_o(ext1_cfg_awvalid_o)
    ,.outport5_awaddr_o(ext1_cfg_awaddr_o)
    ,.outport5_wvalid_o(ext1_cfg_wvalid_o)
    ,.outport5_wdata_o(ext1_cfg_wdata_o)
    ,.outport5_wstrb_o(ext1_cfg_wstrb_o)
    ,.outport5_bready_o(ext1_cfg_bready_o)
    ,.outport5_arvalid_o(ext1_cfg_arvalid_o)
    ,.outport5_araddr_o(ext1_cfg_araddr_o)
    ,.outport5_rready_o(ext1_cfg_rready_o)
    ,.outport6_awvalid_o(ext2_cfg_awvalid_o)
    ,.outport6_awaddr_o(ext2_cfg_awaddr_o)
    ,.outport6_wvalid_o(ext2_cfg_wvalid_o)
    ,.outport6_wdata_o(ext2_cfg_wdata_o)
    ,.outport6_wstrb_o(ext2_cfg_wstrb_o)
    ,.outport6_bready_o(ext2_cfg_bready_o)
    ,.outport6_arvalid_o(ext2_cfg_arvalid_o)
    ,.outport6_araddr_o(ext2_cfg_araddr_o)
    ,.outport6_rready_o(ext2_cfg_rready_o)
    ,.outport7_awvalid_o(ext3_cfg_awvalid_o)
    ,.outport7_awaddr_o(ext3_cfg_awaddr_o)
    ,.outport7_wvalid_o(ext3_cfg_wvalid_o)
    ,.outport7_wdata_o(ext3_cfg_wdata_o)
    ,.outport7_wstrb_o(ext3_cfg_wstrb_o)
    ,.outport7_bready_o(ext3_cfg_bready_o)
    ,.outport7_arvalid_o(ext3_cfg_arvalid_o)
    ,.outport7_araddr_o(ext3_cfg_araddr_o)
    ,.outport7_rready_o(ext3_cfg_rready_o)
);



endmodule
