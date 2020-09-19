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

`define GPIO_DIRECTION    8'h0

    `define GPIO_DIRECTION_OUTPUT_DEFAULT    0
    `define GPIO_DIRECTION_OUTPUT_B          0
    `define GPIO_DIRECTION_OUTPUT_T          31
    `define GPIO_DIRECTION_OUTPUT_W          32
    `define GPIO_DIRECTION_OUTPUT_R          31:0

`define GPIO_INPUT    8'h4

    `define GPIO_INPUT_VALUE_DEFAULT    0
    `define GPIO_INPUT_VALUE_B          0
    `define GPIO_INPUT_VALUE_T          31
    `define GPIO_INPUT_VALUE_W          32
    `define GPIO_INPUT_VALUE_R          31:0

`define GPIO_OUTPUT    8'h8

    `define GPIO_OUTPUT_DATA_DEFAULT    0
    `define GPIO_OUTPUT_DATA_B          0
    `define GPIO_OUTPUT_DATA_T          31
    `define GPIO_OUTPUT_DATA_W          32
    `define GPIO_OUTPUT_DATA_R          31:0

`define GPIO_OUTPUT_SET    8'hc

    `define GPIO_OUTPUT_SET_DATA_DEFAULT    0
    `define GPIO_OUTPUT_SET_DATA_B          0
    `define GPIO_OUTPUT_SET_DATA_T          31
    `define GPIO_OUTPUT_SET_DATA_W          32
    `define GPIO_OUTPUT_SET_DATA_R          31:0

`define GPIO_OUTPUT_CLR    8'h10

    `define GPIO_OUTPUT_CLR_DATA_DEFAULT    0
    `define GPIO_OUTPUT_CLR_DATA_B          0
    `define GPIO_OUTPUT_CLR_DATA_T          31
    `define GPIO_OUTPUT_CLR_DATA_W          32
    `define GPIO_OUTPUT_CLR_DATA_R          31:0

`define GPIO_INT_MASK    8'h14

    `define GPIO_INT_MASK_ENABLE_DEFAULT    0
    `define GPIO_INT_MASK_ENABLE_B          0
    `define GPIO_INT_MASK_ENABLE_T          31
    `define GPIO_INT_MASK_ENABLE_W          32
    `define GPIO_INT_MASK_ENABLE_R          31:0

`define GPIO_INT_SET    8'h18

    `define GPIO_INT_SET_SW_IRQ_DEFAULT    0
    `define GPIO_INT_SET_SW_IRQ_B          0
    `define GPIO_INT_SET_SW_IRQ_T          31
    `define GPIO_INT_SET_SW_IRQ_W          32
    `define GPIO_INT_SET_SW_IRQ_R          31:0

`define GPIO_INT_CLR    8'h1c

    `define GPIO_INT_CLR_ACK_DEFAULT    0
    `define GPIO_INT_CLR_ACK_B          0
    `define GPIO_INT_CLR_ACK_T          31
    `define GPIO_INT_CLR_ACK_W          32
    `define GPIO_INT_CLR_ACK_R          31:0

`define GPIO_INT_STATUS    8'h20

    `define GPIO_INT_STATUS_RAW_DEFAULT    0
    `define GPIO_INT_STATUS_RAW_B          0
    `define GPIO_INT_STATUS_RAW_T          31
    `define GPIO_INT_STATUS_RAW_W          32
    `define GPIO_INT_STATUS_RAW_R          31:0

`define GPIO_INT_LEVEL    8'h24

    `define GPIO_INT_LEVEL_ACTIVE_HIGH_DEFAULT    0
    `define GPIO_INT_LEVEL_ACTIVE_HIGH_B          0
    `define GPIO_INT_LEVEL_ACTIVE_HIGH_T          31
    `define GPIO_INT_LEVEL_ACTIVE_HIGH_W          32
    `define GPIO_INT_LEVEL_ACTIVE_HIGH_R          31:0

`define GPIO_INT_MODE    8'h28

    `define GPIO_INT_MODE_EDGE_DEFAULT    0
    `define GPIO_INT_MODE_EDGE_B          0
    `define GPIO_INT_MODE_EDGE_T          31
    `define GPIO_INT_MODE_EDGE_W          32
    `define GPIO_INT_MODE_EDGE_R          31:0

