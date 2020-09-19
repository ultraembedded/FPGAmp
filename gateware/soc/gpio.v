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

`include "gpio_defs.v"

//-----------------------------------------------------------------
// Module:  General Purpose IO Peripheral
//-----------------------------------------------------------------
module gpio
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
    ,input  [31:0]  gpio_input_i

    // Outputs
    ,output         cfg_awready_o
    ,output         cfg_wready_o
    ,output         cfg_bvalid_o
    ,output [1:0]   cfg_bresp_o
    ,output         cfg_arready_o
    ,output         cfg_rvalid_o
    ,output [31:0]  cfg_rdata_o
    ,output [1:0]   cfg_rresp_o
    ,output [31:0]  gpio_output_o
    ,output [31:0]  gpio_output_enable_o
    ,output         intr_o
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
// Register gpio_direction
//-----------------------------------------------------------------
reg gpio_direction_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_direction_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_DIRECTION))
    gpio_direction_wr_q <= 1'b1;
else
    gpio_direction_wr_q <= 1'b0;

// gpio_direction_output [internal]
reg [31:0]  gpio_direction_output_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_direction_output_q <= 32'd`GPIO_DIRECTION_OUTPUT_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_DIRECTION))
    gpio_direction_output_q <= cfg_wdata_i[`GPIO_DIRECTION_OUTPUT_R];

wire [31:0]  gpio_direction_output_out_w = gpio_direction_output_q;


//-----------------------------------------------------------------
// Register gpio_input
//-----------------------------------------------------------------
reg gpio_input_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_input_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INPUT))
    gpio_input_wr_q <= 1'b1;
else
    gpio_input_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register gpio_output
//-----------------------------------------------------------------
reg gpio_output_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_output_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_OUTPUT))
    gpio_output_wr_q <= 1'b1;
else
    gpio_output_wr_q <= 1'b0;

// gpio_output_data [external]
wire [31:0]  gpio_output_data_out_w = wr_data_q[`GPIO_OUTPUT_DATA_R];


//-----------------------------------------------------------------
// Register gpio_output_set
//-----------------------------------------------------------------
reg gpio_output_set_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_output_set_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_OUTPUT_SET))
    gpio_output_set_wr_q <= 1'b1;
else
    gpio_output_set_wr_q <= 1'b0;

// gpio_output_set_data [external]
wire [31:0]  gpio_output_set_data_out_w = wr_data_q[`GPIO_OUTPUT_SET_DATA_R];


//-----------------------------------------------------------------
// Register gpio_output_clr
//-----------------------------------------------------------------
reg gpio_output_clr_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_output_clr_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_OUTPUT_CLR))
    gpio_output_clr_wr_q <= 1'b1;
else
    gpio_output_clr_wr_q <= 1'b0;

// gpio_output_clr_data [external]
wire [31:0]  gpio_output_clr_data_out_w = wr_data_q[`GPIO_OUTPUT_CLR_DATA_R];


//-----------------------------------------------------------------
// Register gpio_int_mask
//-----------------------------------------------------------------
reg gpio_int_mask_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_mask_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_MASK))
    gpio_int_mask_wr_q <= 1'b1;
else
    gpio_int_mask_wr_q <= 1'b0;

// gpio_int_mask_enable [internal]
reg [31:0]  gpio_int_mask_enable_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_mask_enable_q <= 32'd`GPIO_INT_MASK_ENABLE_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_MASK))
    gpio_int_mask_enable_q <= cfg_wdata_i[`GPIO_INT_MASK_ENABLE_R];

wire [31:0]  gpio_int_mask_enable_out_w = gpio_int_mask_enable_q;


//-----------------------------------------------------------------
// Register gpio_int_set
//-----------------------------------------------------------------
reg gpio_int_set_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_set_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_SET))
    gpio_int_set_wr_q <= 1'b1;
else
    gpio_int_set_wr_q <= 1'b0;

// gpio_int_set_sw_irq [external]
wire [31:0]  gpio_int_set_sw_irq_out_w = wr_data_q[`GPIO_INT_SET_SW_IRQ_R];


