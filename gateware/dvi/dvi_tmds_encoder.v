//--------------------------------------------------------------------------------
//  Engineer: Mike Field <hamster@snap.net.nz>
//  
//  Description: TMDS Encoder 
//      8 bits colour, 2 control bits and one blanking bits in
//        10 bits of TMDS encoded data out
//      Clocked at the pixel clock
// 
//--------------------------------------------------------------------------------
//  See: http://hamsterworks.co.nz/mediawiki/index.php/Dvid_test
//       http://hamsterworks.co.nz/mediawiki/index.php/FPGA_Projects
// 
//  Copyright (c) 2012 Mike Field <hamster@snap.net.nz>
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//--------------------------------------------------------------------------------
module dvi_tmds_encoder
(
      input        clk
    , input        reset
    , input [7:0]  data
    , input [1:0]  c
    , input        blank
    , output [9:0] encoded
);

/* verilator lint_off WIDTH */
/* verilator lint_off UNOPTFLAT */
reg [9:0]  encoded_q;
wire [8:0] xored;
wire [8:0] xnored;
wire [3:0] ones;
reg [8:0]  data_word_r;
reg [8:0]  data_word_inv_r;
wire [3:0] data_word_disparity;
reg [3:0]  dc_bias_q;

// Work our the two different encodings for the byte
assign xored[0]  = data[0];
assign xored[1]  = data[1] ^ xored[0];
assign xored[2]  = data[2] ^ xored[1];
assign xored[3]  = data[3] ^ xored[2];
assign xored[4]  = data[4] ^ xored[3];
assign xored[5]  = data[5] ^ xored[4];
assign xored[6]  = data[6] ^ xored[5];
assign xored[7]  = data[7] ^ xored[6];
assign xored[8]  = 1'b1;
assign xnored[0] = data[0];
assign xnored[1] = ~(data[1] ^ xnored[0]);
assign xnored[2] = ~(data[2] ^ xnored[1]);
assign xnored[3] = ~(data[3] ^ xnored[2]);
assign xnored[4] = ~(data[4] ^ xnored[3]);
assign xnored[5] = ~(data[5] ^ xnored[4]);
assign xnored[6] = ~(data[6] ^ xnored[5]);
assign xnored[7] = ~(data[7] ^ xnored[6]);
assign xnored[8] = 1'b0;

// Count how many ones are set in data
assign ones = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7];

// Decide which encoding to use
always @ *
begin
    if(ones > 4 || (ones == 4 && data[0] == 1'b0))
    begin
        data_word_r      = xnored;
        data_word_inv_r  =  ~((xnored));
    end
    else
    begin
        data_word_r     = xored;
        data_word_inv_r =  ~((xored));
    end
end

// Work out the DC bias of the dataword
assign data_word_disparity = 4'b1100 + data_word_r[0] + data_word_r[1] + data_word_r[2] + data_word_r[3] + data_word_r[4] + data_word_r[5] + data_word_r[6] + data_word_r[7];

// Now work out what the output should be
always @(posedge clk or posedge reset)
if (reset)
begin
    encoded_q <= 10'b0;
    dc_bias_q <= 4'b0;
end
else if (blank == 1'b1)
begin
    // In the control periods, all values have and have balanced bit count
    case(c)
    2'b00   : encoded_q <= 10'b1101010100;
    2'b01   : encoded_q <= 10'b0010101011;
    2'b10   : encoded_q <= 10'b0101010100;
    default : encoded_q <= 10'b1010101011;
    endcase

    dc_bias_q <= 4'b0;
end
else
begin
    if (dc_bias_q == 4'b00000 || data_word_disparity == 0)
    begin
        // dataword has no disparity
        if(data_word_r[8] == 1'b1) 
        begin
            encoded_q <= {2'b 01,data_word_r[7:0]};
            dc_bias_q <= dc_bias_q + data_word_disparity;
        end
        else
        begin
            encoded_q <= {2'b 10,data_word_inv_r[7:0]};
            dc_bias_q <= dc_bias_q - data_word_disparity;
        end
    end
    else if((dc_bias_q[3] == 1'b0 && data_word_disparity[3] == 1'b0) || (dc_bias_q[3] == 1'b1 && data_word_disparity[3] == 1'b1))
    begin
        encoded_q <= {1'b1,data_word_r[8],data_word_inv_r[7:0]};
        dc_bias_q <= dc_bias_q + data_word_r[8] - data_word_disparity;
    end
    else
    begin
        encoded_q <= {1'b0,data_word_r};
        dc_bias_q <= dc_bias_q - data_word_inv_r[8] + data_word_disparity;
    end
end

assign encoded = encoded_q;

/* verilator lint_on UNOPTFLAT */
/* verilator lint_on WIDTH */

endmodule
