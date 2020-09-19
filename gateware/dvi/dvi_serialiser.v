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
module dvi_serialiser
(
      input       clk_i
    , input       rst_i
    , input       strobe_i
    , input [9:0] data_i
    , output      serial_o
);

`ifndef verilator
ODDR
#(
     .DDR_CLK_EDGE("SAME_EDGE")
    ,.INIT(1'b0)
    ,.SRTYPE("ASYNC")
)
u_ddr_r
(
     .C(clk_i)
    ,.CE(1'b1)
    ,.D1(data_i[0])
    ,.D2(data_i[1])
    ,.Q(serial_o)
    ,.R(1'b0)
    ,.S(1'b0)
);
`else
// Hack - non-functional sim
assign serial_o = clk_i ? data_i[0] : data_i[1];
`endif

endmodule