//-----------------------------------------------------------------
// Register gpio_int_clr
//-----------------------------------------------------------------
reg gpio_int_clr_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_clr_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_CLR))
    gpio_int_clr_wr_q <= 1'b1;
else
    gpio_int_clr_wr_q <= 1'b0;

// gpio_int_clr_ack [external]
wire [31:0]  gpio_int_clr_ack_out_w = wr_data_q[`GPIO_INT_CLR_ACK_R];


//-----------------------------------------------------------------
// Register gpio_int_status
//-----------------------------------------------------------------
reg gpio_int_status_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_status_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_STATUS))
    gpio_int_status_wr_q <= 1'b1;
else
    gpio_int_status_wr_q <= 1'b0;


//-----------------------------------------------------------------
// Register gpio_int_level
//-----------------------------------------------------------------
reg gpio_int_level_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_level_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_LEVEL))
    gpio_int_level_wr_q <= 1'b1;
else
    gpio_int_level_wr_q <= 1'b0;

// gpio_int_level_active_high [internal]
reg [31:0]  gpio_int_level_active_high_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_level_active_high_q <= 32'd`GPIO_INT_LEVEL_ACTIVE_HIGH_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_LEVEL))
    gpio_int_level_active_high_q <= cfg_wdata_i[`GPIO_INT_LEVEL_ACTIVE_HIGH_R];

wire [31:0]  gpio_int_level_active_high_out_w = gpio_int_level_active_high_q;


//-----------------------------------------------------------------
// Register gpio_int_mode
//-----------------------------------------------------------------
reg gpio_int_mode_wr_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_mode_wr_q <= 1'b0;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_MODE))
    gpio_int_mode_wr_q <= 1'b1;
else
    gpio_int_mode_wr_q <= 1'b0;

// gpio_int_mode_edge [internal]
reg [31:0]  gpio_int_mode_edge_q;

always @ (posedge clk_i )
if (rst_i)
    gpio_int_mode_edge_q <= 32'd`GPIO_INT_MODE_EDGE_DEFAULT;
else if (write_en_w && (wr_addr_w[7:0] == `GPIO_INT_MODE))
    gpio_int_mode_edge_q <= cfg_wdata_i[`GPIO_INT_MODE_EDGE_R];

wire [31:0]  gpio_int_mode_edge_out_w = gpio_int_mode_edge_q;


wire [31:0]  gpio_input_value_in_w;
wire [31:0]  gpio_output_data_in_w;
wire [31:0]  gpio_int_status_raw_in_w;


//-----------------------------------------------------------------
// Read mux
//-----------------------------------------------------------------
reg [31:0] data_r;

always @ *
begin
    data_r = 32'b0;

    case (cfg_araddr_i[7:0])

    `GPIO_DIRECTION:
    begin
        data_r[`GPIO_DIRECTION_OUTPUT_R] = gpio_direction_output_q;
    end
    `GPIO_INPUT:
    begin
        data_r[`GPIO_INPUT_VALUE_R] = gpio_input_value_in_w;
    end
    `GPIO_OUTPUT:
    begin
        data_r[`GPIO_OUTPUT_DATA_R] = gpio_output_data_in_w;
    end
    `GPIO_INT_MASK:
    begin
        data_r[`GPIO_INT_MASK_ENABLE_R] = gpio_int_mask_enable_q;
    end
    `GPIO_INT_STATUS:
    begin
        data_r[`GPIO_INT_STATUS_RAW_R] = gpio_int_status_raw_in_w;
    end
    `GPIO_INT_LEVEL:
    begin
        data_r[`GPIO_INT_LEVEL_ACTIVE_HIGH_R] = gpio_int_level_active_high_q;
    end
    `GPIO_INT_MODE:
    begin
        data_r[`GPIO_INT_MODE_EDGE_R] = gpio_int_mode_edge_q;
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

