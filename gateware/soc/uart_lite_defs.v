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

`define ULITE_RX    8'h0

    `define ULITE_RX_DATA_DEFAULT    0
    `define ULITE_RX_DATA_B          0
    `define ULITE_RX_DATA_T          7
    `define ULITE_RX_DATA_W          8
    `define ULITE_RX_DATA_R          7:0

`define ULITE_TX    8'h4

    `define ULITE_TX_DATA_DEFAULT    0
    `define ULITE_TX_DATA_B          0
    `define ULITE_TX_DATA_T          7
    `define ULITE_TX_DATA_W          8
    `define ULITE_TX_DATA_R          7:0

`define ULITE_STATUS    8'h8

    `define ULITE_STATUS_IE      4
    `define ULITE_STATUS_IE_DEFAULT    0
    `define ULITE_STATUS_IE_B          4
    `define ULITE_STATUS_IE_T          4
    `define ULITE_STATUS_IE_W          1
    `define ULITE_STATUS_IE_R          4:4

    `define ULITE_STATUS_TXFULL      3
    `define ULITE_STATUS_TXFULL_DEFAULT    0
    `define ULITE_STATUS_TXFULL_B          3
    `define ULITE_STATUS_TXFULL_T          3
    `define ULITE_STATUS_TXFULL_W          1
    `define ULITE_STATUS_TXFULL_R          3:3

    `define ULITE_STATUS_TXEMPTY      2
    `define ULITE_STATUS_TXEMPTY_DEFAULT    0
    `define ULITE_STATUS_TXEMPTY_B          2
    `define ULITE_STATUS_TXEMPTY_T          2
    `define ULITE_STATUS_TXEMPTY_W          1
    `define ULITE_STATUS_TXEMPTY_R          2:2

    `define ULITE_STATUS_RXFULL      1
    `define ULITE_STATUS_RXFULL_DEFAULT    0
    `define ULITE_STATUS_RXFULL_B          1
    `define ULITE_STATUS_RXFULL_T          1
    `define ULITE_STATUS_RXFULL_W          1
    `define ULITE_STATUS_RXFULL_R          1:1

    `define ULITE_STATUS_RXVALID      0
    `define ULITE_STATUS_RXVALID_DEFAULT    0
    `define ULITE_STATUS_RXVALID_B          0
    `define ULITE_STATUS_RXVALID_T          0
    `define ULITE_STATUS_RXVALID_W          1
    `define ULITE_STATUS_RXVALID_R          0:0

`define ULITE_CONTROL    8'hc

    `define ULITE_CONTROL_IE      4
    `define ULITE_CONTROL_IE_DEFAULT    0
    `define ULITE_CONTROL_IE_B          4
    `define ULITE_CONTROL_IE_T          4
    `define ULITE_CONTROL_IE_W          1
    `define ULITE_CONTROL_IE_R          4:4

    `define ULITE_CONTROL_RST_RX      1
    `define ULITE_CONTROL_RST_RX_DEFAULT    0
    `define ULITE_CONTROL_RST_RX_B          1
    `define ULITE_CONTROL_RST_RX_T          1
    `define ULITE_CONTROL_RST_RX_W          1
    `define ULITE_CONTROL_RST_RX_R          1:1

    `define ULITE_CONTROL_RST_TX      0
    `define ULITE_CONTROL_RST_TX_DEFAULT    0
    `define ULITE_CONTROL_RST_TX_B          0
    `define ULITE_CONTROL_RST_TX_T          0
    `define ULITE_CONTROL_RST_TX_W          1
    `define ULITE_CONTROL_RST_TX_R          0:0

