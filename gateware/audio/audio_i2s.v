//-----------------------------------------------------------------
//                      Audio Controller
//                           V0.1
//                     Ultra-Embedded.com
//                     Copyright 2012-2019
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

module audio_i2s
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           audio_clk_i
    ,input           inport_tvalid_i
    ,input  [ 31:0]  inport_tdata_i
    ,input  [  3:0]  inport_tstrb_i
    ,input  [  3:0]  inport_tdest_i
    ,input           inport_tlast_i

    // Outputs
    ,output          inport_tready_o
    ,output          i2s_sck_o
    ,output          i2s_sdata_o
    ,output          i2s_ws_o
);



//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg         sck_q;
reg         sdata_q;
reg         ws_q;
reg [4:0]   bit_count_q;

wire bit_clock_w = audio_clk_i;

//-----------------------------------------------------------------
// Buffer
//-----------------------------------------------------------------
reg [31:0] buffer_q;
reg        pop_q;

always @ (posedge rst_i or posedge clk_i)
if (rst_i)
begin
    buffer_q <= 32'b0;
    pop_q    <= 1'b0;
end
// Capture the next sample 1 SCK period before needed
else if (bit_clock_w && (bit_count_q == 5'd0) && sck_q)
begin
    buffer_q <= inport_tdata_i;
    pop_q    <= 1'b1;
end
else
    pop_q   <= 1'b0;

assign inport_tready_o = pop_q;

//-----------------------------------------------------------------
// I2S Output Generator
//-----------------------------------------------------------------
reg next_data_q;

always @ (posedge rst_i or posedge clk_i)
if (rst_i) 
begin
    bit_count_q     <= 5'd31;
    sdata_q         <= 1'b0;
    ws_q            <= 1'b0;
    sck_q           <= 1'b0;
    next_data_q     <= 1'b0;
end 
else if (bit_clock_w)
begin
    // SCK 1->0 - Falling Edge - drive SDATA
    if (sck_q)
    begin
        // SDATA lags WS by 1 cycle
        sdata_q     <= next_data_q;

        // Drive data MSB first
        next_data_q <= buffer_q[bit_count_q];

        // WS = 0 (left), 1 = (right)
        ws_q        <= ~bit_count_q[4];

        bit_count_q <= bit_count_q - 5'd1;
    end

    sck_q <= ~sck_q;
end

assign i2s_sck_o   = sck_q;
assign i2s_sdata_o = sdata_q;
assign i2s_ws_o    = ws_q;


endmodule
