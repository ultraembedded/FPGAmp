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

module audio_spdif
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
    ,output          spdif_o
);




wire bit_clock_w = audio_clk_i;

//-----------------------------------------------------------------
// Core SPDIF
//-----------------------------------------------------------------
spdif_core
u_core
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .bit_out_en_i(bit_clock_w),

    .spdif_o(spdif_o),

    .sample_i(inport_tdata_i),
    .sample_req_o(inport_tready_o)
);


endmodule
