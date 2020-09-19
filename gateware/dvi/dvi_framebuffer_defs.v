//-----------------------------------------------------------------
//                      DVI / HDMI Framebuffer
//                              V0.1
//                     github.com/ultraembedded
//                          Copyright 2020
//
//                 Email: admin@ultra-embedded.com
//
//                       License: MIT
//-----------------------------------------------------------------
// Copyright (c) 2020 github.com/ultraembedded
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

