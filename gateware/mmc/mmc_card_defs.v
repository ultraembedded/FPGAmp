//-----------------------------------------------------------------
//                MMC (and derivative standards) Host
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

`define MMC_CONTROL    8'h0

    `define MMC_CONTROL_START      31
    `define MMC_CONTROL_START_DEFAULT    0
    `define MMC_CONTROL_START_B          31
    `define MMC_CONTROL_START_T          31
    `define MMC_CONTROL_START_W          1
    `define MMC_CONTROL_START_R          31:31

    `define MMC_CONTROL_ABORT      30
    `define MMC_CONTROL_ABORT_DEFAULT    0
    `define MMC_CONTROL_ABORT_B          30
    `define MMC_CONTROL_ABORT_T          30
    `define MMC_CONTROL_ABORT_W          1
    `define MMC_CONTROL_ABORT_R          30:30

    `define MMC_CONTROL_FIFO_RST      29
    `define MMC_CONTROL_FIFO_RST_DEFAULT    0
    `define MMC_CONTROL_FIFO_RST_B          29
    `define MMC_CONTROL_FIFO_RST_T          29
    `define MMC_CONTROL_FIFO_RST_W          1
    `define MMC_CONTROL_FIFO_RST_R          29:29

    `define MMC_CONTROL_BLOCK_CNT_DEFAULT    0
    `define MMC_CONTROL_BLOCK_CNT_B          8
    `define MMC_CONTROL_BLOCK_CNT_T          15
    `define MMC_CONTROL_BLOCK_CNT_W          8
    `define MMC_CONTROL_BLOCK_CNT_R          15:8

    `define MMC_CONTROL_WRITE      5
    `define MMC_CONTROL_WRITE_DEFAULT    0
    `define MMC_CONTROL_WRITE_B          5
    `define MMC_CONTROL_WRITE_T          5
    `define MMC_CONTROL_WRITE_W          1
    `define MMC_CONTROL_WRITE_R          5:5

    `define MMC_CONTROL_DMA_EN      4
    `define MMC_CONTROL_DMA_EN_DEFAULT    0
    `define MMC_CONTROL_DMA_EN_B          4
    `define MMC_CONTROL_DMA_EN_T          4
    `define MMC_CONTROL_DMA_EN_W          1
    `define MMC_CONTROL_DMA_EN_R          4:4

    `define MMC_CONTROL_WIDE_MODE      3
    `define MMC_CONTROL_WIDE_MODE_DEFAULT    0
    `define MMC_CONTROL_WIDE_MODE_B          3
    `define MMC_CONTROL_WIDE_MODE_T          3
    `define MMC_CONTROL_WIDE_MODE_W          1
    `define MMC_CONTROL_WIDE_MODE_R          3:3

    `define MMC_CONTROL_DATA_EXP      2
    `define MMC_CONTROL_DATA_EXP_DEFAULT    0
    `define MMC_CONTROL_DATA_EXP_B          2
    `define MMC_CONTROL_DATA_EXP_T          2
    `define MMC_CONTROL_DATA_EXP_W          1
    `define MMC_CONTROL_DATA_EXP_R          2:2

    `define MMC_CONTROL_RESP136_EXP      1
    `define MMC_CONTROL_RESP136_EXP_DEFAULT    0
    `define MMC_CONTROL_RESP136_EXP_B          1
    `define MMC_CONTROL_RESP136_EXP_T          1
    `define MMC_CONTROL_RESP136_EXP_W          1
    `define MMC_CONTROL_RESP136_EXP_R          1:1

    `define MMC_CONTROL_RESP48_EXP      0
    `define MMC_CONTROL_RESP48_EXP_DEFAULT    0
    `define MMC_CONTROL_RESP48_EXP_B          0
    `define MMC_CONTROL_RESP48_EXP_T          0
    `define MMC_CONTROL_RESP48_EXP_W          1
    `define MMC_CONTROL_RESP48_EXP_R          0:0

`define MMC_CLOCK    8'h4

    `define MMC_CLOCK_DIV_DEFAULT    1
    `define MMC_CLOCK_DIV_B          0
    `define MMC_CLOCK_DIV_T          7
    `define MMC_CLOCK_DIV_W          8
    `define MMC_CLOCK_DIV_R          7:0

