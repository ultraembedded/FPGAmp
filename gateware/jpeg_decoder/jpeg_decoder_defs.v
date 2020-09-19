//-----------------------------------------------------------------
//                       AXI-4 JPEG Decoder
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

`define JPEG_CTRL    8'h0

    `define JPEG_CTRL_START      31
    `define JPEG_CTRL_START_DEFAULT    0
    `define JPEG_CTRL_START_B          31
    `define JPEG_CTRL_START_T          31
    `define JPEG_CTRL_START_W          1
    `define JPEG_CTRL_START_R          31:31

    `define JPEG_CTRL_ABORT      30
    `define JPEG_CTRL_ABORT_DEFAULT    0
    `define JPEG_CTRL_ABORT_B          30
    `define JPEG_CTRL_ABORT_T          30
    `define JPEG_CTRL_ABORT_W          1
    `define JPEG_CTRL_ABORT_R          30:30

    `define JPEG_CTRL_LENGTH_DEFAULT    0
    `define JPEG_CTRL_LENGTH_B          0
    `define JPEG_CTRL_LENGTH_T          23
    `define JPEG_CTRL_LENGTH_W          24
    `define JPEG_CTRL_LENGTH_R          23:0

`define JPEG_STATUS    8'h4

    `define JPEG_STATUS_BUSY      0
    `define JPEG_STATUS_BUSY_DEFAULT    0
    `define JPEG_STATUS_BUSY_B          0
    `define JPEG_STATUS_BUSY_T          0
    `define JPEG_STATUS_BUSY_W          1
    `define JPEG_STATUS_BUSY_R          0:0

`define JPEG_SRC    8'h8

    `define JPEG_SRC_ADDR_DEFAULT    0
    `define JPEG_SRC_ADDR_B          0
    `define JPEG_SRC_ADDR_T          31
    `define JPEG_SRC_ADDR_W          32
    `define JPEG_SRC_ADDR_R          31:0

`define JPEG_DST    8'hc

    `define JPEG_DST_ADDR_DEFAULT    0
    `define JPEG_DST_ADDR_B          0
    `define JPEG_DST_ADDR_T          31
    `define JPEG_DST_ADDR_W          32
    `define JPEG_DST_ADDR_R          31:0

