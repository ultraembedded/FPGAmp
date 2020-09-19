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

module artix7_pll
(
    // Inputs
     input           clkref_i

    // Outputs
    ,output          clkout0_o
    ,output          clkout1_o
    ,output          clkout2_o
    ,output          clkout3_o
);





wire clkref_buffered_w;
wire clkfbout_w;
wire clkfbout_buffered_w;
wire pll_clkout0_w;
wire pll_clkout0_buffered_w;
wire pll_clkout1_w;
wire pll_clkout1_buffered_w;
wire pll_clkout2_w;
wire pll_clkout2_buffered_w;
wire pll_clkout3_w;
wire pll_clkout3_buffered_w;

// Input buffering
IBUF IBUF_IN
(
    .I (clkref_i),
    .O (clkref_buffered_w)
);

// Clocking primitive
PLLE2_BASE
#(
    .BANDWIDTH("OPTIMIZED"),      // OPTIMIZED, HIGH, LOW
    .CLKFBOUT_PHASE(0.0),         // Phase offset in degrees of CLKFB, (-360-360)
    .CLKIN1_PERIOD(10.0),         // Input clock period in ns resolution
    .CLKFBOUT_MULT(10),     // VCO=1000MHz

    // CLKOUTx_DIVIDE: Divide amount for each CLKOUT(1-128)
    .CLKOUT0_DIVIDE(10), // CLK0=100MHz
    .CLKOUT1_DIVIDE(5), // CLK1=200MHz
    .CLKOUT2_DIVIDE(20), // CLK2=50MHz
    .CLKOUT3_DIVIDE(4), // CLK3=250MHz

    // CLKOUTx_DUTY_CYCLE: Duty cycle for each CLKOUT
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT3_DUTY_CYCLE(0.5),

    // CLKOUTx_PHASE: Phase offset for each CLKOUT
    .CLKOUT0_PHASE(0.0),
    .CLKOUT1_PHASE(0.0),
    .CLKOUT2_PHASE(0.0),
    .CLKOUT3_PHASE(0.0),

    .DIVCLK_DIVIDE(1),            // Master division value (1-56)
    .REF_JITTER1(0.0),            // Ref. input jitter in UI (0.000-0.999)
    .STARTUP_WAIT("TRUE")         // Delay DONE until PLL Locks ("TRUE"/"FALSE")
)
u_pll
(
    .CLKFBOUT(clkfbout_w),
    .CLKOUT0(pll_clkout0_w),
    .CLKOUT1(pll_clkout1_w),
    .CLKOUT2(pll_clkout2_w),
    .CLKOUT3(pll_clkout3_w),
    .CLKOUT4(),
    .CLKOUT5(),
    .LOCKED(),
    .PWRDWN(1'b0),
    .RST(1'b0),
    .CLKIN1(clkref_buffered_w),
    .CLKFBIN(clkfbout_buffered_w)
);

BUFH u_clkfb_buf
(
    .I(clkfbout_w),
    .O(clkfbout_buffered_w)
);

//-----------------------------------------------------------------
// CLK_OUT0
//-----------------------------------------------------------------
assign pll_clkout0_buffered_w = pll_clkout0_w;

assign clkout0_o = pll_clkout0_buffered_w;


//-----------------------------------------------------------------
// CLK_OUT1
//-----------------------------------------------------------------
assign pll_clkout1_buffered_w = pll_clkout1_w;

assign clkout1_o = pll_clkout1_buffered_w;


//-----------------------------------------------------------------
// CLK_OUT2
//-----------------------------------------------------------------
assign pll_clkout2_buffered_w = pll_clkout2_w;

assign clkout2_o = pll_clkout2_buffered_w;


//-----------------------------------------------------------------
// CLK_OUT3
//-----------------------------------------------------------------
assign pll_clkout3_buffered_w = pll_clkout3_w;

assign clkout3_o = pll_clkout3_buffered_w;


endmodule