wire gpio_output_rd_req_w = read_en_w & (cfg_araddr_i[7:0] == `GPIO_OUTPUT);

wire gpio_output_wr_req_w = gpio_output_wr_q;
wire gpio_output_set_wr_req_w = gpio_output_set_wr_q;
wire gpio_output_clr_wr_req_w = gpio_output_clr_wr_q;
wire gpio_int_set_wr_req_w = gpio_int_set_wr_q;
wire gpio_int_clr_wr_req_w = gpio_int_clr_wr_q;


//-----------------------------------------------------------------
// Inputs
//-----------------------------------------------------------------
// Resync inputs
reg [31:0] input_ms;
reg [31:0] input_q;

always @ (posedge clk_i )
if (rst_i)
begin
    input_ms <= 32'b0;
    input_q  <= 32'b0;
end
else
begin
    input_q  <= input_ms;
    input_ms <= gpio_input_i;
end

assign gpio_input_value_in_w = input_q;

//-----------------------------------------------------------------
// Outputs
//-----------------------------------------------------------------
reg [31:0] output_q;
reg [31:0] output_next_r;

always @ *
begin
    output_next_r = output_q;

    if (gpio_output_set_wr_req_w)
        output_next_r = output_q | gpio_output_set_data_out_w;
    else if (gpio_output_clr_wr_req_w)
        output_next_r = output_q & ~gpio_output_clr_data_out_w;
    else if (gpio_output_wr_req_w)
        output_next_r = gpio_output_data_out_w;
end

always @ (posedge clk_i )
if (rst_i)
    output_q  <= 32'b0;
else
    output_q  <= output_next_r;

assign gpio_output_data_in_w = output_q;
assign gpio_output_o         = output_q;

//-----------------------------------------------------------------
// Interrupts
//-----------------------------------------------------------------
reg intr_q;

reg [31:0] interrupt_raw_q;
reg [31:0] interrupt_raw_r;

reg [31:0] input_last_q;

always @ (posedge clk_i )
if (rst_i)
    input_last_q  <= 32'b0;
else
    input_last_q  <= gpio_input_value_in_w;

wire [31:0] active_low_w   = (~gpio_int_level_active_high_out_w);
wire [31:0] falling_edge_w =  (~gpio_int_level_active_high_out_w);
wire [31:0] level_mask_w   = (~gpio_int_mode_edge_out_w);
wire [31:0] edge_mask_w    =   gpio_int_mode_edge_out_w;

wire [31:0] level_active_w = (gpio_input_value_in_w ^ active_low_w) & level_mask_w;

wire [31:0] edge_detect_w  = (input_last_q ^ gpio_input_value_in_w);
wire [31:0] edge_active_w  = (edge_detect_w & (gpio_input_value_in_w ^ falling_edge_w)) & edge_mask_w;

reg [31:0] interrupt_level_r;
always @ *
begin
    interrupt_raw_r = interrupt_raw_q;

    // Clear (ACK)
    if (gpio_int_clr_wr_req_w)
        interrupt_raw_r = interrupt_raw_r & ~gpio_int_clr_ack_out_w;

    // New interrupts
    interrupt_raw_r = interrupt_raw_r | level_active_w | edge_active_w;

    // Set (SW IRQ)
    if (gpio_int_set_wr_req_w)
        interrupt_raw_r = interrupt_raw_r | gpio_int_set_sw_irq_out_w;
end

always @ (posedge clk_i )
if (rst_i)
begin
    intr_q <= 1'b0;
    interrupt_raw_q  <= 32'b0;
end
else
begin
    intr_q           <= |(interrupt_raw_q & gpio_int_mask_enable_out_w);
    interrupt_raw_q  <= interrupt_raw_r;
end

assign gpio_int_status_raw_in_w = interrupt_raw_q;
assign intr_o                   = intr_q;

//-----------------------------------------------------------------
// Assignments
//-----------------------------------------------------------------
assign gpio_output_enable_o  = gpio_direction_output_out_w;


endmodule
