`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/09 22:12:58
// Design Name: 
// Module Name: RF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RF #(parameter WORD=32,ARRAY=5)(
    input [ARRAY-1:0] ra0,
    input [ARRAY-1:0] ra1,
    input [ARRAY-1:0] ra2,
    input [ARRAY-1:0] wa,
    input [WORD-1:0] wd,
    input we,
    input rst,
    input clk,
    output [WORD-1:0] rd0,
    output [WORD-1:0] rd1,
    output [WORD-1:0] rd2
    );
    reg [WORD-1:0] regfile [0:2**ARRAY-1];
    assign rd0 = regfile [ra0];
    assign rd1 = regfile [ra1];
    assign rd2 = regfile [ra2];
    integer k;
    always @ (posedge clk, posedge rst)
    begin
    if (rst)
    for (k=0;k<2**ARRAY;k=k+1)
        regfile[k]=0;
    
    else
        begin
            if (we && |wa)
                regfile[wa] <= wd;
            regfile[0] <= 32'b0;
        end
    end
endmodule

