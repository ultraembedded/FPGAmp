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

`define CONFIG    8'h0

    `define CONFIG_X2_MODE      2
    `define CONFIG_X2_MODE_DEFAULT    0
    `define CONFIG_X2_MODE_B          2
    `define CONFIG_X2_MODE_T          2
    `define CONFIG_X2_MODE_W          1
    `define CONFIG_X2_MODE_R          2:2

    `define CONFIG_INT_EN_SOF      1
    `define CONFIG_INT_EN_SOF_DEFAULT    0
    `define CONFIG_INT_EN_SOF_B          1
    `define CONFIG_INT_EN_SOF_T          1
    `define CONFIG_INT_EN_SOF_W          1
    `define CONFIG_INT_EN_SOF_R          1:1

    `define CONFIG_ENABLE      0
    `define CONFIG_ENABLE_DEFAULT    1
    `define CONFIG_ENABLE_B          0
    `define CONFIG_ENABLE_T          0
    `define CONFIG_ENABLE_W          1
    `define CONFIG_ENABLE_R          0:0

`define STATUS    8'h4

    `define STATUS_FB_PENDING      31
    `define STATUS_FB_PENDING_DEFAULT    0
    `define STATUS_FB_PENDING_B          31
    `define STATUS_FB_PENDING_T          31
    `define STATUS_FB_PENDING_W          1
    `define STATUS_FB_PENDING_R          31:31

    `define STATUS_V_POS_DEFAULT    0
    `define STATUS_V_POS_B          16
    `define STATUS_V_POS_T          30
    `define STATUS_V_POS_W          15
    `define STATUS_V_POS_R          30:16

    `define STATUS_H_POS_DEFAULT    0
    `define STATUS_H_POS_B          0
    `define STATUS_H_POS_T          15
    `define STATUS_H_POS_W          16
    `define STATUS_H_POS_R          15:0

`define FRAME_BUFFER    8'h8

    `define FRAME_BUFFER_ADDR_DEFAULT    196608
    `define FRAME_BUFFER_ADDR_B          8
    `define FRAME_BUFFER_ADDR_T          31
    `define FRAME_BUFFER_ADDR_W          24
    `define FRAME_BUFFER_ADDR_R          31:8

