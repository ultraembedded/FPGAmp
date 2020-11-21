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
module mclk_gen
(
     input           clk_i
    ,input           rst_i
    ,output          mclk_o
);

// 2.657312925170068 = (*2 = 4.42885 -> 60÷11.2896)
wire [15:0]  audio_clk_div_whole_cycles_out_w = 16'd2;
wire [15:0]  audio_clk_frac_numerator_out_w   = 16'd6573;
wire [15:0]  audio_clk_frac_denominator_out_w = 16'd10000;

//-----------------------------------------------------------------
// Clock Generator
//-----------------------------------------------------------------
reg        clk_out_q;
reg        clk_en_q;
reg [15:0] clk_div_q;
reg [15:0] clk_div_r;
reg [31:0] fraction_q;
reg [31:0] fraction_r;

/* verilator lint_off WIDTH */
always @ *
begin
    clk_div_r = clk_div_q;
    fraction_r = fraction_q;

    case (clk_div_q)
    0 :
    begin
        clk_div_r = clk_div_q + 16'd1;
    end
    audio_clk_div_whole_cycles_out_w - 16'd1:
    begin
        if (fraction_q < (audio_clk_frac_denominator_out_w - audio_clk_frac_numerator_out_w))
        begin
            fraction_r = fraction_q + audio_clk_frac_numerator_out_w;
            clk_div_r  = 16'd0;
        end
        else
        begin
            fraction_r = fraction_q + audio_clk_frac_numerator_out_w - audio_clk_frac_denominator_out_w;
            clk_div_r = clk_div_q + 16'd1;
        end
    end
    audio_clk_div_whole_cycles_out_w:
    begin
        clk_div_r = 16'd0;
    end

    default:
    begin
        clk_div_r = clk_div_q + 16'd1;
    end
    endcase
end
/* verilator lint_on WIDTH */

always @ (posedge clk_i )
if (rst_i)
    clk_div_q <= 16'd0;
else
    clk_div_q <= clk_div_r;

always @ (posedge clk_i )
if (rst_i)
    fraction_q <= 32'd0;
else
    fraction_q <= fraction_r;

always @ (posedge clk_i )
if (rst_i)
    clk_en_q <= 1'b0;
else
    clk_en_q <= (clk_div_q == 16'd0);

always @ (posedge clk_i )
if (rst_i)
    clk_out_q <= 1'b1;
else if (clk_en_q)
    clk_out_q <= ~clk_out_q;

assign mclk_o = clk_out_q;

endmodule
