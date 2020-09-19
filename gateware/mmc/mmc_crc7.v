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
//-----------------------------------------------------------------
// Module: CRC7
//-----------------------------------------------------------------
module mmc_crc7
(
     input        clk_i
    ,input        rst_i
    ,input        clear_i    
    ,input        bitval_i
    ,input        enable_i
    ,output [6:0] crc_o
);

reg    [6:0] crc_q;   

always @ (posedge clk_i )
if (rst_i)
    crc_q <= 7'b0;
else if (clear_i)
    crc_q <= 7'b0;
else if (enable_i)
begin
    crc_q[6] <= crc_q[5];
    crc_q[5] <= crc_q[4];
    crc_q[4] <= crc_q[3];
    crc_q[3] <= crc_q[2] ^ (bitval_i ^ crc_q[6]);
    crc_q[2] <= crc_q[1];
    crc_q[1] <= crc_q[0];
    crc_q[0] <= bitval_i ^ crc_q[6];
end

assign crc_o = crc_q;

endmodule