`define MMC_STATUS    8'h8

    `define MMC_STATUS_CMD_IN      8
    `define MMC_STATUS_CMD_IN_DEFAULT    0
    `define MMC_STATUS_CMD_IN_B          8
    `define MMC_STATUS_CMD_IN_T          8
    `define MMC_STATUS_CMD_IN_W          1
    `define MMC_STATUS_CMD_IN_R          8:8

    `define MMC_STATUS_DAT_IN_DEFAULT    0
    `define MMC_STATUS_DAT_IN_B          4
    `define MMC_STATUS_DAT_IN_T          7
    `define MMC_STATUS_DAT_IN_W          4
    `define MMC_STATUS_DAT_IN_R          7:4

    `define MMC_STATUS_FIFO_EMPTY      3
    `define MMC_STATUS_FIFO_EMPTY_DEFAULT    0
    `define MMC_STATUS_FIFO_EMPTY_B          3
    `define MMC_STATUS_FIFO_EMPTY_T          3
    `define MMC_STATUS_FIFO_EMPTY_W          1
    `define MMC_STATUS_FIFO_EMPTY_R          3:3

    `define MMC_STATUS_FIFO_FULL      2
    `define MMC_STATUS_FIFO_FULL_DEFAULT    0
    `define MMC_STATUS_FIFO_FULL_B          2
    `define MMC_STATUS_FIFO_FULL_T          2
    `define MMC_STATUS_FIFO_FULL_W          1
    `define MMC_STATUS_FIFO_FULL_R          2:2

    `define MMC_STATUS_CRC_ERR      1
    `define MMC_STATUS_CRC_ERR_DEFAULT    0
    `define MMC_STATUS_CRC_ERR_B          1
    `define MMC_STATUS_CRC_ERR_T          1
    `define MMC_STATUS_CRC_ERR_W          1
    `define MMC_STATUS_CRC_ERR_R          1:1

    `define MMC_STATUS_BUSY      0
    `define MMC_STATUS_BUSY_DEFAULT    0
    `define MMC_STATUS_BUSY_B          0
    `define MMC_STATUS_BUSY_T          0
    `define MMC_STATUS_BUSY_W          1
    `define MMC_STATUS_BUSY_R          0:0

`define MMC_CMD0    8'hc

    `define MMC_CMD0_VALUE_DEFAULT    0
    `define MMC_CMD0_VALUE_B          0
    `define MMC_CMD0_VALUE_T          31
    `define MMC_CMD0_VALUE_W          32
    `define MMC_CMD0_VALUE_R          31:0

`define MMC_CMD1    8'h10

    `define MMC_CMD1_VALUE_DEFAULT    0
    `define MMC_CMD1_VALUE_B          0
    `define MMC_CMD1_VALUE_T          15
    `define MMC_CMD1_VALUE_W          16
    `define MMC_CMD1_VALUE_R          15:0

`define MMC_RESP0    8'h14

    `define MMC_RESP0_VALUE_DEFAULT    0
    `define MMC_RESP0_VALUE_B          0
    `define MMC_RESP0_VALUE_T          31
    `define MMC_RESP0_VALUE_W          32
    `define MMC_RESP0_VALUE_R          31:0

`define MMC_RESP1    8'h18

    `define MMC_RESP1_VALUE_DEFAULT    0
    `define MMC_RESP1_VALUE_B          0
    `define MMC_RESP1_VALUE_T          31
    `define MMC_RESP1_VALUE_W          32
    `define MMC_RESP1_VALUE_R          31:0

`define MMC_RESP2    8'h1c

    `define MMC_RESP2_VALUE_DEFAULT    0
    `define MMC_RESP2_VALUE_B          0
    `define MMC_RESP2_VALUE_T          31
    `define MMC_RESP2_VALUE_W          32
    `define MMC_RESP2_VALUE_R          31:0

`define MMC_RESP3    8'h20

    `define MMC_RESP3_VALUE_DEFAULT    0
    `define MMC_RESP3_VALUE_B          0
    `define MMC_RESP3_VALUE_T          31
    `define MMC_RESP3_VALUE_W          32
    `define MMC_RESP3_VALUE_R          31:0

`define MMC_RESP4    8'h24

    `define MMC_RESP4_VALUE_DEFAULT    0
    `define MMC_RESP4_VALUE_B          0
    `define MMC_RESP4_VALUE_T          31
    `define MMC_RESP4_VALUE_W          32
    `define MMC_RESP4_VALUE_R          31:0

`define MMC_TX    8'h28

    `define MMC_TX_DATA_DEFAULT    0
    `define MMC_TX_DATA_B          0
    `define MMC_TX_DATA_T          31
    `define MMC_TX_DATA_W          32
    `define MMC_TX_DATA_R          31:0

`define MMC_RX    8'h2c

    `define MMC_RX_DATA_DEFAULT    0
    `define MMC_RX_DATA_B          0
    `define MMC_RX_DATA_T          31
    `define MMC_RX_DATA_W          32
    `define MMC_RX_DATA_R          31:0

`define MMC_DMA    8'h30

    `define MMC_DMA_ADDR_DEFAULT    0
    `define MMC_DMA_ADDR_B          0
    `define MMC_DMA_ADDR_T          31
    `define MMC_DMA_ADDR_W          32
    `define MMC_DMA_ADDR_R          31:0

