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

`define IRQ_ISR    8'h0

    `define IRQ_ISR_STATUS_DEFAULT    0
    `define IRQ_ISR_STATUS_B          0
    `define IRQ_ISR_STATUS_T          6
    `define IRQ_ISR_STATUS_W          7
    `define IRQ_ISR_STATUS_R          6:0

`define IRQ_IPR    8'h4

    `define IRQ_IPR_PENDING_DEFAULT    0
    `define IRQ_IPR_PENDING_B          0
    `define IRQ_IPR_PENDING_T          6
    `define IRQ_IPR_PENDING_W          7
    `define IRQ_IPR_PENDING_R          6:0

`define IRQ_IER    8'h8

    `define IRQ_IER_ENABLE_DEFAULT    0
    `define IRQ_IER_ENABLE_B          0
    `define IRQ_IER_ENABLE_T          6
    `define IRQ_IER_ENABLE_W          7
    `define IRQ_IER_ENABLE_R          6:0

`define IRQ_IAR    8'hc

    `define IRQ_IAR_ACK_DEFAULT    0
    `define IRQ_IAR_ACK_B          0
    `define IRQ_IAR_ACK_T          6
    `define IRQ_IAR_ACK_W          7
    `define IRQ_IAR_ACK_R          6:0

`define IRQ_SIE    8'h10

    `define IRQ_SIE_SET_DEFAULT    0
    `define IRQ_SIE_SET_B          0
    `define IRQ_SIE_SET_T          6
    `define IRQ_SIE_SET_W          7
    `define IRQ_SIE_SET_R          6:0

`define IRQ_CIE    8'h14

    `define IRQ_CIE_CLR_DEFAULT    0
    `define IRQ_CIE_CLR_B          0
    `define IRQ_CIE_CLR_T          6
    `define IRQ_CIE_CLR_W          7
    `define IRQ_CIE_CLR_R          6:0

`define IRQ_IVR    8'h18

    `define IRQ_IVR_VECTOR_DEFAULT    0
    `define IRQ_IVR_VECTOR_B          0
    `define IRQ_IVR_VECTOR_T          31
    `define IRQ_IVR_VECTOR_W          32
    `define IRQ_IVR_VECTOR_R          31:0

`define IRQ_MER    8'h1c

    `define IRQ_MER_ME      0
    `define IRQ_MER_ME_DEFAULT    0
    `define IRQ_MER_ME_B          0
    `define IRQ_MER_ME_T          0
    `define IRQ_MER_ME_W          1
    `define IRQ_MER_ME_R          0:0

