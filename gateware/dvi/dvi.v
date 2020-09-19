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

module dvi
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           clk_x5_i
    ,input  [  7:0]  vga_red_i
    ,input  [  7:0]  vga_green_i
    ,input  [  7:0]  vga_blue_i
    ,input           vga_blank_i
    ,input           vga_hsync_i
    ,input           vga_vsync_i

    // Outputs
    ,output          dvi_red_o
    ,output          dvi_green_o
    ,output          dvi_blue_o
    ,output          dvi_clock_o
);



//-----------------------------------------------------------------
// TMDS encoders [clk]
//-----------------------------------------------------------------
wire [9:0]  tmds_red_w; 
wire [9:0]  tmds_green_w; 
wire [9:0]  tmds_blue_w;

dvi_tmds_encoder 
u_tmds_red
(
    .clk(clk_i),
    .reset(rst_i),
    .data(vga_red_i),
    .c(0),
    .blank(vga_blank_i),
    .encoded(tmds_red_w)
);

dvi_tmds_encoder
u_tmds_green
(
    .clk(clk_i),
    .reset(rst_i),
    .data(vga_green_i),
    .c(0),
    .blank(vga_blank_i),
    .encoded(tmds_green_w)
);

dvi_tmds_encoder 
u_tmds_blue
(
    .clk(clk_i),
    .reset(rst_i),
    .data(vga_blue_i),
    .c({vga_vsync_i,vga_hsync_i}),
    .blank(vga_blank_i),
    .encoded(tmds_blue_w)
);

//-----------------------------------------------------------------
// Clock crossing (clk -> clk_x5)
//-----------------------------------------------------------------
reg toggle_q;

always @ (posedge clk_i )
if (rst_i)
    toggle_q <= 1'b0;
else
    toggle_q <= ~toggle_q;

wire toggle_x5_w;

dvi_resync
u_resync
(
     .clk_i(clk_x5_i)
    ,.rst_i(rst_i)
    ,.async_i(toggle_q)
    ,.sync_o(toggle_x5_w)
);

reg toggle_x5_q;

always @ (posedge clk_x5_i )
if (rst_i)
    toggle_x5_q <= 1'b0;
else
    toggle_x5_q <= toggle_x5_w;

// capture_w is delays the capture in clk_x5_i of the tmds_xx_w signals
// to 2-3 cycles after they were last updated in clk_i.
wire capture_w = toggle_x5_w ^ toggle_x5_q;

reg [9:0] tmds_red_x5_q;
reg [9:0] tmds_green_x5_q;
reg [9:0] tmds_blue_x5_q;

always @ (posedge clk_x5_i )
if (rst_i)
begin
    tmds_red_x5_q   <= 10'b0;
    tmds_green_x5_q <= 10'b0;
    tmds_blue_x5_q  <= 10'b0;
end
else if (capture_w)
begin
    tmds_red_x5_q   <= tmds_red_w;
    tmds_green_x5_q <= tmds_green_w;
    tmds_blue_x5_q  <= tmds_blue_w;
end

//-----------------------------------------------------------------
// Output serialisers [clk_x5]
//-----------------------------------------------------------------
reg [9:0] dvi_red_q;
reg [9:0] dvi_green_q;
reg [9:0] dvi_blue_q;
reg [9:0] dvi_clock_q;
reg       dvi_strobe_q;

always @(posedge clk_x5_i )
if (rst_i)
    dvi_clock_q <= 10'b0000011111;
else
    dvi_clock_q <= {dvi_clock_q[1:0], dvi_clock_q[9:2]};

wire dvi_strobe_w = (dvi_clock_q == 10'b0001111100);

always @(posedge clk_x5_i )
if (rst_i)
    dvi_strobe_q <= 1'b0;
else
    dvi_strobe_q <= dvi_strobe_w;

always @(posedge clk_x5_i )
if (rst_i)
begin
    dvi_red_q   <= 10'b0;
    dvi_green_q <= 10'b0;
    dvi_blue_q  <= 10'b0;
end
else if (dvi_strobe_q) 
begin
    dvi_red_q   <= tmds_red_x5_q;
    dvi_green_q <= tmds_green_x5_q;
    dvi_blue_q  <= tmds_blue_x5_q;
end
else
begin
    dvi_red_q   <= {2'b00, dvi_red_q[9:2]};
    dvi_green_q <= {2'b00, dvi_green_q[9:2]};
    dvi_blue_q  <= {2'b00, dvi_blue_q[9:2]};
end

dvi_serialiser
u_ddr_r
(
     .clk_i(clk_x5_i)
    ,.rst_i(rst_i)
    ,.strobe_i(dvi_strobe_q)
    ,.data_i(dvi_red_q)
    ,.serial_o(dvi_red_o)
);

dvi_serialiser
u_ddr_g
(
     .clk_i(clk_x5_i)
    ,.rst_i(rst_i)
    ,.strobe_i(dvi_strobe_q)
    ,.data_i(dvi_green_q)
    ,.serial_o(dvi_green_o)
);

dvi_serialiser
u_ddr_b
(
     .clk_i(clk_x5_i)
    ,.rst_i(rst_i)
    ,.strobe_i(dvi_strobe_q)
    ,.data_i(dvi_blue_q)
    ,.serial_o(dvi_blue_o)
);

dvi_serialiser
u_ddr_c
(
     .clk_i(clk_x5_i)
    ,.rst_i(rst_i)
    ,.strobe_i(dvi_strobe_q)
    ,.data_i(dvi_clock_q)
    ,.serial_o(dvi_clock_o)
);



endmodule
