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

module jpeg_core
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport_valid_i
    ,input  [ 31:0]  inport_data_i
    ,input           outport_accept_i

    // Outputs
    ,output          inport_accept_o
    ,output          outport_valid_o
    ,output [ 15:0]  outport_width_o
    ,output [ 15:0]  outport_height_o
    ,output [ 15:0]  outport_pixel_x_o
    ,output [ 15:0]  outport_pixel_y_o
    ,output [  7:0]  outport_pixel_r_o
    ,output [  7:0]  outport_pixel_g_o
    ,output [  7:0]  outport_pixel_b_o
    ,output          idle_o
);





aq_djpeg
u_core
(
    .clk(clk_i)
   ,.rst(~rst_i)

   // From FIFO
   ,.DataInEnable(inport_valid_i)
   ,.DataIn(inport_data_i)
   ,.DataInRead(inport_accept_o)
   ,.DataInReq()

   // Deocdeer Process Idle(1:Idle, 0:Run)
   ,.JpegDecodeIdle(idle_o)
   ,.JpegProgressive()

   ,.OutEnable(outport_valid_o)
   ,.OutReady(outport_accept_i)
   ,.OutWidth(outport_width_o)
   ,.OutHeight(outport_height_o)
   ,.OutPixelX(outport_pixel_x_o)
   ,.OutPixelY(outport_pixel_y_o)
   ,.OutR(outport_pixel_r_o)
   ,.OutG(outport_pixel_g_o)
   ,.OutB(outport_pixel_b_o)
);


endmodule
