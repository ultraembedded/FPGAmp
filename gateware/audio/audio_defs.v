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

`define AUDIO_CFG    8'h0

    `define AUDIO_CFG_INT_THRESHOLD_DEFAULT    0
    `define AUDIO_CFG_INT_THRESHOLD_B          0
    `define AUDIO_CFG_INT_THRESHOLD_T          15
    `define AUDIO_CFG_INT_THRESHOLD_W          16
    `define AUDIO_CFG_INT_THRESHOLD_R          15:0

    `define AUDIO_CFG_BYTE_SWAP      16
    `define AUDIO_CFG_BYTE_SWAP_DEFAULT    0
    `define AUDIO_CFG_BYTE_SWAP_B          16
    `define AUDIO_CFG_BYTE_SWAP_T          16
    `define AUDIO_CFG_BYTE_SWAP_W          1
    `define AUDIO_CFG_BYTE_SWAP_R          16:16

    `define AUDIO_CFG_CH_SWAP      17
    `define AUDIO_CFG_CH_SWAP_DEFAULT    0
    `define AUDIO_CFG_CH_SWAP_B          17
    `define AUDIO_CFG_CH_SWAP_T          17
    `define AUDIO_CFG_CH_SWAP_W          1
    `define AUDIO_CFG_CH_SWAP_R          17:17

    `define AUDIO_CFG_TARGET_DEFAULT    0
    `define AUDIO_CFG_TARGET_B          18
    `define AUDIO_CFG_TARGET_T          19
    `define AUDIO_CFG_TARGET_W          2
    `define AUDIO_CFG_TARGET_R          19:18

    `define AUDIO_CFG_VOL_CTRL_DEFAULT    0
    `define AUDIO_CFG_VOL_CTRL_B          24
    `define AUDIO_CFG_VOL_CTRL_T          26
    `define AUDIO_CFG_VOL_CTRL_W          3
    `define AUDIO_CFG_VOL_CTRL_R          26:24

    `define AUDIO_CFG_BUFFER_RST      31
    `define AUDIO_CFG_BUFFER_RST_DEFAULT    0
    `define AUDIO_CFG_BUFFER_RST_B          31
    `define AUDIO_CFG_BUFFER_RST_T          31
    `define AUDIO_CFG_BUFFER_RST_W          1
    `define AUDIO_CFG_BUFFER_RST_R          31:31

`define AUDIO_STATUS    8'h4

    `define AUDIO_STATUS_LEVEL_DEFAULT    0
    `define AUDIO_STATUS_LEVEL_B          16
    `define AUDIO_STATUS_LEVEL_T          31
    `define AUDIO_STATUS_LEVEL_W          16
    `define AUDIO_STATUS_LEVEL_R          31:16

    `define AUDIO_STATUS_FULL      1
    `define AUDIO_STATUS_FULL_DEFAULT    0
    `define AUDIO_STATUS_FULL_B          1
    `define AUDIO_STATUS_FULL_T          1
    `define AUDIO_STATUS_FULL_W          1
    `define AUDIO_STATUS_FULL_R          1:1

    `define AUDIO_STATUS_EMPTY      0
    `define AUDIO_STATUS_EMPTY_DEFAULT    0
    `define AUDIO_STATUS_EMPTY_B          0
    `define AUDIO_STATUS_EMPTY_T          0
    `define AUDIO_STATUS_EMPTY_W          1
    `define AUDIO_STATUS_EMPTY_R          0:0

`define AUDIO_CLK_DIV    8'h8

    `define AUDIO_CLK_DIV_WHOLE_CYCLES_DEFAULT    0
    `define AUDIO_CLK_DIV_WHOLE_CYCLES_B          0
    `define AUDIO_CLK_DIV_WHOLE_CYCLES_T          15
    `define AUDIO_CLK_DIV_WHOLE_CYCLES_W          16
    `define AUDIO_CLK_DIV_WHOLE_CYCLES_R          15:0

`define AUDIO_CLK_FRAC    8'hc

    `define AUDIO_CLK_FRAC_NUMERATOR_DEFAULT    0
    `define AUDIO_CLK_FRAC_NUMERATOR_B          0
    `define AUDIO_CLK_FRAC_NUMERATOR_T          15
    `define AUDIO_CLK_FRAC_NUMERATOR_W          16
    `define AUDIO_CLK_FRAC_NUMERATOR_R          15:0

    `define AUDIO_CLK_FRAC_DENOMINATOR_DEFAULT    0
    `define AUDIO_CLK_FRAC_DENOMINATOR_B          16
    `define AUDIO_CLK_FRAC_DENOMINATOR_T          31
    `define AUDIO_CLK_FRAC_DENOMINATOR_W          16
    `define AUDIO_CLK_FRAC_DENOMINATOR_R          31:16

`define AUDIO_FIFO_WRITE    8'h20

    `define AUDIO_FIFO_WRITE_CH_B_DEFAULT    0
    `define AUDIO_FIFO_WRITE_CH_B_B          0
    `define AUDIO_FIFO_WRITE_CH_B_T          15
    `define AUDIO_FIFO_WRITE_CH_B_W          16
    `define AUDIO_FIFO_WRITE_CH_B_R          15:0

    `define AUDIO_FIFO_WRITE_CH_A_DEFAULT    0
    `define AUDIO_FIFO_WRITE_CH_A_B          16
    `define AUDIO_FIFO_WRITE_CH_A_T          31
    `define AUDIO_FIFO_WRITE_CH_A_W          16
    `define AUDIO_FIFO_WRITE_CH_A_R          31:16

